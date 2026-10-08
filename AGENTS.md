# hashlink — agent guide

Independent fork of `HaxeFoundation/hashlink` (the HashLink VM for Haxe). Its consumers pin it by commit; they do not dictate how it is worked on. This file is the source of truth here.

## Workflow
No pull requests: this fork is worked on solo. Work lives on branches and lands on `master` by rebase or merge; the only mandatory gate is green checks (see *Checks*) on the exact tree that lands. Work is scheduled by baton — load the `/baton` skill before filing or picking up an issue, or changing an issue's status, labels, `footprint` or blockers.

An issue runs the same seven steps, in order:

1. **OpenSpec change.** Branch `change/<ISSUE-KEY>-<openspec-name>` from `origin/master` — one task, one branch — and write the change under `openspec/changes/`. Skip the OpenSpec change — here and in step 3 — when the work is mechanical, i.e. nothing the project history needs a record of (docs, renames, config, a bug fix that returns behaviour to what a spec already states). Anything else that touches behaviour is not mechanical — the change is mandatory. A missing spec is never a reason to skip: when `openspec/specs/` does not yet cover the behaviour the task touches, the change adds that spec as a new capability, so the next task has it to work against. A skip is never silent: the report on the issue carries the line `OpenSpec skipped: <reason>`. The other steps stay. An issue labeled `gate:spec` stops here: push the artifacts, post a short plan on the issue, add `needs-human`; continue once the maintainer swaps it for `spec:approved`.
2. **Implement** the tasks.
3. **Test.** Verify the implementation against the change, then sync its specs and archive it as the **last commit of the branch** (never a separate push to `master`), rebase onto current `master` and run the checks. Unless the task is trivial (mechanical, or a few obvious lines), finish with a cross-review of the whole branch diff before the checks — `/ai-brainstorm:ai-review`, a judge from another model family — and fix or rebut its findings until clean.
4. **Human QA — only if the change has it.** Steps only a human can do are written `- [ ] N.M [human] …` in `tasks.md`; agents never tick them. If there are any, post them on the issue as a checklist a human can follow cold, add `needs-human` and stop; continue once the maintainer removes the label. No `[human]` tasks → skip.
5. **Merge** into `master`: `git merge --ff-only` for a single commit or a short linear series, `git merge --no-ff` for a multi-commit change. Push `master`. If `master` moved since the checks ran, rebase and run them again first.
6. **Clean up**: delete the branch (local and remote) and its worktree.
7. **Set the issue done.**

The maintainer decides architecture and end-user behaviour, nothing else — steps 1 (`gate:spec`) and 4 are the only points where an agent waits for a human. Work without an issue: mechanical edits may go straight to `master`.

## Commits
- Every commit is **code** (everything that exists upstream: sources under `src/`, `libs/`, `include/`, `other/`, build files, the upstream `Build` workflow, tests) or **infrastructure** (the paths listed in `.github/infra-paths`: this file, `openspec/`, our CI and scripts). Never both — CI rejects a mixed commit.
- OpenSpec artifacts (proposal, tasks, specs, archive) are infrastructure and never share a commit with code.
- Code commit messages are written as for upstream `HaxeFoundation/hashlink`: `Area: imperative summary` (e.g. `JIT: support hot reload`), no mention of consumers, their paths or their issue keys.
- An upstream PR is a cherry-pick of one task's code commits; keep them self-contained — each builds and makes sense without the infrastructure commits around it.
- Changing the list of infrastructure paths is an infrastructure commit.

## Checks before pushing
- `bash .github/scripts/check-commit-kinds-test.sh` — self-test of the commit-kind check.
- `bash .github/scripts/check-commit-kinds.sh origin/master..HEAD` — run it on your branch.
- For code commits, build and smoke-test (dependencies and details in `.github/copilot-instructions.md`):
  - `env=$(bash .github/scripts/setup-sdl3.sh) && eval "$env" && make` — builds `hl`, `libhl` and the libraries. The script is for machines without SDL3 dev files: it builds the SDL3 release the `Build` workflow uses into `~/.cache/hashlink/sdl3-<version>/` (no sudo, shared by all worktrees, a no-op once installed) and prints the `PKG_CONFIG_PATH`/`LD_LIBRARY_PATH` that point `make` at it. With a system SDL3, plain `make` is enough;
  - `haxe -hl hello.hl -cp other/tests -main HelloWorld -D interp && ./hl hello.hl` — bytecode path;
  - `haxe -hl src/_main.c -cp other/tests -main HelloWorld && make hlc && ./hlc` — HL/C path.
- The full platform matrix is the upstream `Build` workflow (`.github/workflows/build.yml`); it runs on every push and PR.

## Symbol navigation
Serena (MCP server, C/C++ through `clangd`) is wired in `.mcp.json` for Claude Code and `.codex/config.toml` for Codex. A fresh checkout or worktree needs one command before it answers:

- `bash .github/scripts/setup-serena.sh` — writes `compile_commands.json` from a dry run of the `Makefile` (nothing is built, SDL3 and the other libraries are not needed) and the Serena project in `.serena/`, pinned to the `clangd` on `PATH`. Both are git-ignored; the command is safe to repeat and is run again when the `Makefile` changes. It needs `clangd`, `serena` and `python3` on `PATH` and names the one that is missing.

Only the C/C++ sources are indexed (`src/`, `libs/`, `include/`); the Haxe code under `other/` and `libs/*/` is not.

## Structural search
`ast-grep` searches and rewrites code by shape: C and C++ with its built-in grammars, Haxe (`other/`, `libs/*/`) with the grammar `sgconfig.yml` loads. A fresh checkout or worktree needs one command:

- `bash .github/scripts/setup-ast-grep.sh` — links the pinned `ast-grep` and the Haxe grammar (`GeTechG/tree-sitter-haxe`) into the git-ignored `.ast-grep/`; version, checksum and grammar commit are pinned in the script, the downloads live in `~/.cache` and are shared by every checkout. Linux x86_64 only; it needs `curl`, `sha256sum`, `tar`, `git` and `cc`. Run `.ast-grep/ast-grep` from the repo root.

Three tools, three questions:

- **Serena** — where is this C/C++ symbol defined and who references it; what a rename touches. It sees through macros and knows types; it knows no Haxe.
- **`ast-grep`** — where does code of this shape occur, whatever the names in it, and a bulk rewrite by pattern (add `-r '<replacement>'`, review the diff it prints, then `-U` to apply). The only structural tool for the Haxe code.
- **Text search** — a literal string, a name inside a `#define` body, a comment or a string, a file that is neither C nor Haxe, and the cross-check of the other two.

A C pattern is written with its surroundings: a bare fragment is parsed as a top-level declaration, not as the expression it looks like, and silently matches nothing (`-p 'hl_alloc_dynamic($A)' -l c` finds 0). Give a whole function as the pattern and select the node meant:

- `.ast-grep/ast-grep run -p 'void f() { hl_alloc_dynamic($A); }' --selector call_expression -l c src libs` — the 14 calls. In a rule file the same is `pattern: {context: 'void f() { hl_alloc_dynamic($A); }', selector: call_expression}`. `-l c` covers `.c` and `.h`; the `.cpp` files need a second run with `-l cpp`.
- `.ast-grep/ast-grep run -p 'throw $E' -l haxe .` — Haxe patterns need no context.

When a pattern matches nothing, look at how it was parsed (`--debug-query=ast`) before believing the zero. What a structural search does not see: the body of a `#define` (the grammar keeps it as text, so `hl_error(…)` inside a macro is found only by a text search), and possibly code in a file the grammar could not parse cleanly — `.ast-grep/ast-grep run --kind ERROR -l c src libs` lists them (the `HL_PRIM`/`DEFINE_PRIM` macros do that to many), `-l haxe .` lists none today. Before acting on a count, compare it with a text search and explain each difference.

## Specs
`openspec/` holds this fork's own specs (`openspec/specs/`). Behaviour or rule changes go through `openspec/changes/`.
