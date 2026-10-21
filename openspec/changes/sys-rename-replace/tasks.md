## 1. Implementation

- [ ] 1.1 `src/std/sys.c`: on Windows, implement `hl_sys_rename` with `MoveFileExW(..., MOVEFILE_REPLACE_EXISTING | MOVEFILE_COPY_ALLOWED)`; drop the `rename` → `_wrename` define; other platforms keep `rename`

## 2. Verification

- [ ] 2.1 Host build (`make`) and the bytecode and HL/C smoke tests pass
- [ ] 2.2 Windows probe (the new `hl_sys_rename` body cross-compiled for Windows, run under Wine): rename over an existing file succeeds and the destination holds the new content; rename onto an existing directory fails and leaves both in place; renaming a directory to a free name succeeds
