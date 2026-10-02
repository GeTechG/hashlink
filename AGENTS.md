# hashlink — agent guide

Independent fork of `HaxeFoundation/hashlink` (the HashLink VM for Haxe). Its consumers pin it by commit; they do not dictate how it is worked on. This file is the source of truth here.

## Branches and delivery
- One task — one branch from `master`.
- No pull requests: this fork is worked on solo. When the task is done, run the checks on its branch, then rebase it onto `master` and fast-forward `master` to it (merge instead when a rebase is impractical) and push `master`.

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
  - `make` — builds `hl`, `libhl` and the libraries;
  - `haxe -hl hello.hl -cp other/tests -main HelloWorld -D interp && ./hl hello.hl` — bytecode path;
  - `haxe -hl src/_main.c -cp other/tests -main HelloWorld && make hlc && ./hlc` — HL/C path.
- The full platform matrix is the upstream `Build` workflow (`.github/workflows/build.yml`); it runs on every push and PR.

## Specs
`openspec/` holds this fork's own specs (`openspec/specs/`). Behaviour or rule changes go through `openspec/changes/`.
