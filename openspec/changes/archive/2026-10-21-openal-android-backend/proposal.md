## Why
`libs/openal/CMakeLists.txt` sets `CMAKE_FIND_LIBRARY_SUFFIXES` to the static suffix when `WITH_STATIC_OPENAL=ON`, and with `DOWNLOAD_DEPENDENCIES` the OpenAL-soft it fetches inherits it. Its `FindOpenSL` then looks for `libOpenSLES.a`, which the NDK does not ship (only `libOpenSLES.so`), so OpenAL-soft is built for Android without the OpenSL ES backend and without any error. On a device it logs `No playback backend available!` and the game is silent.

## What Changes
- With `DOWNLOAD_DEPENDENCIES`, OpenAL-soft is configured with the default library suffixes: the static suffix applies to OpenAL itself (built as `LIBTYPE STATIC`), not to the system libraries it links, which stay shared.
- On Android, OpenAL-soft is configured with `ALSOFT_REQUIRE_OPENSL=ON`: a build without the OpenSL ES backend fails at configure time instead of producing a silent game.

## Capabilities

### New Capabilities

### Modified Capabilities
- `openal-static`: the OpenAL-soft fetched for Android has the OpenSL ES playback backend, or the configure fails.

## Impact
- `libs/openal/CMakeLists.txt` (code). `libopenal.a` for Android gains `alc/backends/opensl.cpp`, which `dlopen`s the system `libOpenSLES.so` at run time; nothing new to link.
- The `android-openal-static` CI job configures the same way, so it now also fails when OpenSL ES is not found.
