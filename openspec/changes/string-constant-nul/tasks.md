## 1. Runtime

- [x] 1.1 `hl_get_ustring` in `src/code.c`: convert `strings_lens[index]` bytes instead of stopping at the first NUL

## 2. Verification

- [x] 2.1 A literal with NUL in the middle, at the end, and next to 2- and 4-byte UTF-8 sequences has the characters the source has, on the bytecode and HL/C paths
- [x] 2.2 `HelloWorld` (bytecode and HL/C) and `other/tests/Surrogate` still pass
- [x] 2.3 Cross-review of the branch diff
