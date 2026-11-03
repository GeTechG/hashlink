# openspec-checks Specification

## Purpose
Which OpenSpec version this repository works with, and what CI checks in its specs, changes and skills with that version before a commit lands.

## Requirements

### Requirement: Pinned OpenSpec version
`openspec/cli.pin` SHALL hold exactly one OpenSpec version, and every OpenSpec check of this repository SHALL run that version of `@fission-ai/openspec`.

#### Scenario: CI runs the pinned CLI
- **WHEN** the `openspec` CI job runs
- **THEN** it runs the CLI through `npm exec --package=@fission-ai/openspec@<version in openspec/cli.pin>`

#### Scenario: A stale local install
- **WHEN** `openspec/check.sh` runs with an `openspec` whose `--version` differs from `openspec/cli.pin`
- **THEN** it fails and names both versions and the `npm i -g` command that installs the pin

### Requirement: Specs and changes validate strictly
The `openspec` CI job SHALL fail when `openspec validate --all --strict` reports any issue.

#### Scenario: A long requirement
- **WHEN** a main spec has a requirement whose text is longer than 500 characters
- **THEN** the job fails

#### Scenario: Clean tree
- **WHEN** every spec and active change validates under `--strict`
- **THEN** this step passes

### Requirement: Main specs have a real Purpose
The `openspec` CI job SHALL fail when the Purpose of a main spec under `openspec/specs/` starts with `TBD - created by archiving change`.

#### Scenario: Placeholder left by archive
- **WHEN** an archive creates a new main spec and its Purpose stays the generated placeholder
- **THEN** the job fails and names the spec

### Requirement: Active changes carry their metadata
The `openspec` CI job SHALL fail when a change directory under `openspec/changes/` (other than `archive/`) has no `.openspec.yaml`.

#### Scenario: Change written by hand
- **WHEN** a change directory is created without `openspec new change`, so it lacks `.openspec.yaml`
- **THEN** the job fails and names the change

### Requirement: Skills match the pinned version
The `openspec` CI job SHALL fail when an `openspec-*` skill under `.claude/skills/` or `.agents/skills/` names a `generatedBy` other than the version in `openspec/cli.pin`, or when there is no such skill.

#### Scenario: Pin raised without regenerating
- **WHEN** `openspec/cli.pin` names a new version and the skills still say `generatedBy: "<old version>"`
- **THEN** the job fails and names each stale skill

### Requirement: Archived changes leave no open agent task
The `openspec` CI job SHALL fail when an archived change's `tasks.md` has an unticked task (`- [ ]`) that is not marked `[human]` right after its task number.

#### Scenario: Open agent task
- **WHEN** an archived `tasks.md` contains `- [ ] 2.1 Run the tests`
- **THEN** the job fails and names the file and line

#### Scenario: Open human task
- **WHEN** an archived `tasks.md` contains `- [ ] 3.1 [human] Check on a device`
- **THEN** that line does not fail the job

#### Scenario: Human mentioned elsewhere on the line
- **WHEN** an archived `tasks.md` contains `- [ ] 2.2 Ask for [human] review`
- **THEN** the job fails for that line
