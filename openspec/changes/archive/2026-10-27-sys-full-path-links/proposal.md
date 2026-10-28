## Why
`sys_full_path` (`sys.FileSystem.fullPath`) is how a caller gets the canonical path, for example to check that a path lies inside a directory. On POSIX it is `realpath`, which resolves symbolic links. On Windows `hl_sys_full_path` only calls `GetFullPathNameW` and fixes the case of each component with `FindFirstFileW`; symbolic links and junctions are left as they are. So a link `saves -> C:\elsewhere` inside a directory still looks like it is inside that directory, and a containment check built on `fullPath` passes on Windows where it fails on Linux.

## What Changes
- On desktop Windows, after `GetFullPathNameW`, `hl_sys_full_path` opens the path (`CreateFileW` with `FILE_FLAG_BACKUP_SEMANTICS`, so directories open too, and no access rights requested) and takes `GetFinalPathNameByHandleW(FILE_NAME_NORMALIZED | VOLUME_NAME_DOS)`. Every symbolic link and junction in the path is resolved, as `realpath` does. The `\\?\` prefix is dropped (`\\?\C:\a` → `C:\a`, `\\?\UNC\server\share` → `\\server\share`). The drive letter upper-casing and the case fix-up stay.
- When the path cannot be opened (it does not exist, access is denied) or the final path does not fit in `MAX_PATH` or has no DOS name, the result is what it was before: `GetFullPathNameW` with the case fix-up.
- Xbox and the other platforms are unchanged.

## Capabilities

### New Capabilities
- `sys-full-path`: what `sys_full_path` returns, and that links are resolved on every platform.

### Modified Capabilities

## Impact
- `src/std/sys.c` (code). Windows desktop only; a path through a symbolic link or junction now resolves to its target.
