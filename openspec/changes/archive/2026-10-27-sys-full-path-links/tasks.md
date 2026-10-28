## 1. Implementation

- [x] 1.1 `src/std/sys.c`: on desktop Windows, after `GetFullPathNameW`, open the path with `CreateFileW(..., OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS)`, take `GetFinalPathNameByHandleW(FILE_NAME_NORMALIZED | VOLUME_NAME_DOS)` and strip `\\?\` (`\\?\UNC\` → `\\`); fall back to the current result when the path cannot be opened or the final path does not fit

## 2. Verification

- [x] 2.1 Host build (`make`) and the bytecode and HL/C smoke tests pass
- [x] 2.2 [human] On Windows, build `hl` from this branch and check `sys.FileSystem.fullPath` (steps posted on the issue): a junction `mklink /J root\saves C:\elsewhere` and a directory symlink `mklink /D` resolve to `C:\elsewhere\...`; a file symlink `mklink` resolves to its target; a plain path with wrong case and `..` comes back in the on-disk case; a missing file returns `<cwd>\missing.txt`; a path on a network share (`\\server\share\...`) has no `\\?\` prefix
