## 1. Build

- [x] 1.1 `libs/openal/CMakeLists.txt`: in the `DOWNLOAD_DEPENDENCIES` branch, configure OpenAL-soft with the default `CMAKE_FIND_LIBRARY_SUFFIXES`, not the static one
- [x] 1.2 `libs/openal/CMakeLists.txt`: on Android, `ALSOFT_REQUIRE_OPENSL=ON`

## 2. Verification

- [x] 2.1 The `android-openal-static` configuration with NDK r27: OpenAL-soft reports the OpenSL backend, `openal.hdll` links; before the change `Could NOT find OpenSL (missing: OPENSL_LIBRARY)` and the backends are PipeWire, WaveFile, Null. With `ALSOFT_BACKEND_OPENSL=OFF` the configure fails with "Failed to enable required OpenSL backend"
- [x] 2.2 On an Android emulator, a program linked to the static OpenAL-soft opens a device with `alcOpenDevice` and the log names the OpenSL backend (API 35 x86_64 emulator: before — `No playback backend available!`, 0xa004; after — `Created device …, "OpenSL"` and a context). A shell binary preloads `libOpenSLES.so` as zygote does for an app: a first `dlopen` of it outside zygote leaves a stale `dlerror()` that OpenAL-soft's `LoadLib` takes for a failure
- [x] 2.3 Cross-review of the branch diff (codex, lite, 1 round: clean)
