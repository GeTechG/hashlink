## 1. Library

- [ ] 1.1 Root `CMakeLists.txt`: option `WITH_OPUS` (default on with CMake 3.18+)
- [ ] 1.2 `libs/fmt/CMakeLists.txt`: fetch the pinned opus and opusfile releases, compile their sources into `fmt.hdll` with `FMT_OPUS`
- [ ] 1.3 `libs/fmt/fmt.c`: `opus_open`, `opus_info`, `opus_tell`, `opus_seek`, `opus_read`; stubs that throw without `FMT_OPUS`

## 2. Tests

- [ ] 2.1 `other/tests/OpusTest.hx` with a mono and a stereo clip and their `opusdec` PCM: length, s16 and float PCM, seek, garbage, truncated and damaged streams
- [ ] 2.2 `CMakeLists.txt`: the test as bytecode under `hl` and as HL/C

## 3. Verification

- [ ] 3.1 Desktop CMake build, `ctest` for the Opus tests, bytecode and HL/C
- [ ] 3.2 `make`, `HelloWorld` in bytecode and in HL/C (fmt without Opus)
- [ ] 3.3 Cross-review of the branch diff
