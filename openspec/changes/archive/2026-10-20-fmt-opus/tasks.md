## 1. Library

- [x] 1.1 Root `CMakeLists.txt`: option `WITH_OPUS` (default on with CMake 3.18+)
- [x] 1.2 `libs/fmt/CMakeLists.txt`: fetch the pinned opus and opusfile releases, compile their sources into `fmt.hdll` with `FMT_OPUS`
- [x] 1.3 `libs/fmt/fmt.c`: `opus_open`, `opus_info`, `opus_tell`, `opus_seek`, `opus_read`; stubs that throw without `FMT_OPUS`

## 2. Tests

- [x] 2.1 `other/tests/OpusTest.hx` with a mono and a stereo clip and their `opusdec` PCM: length, s16 and float PCM, seek, garbage, truncated and damaged streams
- [x] 2.2 `CMakeLists.txt`: the test as bytecode under `hl` and as HL/C

## 3. Verification

- [x] 3.1 Desktop CMake build, `ctest` for the Opus tests, bytecode and HL/C
- [x] 3.2 `make`, `HelloWorld` in bytecode and in HL/C (fmt without Opus)
- [x] 3.3 The `Build` workflow on the branch: every CMake platform (Linux, macOS, Windows MSVC, MinGW, clang-cl; Opus tests in `ctest`), Android arm64, `make`, Visual Studio
- [x] 3.4 Cross-review of the branch diff (codex, 2 rounds: opus' stack arrays as VLAs, `alloca` only with MSVC, for strict C11; clean)
