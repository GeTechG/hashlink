## 1. CI

- [x] 1.1 `.github/workflows/ci.yml`: job `android-openal-static` — configure for Android arm64 with `BUILD_SHARED_LIBS=ON`, `WITH_STATIC_OPENAL=ON`, the other libraries off; build target `openal.hdll`

## 2. Verification

- [x] 2.1 The same configuration on the host (Linux) and with Android NDK r27c: `openal.hdll` links; with `openal.c` from before `openal-static-foldback` the link fails on `alRequestFoldbackStart`/`alRequestFoldbackStop`
- [x] 2.2 Cross-review of the branch diff (codex, lite, 2 rounds: the archive step was missing, then clean)
