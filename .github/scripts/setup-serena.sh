#!/usr/bin/env bash
# Prepare this checkout for Serena (symbol navigation over the C sources through clangd).
# Usage: bash .github/scripts/setup-serena.sh
# Writes only git-ignored files: compile_commands.json, taken from a dry run of the Makefile (nothing is
# built, no library has to be installed), and .serena/ (the project, C/C++ only, on the clangd from PATH).
# Run it again after the Makefile changes; a second run rewrites the same files.
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
cd "$root"

need() { command -v "$1" >/dev/null || { echo "setup-serena: '$1' not found on PATH: $2" >&2; exit 1; }; }
need clangd "install it (Debian/Ubuntu: apt install clangd, macOS: brew install llvm)"
need serena "install it (uv tool install serena-agent)"
need python3 "it turns the make dry run into compile_commands.json"

[[ -e .serena/project.yml ]] || out=$(serena project create --language cpp . 2>&1) || { echo "$out" >&2; exit 1; }
# pkg-config complains on stderr about every library that is not installed; the compile lines are still printed
make -nB 2>/dev/null | python3 -c '
import json, os, shlex, sys
root = os.getcwd()
db = []
for line in sys.stdin:
    try:
        args = shlex.split(line)
    except ValueError:
        continue
    if "-c" in args and args[-1].endswith((".c", ".cpp")):
        db.append({"directory": root, "file": os.path.join(root, args[-1]), "arguments": args})
if not db:
    sys.exit("setup-serena: the make dry run printed no compile command")
json.dump(db, sys.stdout, indent=1)
' > .serena/compile_commands.json.tmp
mv .serena/compile_commands.json.tmp compile_commands.json

# the local override pins the language server to the system clangd instead of the one Serena downloads
printf 'ls_specific_settings:\n  cpp:\n    ls_path: "%s"\n' "$(command -v clangd)" > .serena/project.local.yml

echo "setup-serena: $(grep -c '"file"' compile_commands.json) translation units in compile_commands.json, Serena project in .serena/"
