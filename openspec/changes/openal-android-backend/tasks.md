## 1. Build

- [ ] 1.1 `libs/openal/CMakeLists.txt`: in the `DOWNLOAD_DEPENDENCIES` branch, configure OpenAL-soft with the default `CMAKE_FIND_LIBRARY_SUFFIXES`, not the static one
- [ ] 1.2 `libs/openal/CMakeLists.txt`: on Android, `ALSOFT_REQUIRE_OPENSL=ON`

## 2. Verification

- [ ] 2.1 The `android-openal-static` configuration with NDK r27: OpenAL-soft reports the OpenSL backend, `openal.hdll` links and needs `libOpenSLES.so`; before the change the backend is missing
- [ ] 2.2 On an Android emulator, a program linked to the static OpenAL-soft opens a device with `alcOpenDevice` and the log names the OpenSL backend
- [ ] 2.3 Cross-review of the branch diff
