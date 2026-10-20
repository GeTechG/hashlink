## Why
The `build-android` job of the upstream `Build` workflow configures with `BUILD_SHARED_LIBS=OFF` and without `WITH_STATIC_OPENAL`: `openal.hdll` comes out as a static archive that nothing links, so an undefined `al*` symbol (as `alRequestFoldbackStart`/`alRequestFoldbackStop` were before `openal-static-foldback`) passes CI and breaks only in the Android HL/C application that links it.

## What Changes
- A new job `android-openal-static` in the fork's `CI` workflow (`.github/workflows/ci.yml`): Android arm64, `WITH_STATIC_OPENAL=ON`, `BUILD_SHARED_LIBS=ON`, every other library off; it builds the `openal.hdll` target, a shared library that `set_as_hdll` links with `-Wl,--no-undefined` to the static OpenAL-soft. An undefined symbol fails the job.
- The check lives in `ci.yml`, not in the upstream `build.yml`: it guards a fork rule (the `openal-static` spec), runs where the other fork checks run, and leaves `build.yml` identical to upstream.

## Capabilities

### New Capabilities

### Modified Capabilities
- `openal-static`: CI proves on every push to `master` and every PR that `openal.hdll` links to the static OpenAL-soft for Android.

## Impact
- `.github/workflows/ci.yml` only (infrastructure). One more CI job, a few minutes (OpenAL-soft is built from source).
