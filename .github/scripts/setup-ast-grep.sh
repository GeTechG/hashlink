#!/usr/bin/env bash
# Prepare this checkout for ast-grep (search and rewrite by code shape: C and C++ with the built-in
# grammars, Haxe with the grammar sgconfig.yml loads).
# Usage: bash .github/scripts/setup-ast-grep.sh
# Writes only the git-ignored .ast-grep/: links to the ast-grep binary and to the Haxe grammar library.
# Both live in the per-user cache shared by every checkout, one directory per pin: the binary is the npm
# registry archive of @ast-grep/cli-linux-x64-gnu, checked against sg_sha256 (nothing of it is run to install
# it), in ~/.cache/ast-grep/<version>-<sha256>/; the grammar is GeTechG/tree-sitter-haxe built at
# grammar_commit (the repository commits its generated parser, so cc is the whole build) in
# ~/.cache/tree-sitter-haxe/<commit>/. A second run with both in place downloads and builds nothing.
# Linux x86_64 only.
set -euo pipefail
sg_version=0.45.3
sg_sha256=53828b0acd21dde9f866be2c8513135bf90db9f0c2d931475b8029c534be4ce9
grammar_commit=31ae7eb010e18975fd73cd65e14c71ef5054f9c7

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
cache=${XDG_CACHE_HOME:-$HOME/.cache}
sg_dir=$cache/ast-grep/$sg_version-$sg_sha256
grammar_dir=$cache/tree-sitter-haxe/$grammar_commit

[[ $(uname -sm) == "Linux x86_64" ]] || { echo "setup-ast-grep: only Linux x86_64 is pinned, this is $(uname -sm)" >&2; exit 1; }
need() { command -v "$1" >/dev/null || { echo "setup-ast-grep: '$1' not found on PATH" >&2; exit 1; }; }
for tool in curl sha256sum tar git cc; do need "$tool"; done

# each directory is filled aside and renamed into place, so it only ever appears complete
tmp=
trap 'rm -rf "$tmp"' EXIT
if [[ ! -x $sg_dir/ast-grep ]]; then
  mkdir -p "$cache/ast-grep"
  tmp=$(mktemp -d "$sg_dir.tmp.XXXXXX")
  echo "setup-ast-grep: downloading ast-grep $sg_version" >&2
  curl -fsSL --retry 3 -o "$tmp/sg.tgz" \
    "https://registry.npmjs.org/@ast-grep/cli-linux-x64-gnu/-/cli-linux-x64-gnu-$sg_version.tgz"
  echo "$sg_sha256  $tmp/sg.tgz" | sha256sum -c --quiet - \
    || { echo "setup-ast-grep: checksum mismatch for ast-grep $sg_version" >&2; exit 1; }
  tar -xzf "$tmp/sg.tgz" -C "$tmp" --strip-components=1 package/ast-grep
  rm "$tmp/sg.tgz"
  chmod 755 "$tmp"
  mv -T "$tmp" "$sg_dir" 2>/dev/null || true # a parallel run finished first: the same archive
  rm -rf "$tmp"
fi
[[ -x $sg_dir/ast-grep ]] || { echo "setup-ast-grep: no ast-grep in $sg_dir" >&2; exit 1; }

if [[ ! -f $grammar_dir/haxe.so ]]; then
  mkdir -p "$cache/tree-sitter-haxe"
  tmp=$(mktemp -d "$grammar_dir.tmp.XXXXXX")
  echo "setup-ast-grep: building tree-sitter-haxe $grammar_commit" >&2
  git init -q "$tmp"
  git -C "$tmp" fetch -q --depth 1 https://github.com/GeTechG/tree-sitter-haxe "$grammar_commit"
  git -C "$tmp" checkout -q FETCH_HEAD
  mkdir "$tmp/out"
  cc -shared -fPIC -O2 -I "$tmp/src" "$tmp"/src/*.c -o "$tmp/out/haxe.so"
  chmod 755 "$tmp/out"
  mv -T "$tmp/out" "$grammar_dir" 2>/dev/null || true # a parallel run finished first: the same commit
  rm -rf "$tmp"
fi
[[ -f $grammar_dir/haxe.so ]] || { echo "setup-ast-grep: no grammar library in $grammar_dir" >&2; exit 1; }

mkdir -p "$root/.ast-grep"
ln -sfn "$sg_dir/ast-grep" "$root/.ast-grep/ast-grep"
ln -sfn "$grammar_dir/haxe.so" "$root/.ast-grep/haxe.so"

# prove the pair works before saying so: the binary runs, loads the grammar through sgconfig.yml and matches
cd "$root"
echo 'class A { function f() { throw new B(1); } }' | .ast-grep/ast-grep run -p 'throw new $T($$$A)' -l haxe --stdin >/dev/null \
  || { echo "setup-ast-grep: .ast-grep/ast-grep does not match Haxe with $grammar_dir/haxe.so" >&2; exit 1; }
echo "setup-ast-grep: $(.ast-grep/ast-grep --version) and tree-sitter-haxe ${grammar_commit:0:8} in .ast-grep/"
