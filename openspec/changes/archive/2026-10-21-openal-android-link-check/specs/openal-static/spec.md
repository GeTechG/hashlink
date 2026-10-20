## ADDED Requirements

### Requirement: CI links openal.hdll to the static OpenAL-soft for Android
The fork's `CI` workflow SHALL build, on every push to `master` and every pull request, `openal.hdll` for Android as a shared library linked with `-Wl,--no-undefined` to the static OpenAL-soft that `libs/openal/CMakeLists.txt` pins, and SHALL fail when that link fails.

#### Scenario: An undefined OpenAL symbol
- **WHEN** `openal.c` built with `OPENAL_STATIC` references a function the pinned OpenAL-soft does not export
- **THEN** the `android-openal-static` job fails with an undefined reference to it

#### Scenario: openal.hdll links
- **WHEN** every `al*` and `alc*` symbol `openal.c` references is exported by the pinned OpenAL-soft
- **THEN** the job passes
