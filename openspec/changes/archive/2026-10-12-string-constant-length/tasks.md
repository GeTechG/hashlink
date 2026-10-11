## 1. Runtime

- [x] 1.1 `hl_get_ustring` in `src/code.c`: buffer size in one helper, buffer zero-filled
- [x] 1.2 `hl_read_constant`: refuse a bytes field followed by an int field larger than the buffer of the string (`Invalid constant string`)

## 2. Verification

- [x] 2.1 A `.hl` file patched so that a `String` constant holds invalid UTF-8 is refused; the loader before the change runs it and reads the characters of the next constant
- [x] 2.2 A file with invalid UTF-8 in a string outside constants (a class name) still loads and runs
- [x] 2.3 `HelloWorld` (bytecode and HL/C), `other/tests/Surrogate` and literals with NUL still pass
- [x] 2.4 Cross-review of the branch diff
