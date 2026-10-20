## 1. Library

- [x] 1.1 `libs/harfbuzz/CMakeLists.txt`: fetch the pinned HarfBuzz release, compile `src/harfbuzz.cc` into `harfbuzz.hdll`; `WITH_HARFBUZZ` in `libs/CMakeLists.txt`
- [x] 1.2 `libs/harfbuzz/harfbuzz.c`: face, font, buffer, shape, glyphs
- [x] 1.3 Haxe package `harfbuzz` (`Face`, `Font`, `Buffer`, `Direction`, `GlyphRun`) and `haxelib.json`

## 2. Tests

- [x] 2.1 `other/tests/Harfbuzz.hx` with two subset Noto fonts (OFL): ligature `fi`, `-liga`, Arabic, scale, not a font
- [x] 2.2 `CMakeLists.txt`: the test as bytecode under `hl` and as HL/C

## 3. Verification

- [x] 3.1 Desktop CMake build, `ctest` for the HarfBuzz tests, bytecode and HL/C
- [x] 3.2 Android NDK build (arm64-v8a and x86_64, static, as the `Build` workflow); the HL/C test run on the emulator (x86_64)
- [x] 3.3 Binary size measured and written in `design.md`
- [x] 3.4 `make`, `HelloWorld` in bytecode and in HL/C
- [ ] 3.5 Cross-review of the branch diff
