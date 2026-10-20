## Why
`openal.hdll` built with `WITH_STATIC_OPENAL=ON` calls `alRequestFoldbackStart` and `alRequestFoldbackStop` directly. OpenAL-soft 1.24.3, the release `libs/openal/CMakeLists.txt` downloads, still declares them in `AL/alext.h` but implements and exports neither, so a program that links `openal.hdll` statically (the Android build of an HL/C game with sound) fails with two undefined symbols.

## What Changes
- With `OPENAL_STATIC`, `openal.c` no longer references the two foldback functions: `al_load_extensions` looks them up with `alGetProcAddress`, as the dynamic build already does for every extension function, and the foldback primitives keep their `CHECK_EXT` guard, which throws when the lookup found nothing.
- Every other primitive and the dynamic build are unchanged.

## Capabilities

### New Capabilities
- `openal-static`: what `openal.hdll` linked to a static OpenAL-soft needs from it, and what an extension function the library does not provide does at run time.

### Modified Capabilities

## Impact
- `libs/openal/openal.c` only. A static build of the pinned OpenAL-soft links; `ExtAL.requestFoldbackStart`/`requestFoldbackStop` throw "Unsupported extension function" with it, as they do with a dynamic OpenAL that lacks the extension.
