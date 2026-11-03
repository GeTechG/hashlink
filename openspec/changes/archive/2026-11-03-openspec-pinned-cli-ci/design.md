## Context
OpenSpec 1.16.0 is installed globally on the maintainer's machine, one version for Sprout and every fork. The repository had no pin, no skills and no OpenSpec check in CI.

## Decisions
- **Pin file, global install.** `openspec/cli.pin` is the single source of the version. No `package.json` here (upstream has none at the root and the fork should not add one). Locally the global `openspec` is used; `openspec/check.sh` fails when `openspec --version` differs from the pin, so a stale install is caught before a push. CI calls `npm exec --yes --package=@fission-ai/openspec@<pin> -- openspec`, passed to the script through `OPENSPEC`.
- **Two generated skill sets.** `openspec init --tools claude,codex` writes different text for the two tools (Codex invokes skills with `$`), so `.claude/skills/openspec-*` and `.agents/skills/openspec-*` are both real, generated directories rather than one symlinked to the other. The existing `baton` layout (`.agents/skills/baton`, linked from `.claude/skills/baton`) is kept.
- **Script in `openspec/`.** The check lives next to what it checks (`openspec/check.sh`), so the job and a local run call the same thing. It needs only bash, grep and the CLI.
- **Archived tasks.** An archived task is open when it is `- [ ]`; it is exempt only when `[human]` follows the task number (`- [ ] 4.1 [human] …`), not when the word appears anywhere on the line.
- **Specs rewritten, not loosened.** A long requirement keeps its SHALL sentence for one behaviour; the rest becomes scenarios of the same requirement or separate requirements. No behaviour is dropped.

## Risks
- `npm exec` downloads the CLI on every CI run (~seconds). Acceptable; no cache needed.
