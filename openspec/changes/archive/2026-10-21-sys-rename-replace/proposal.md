## Why
`sys_rename` (`sys.FileSystem.rename`, `sys.io.File` moves) is the C `rename`. On Windows that is `_wrename`, which fails when the destination file already exists, so a rename over an existing file is impossible and there is no atomic replace at all. The usual way to write a file safely — write a temporary file, then rename it over the target — does not work on Windows, and callers have to emulate it (move the old file aside, rename, restore after a crash). POSIX `rename` already replaces the destination atomically.

## What Changes
- On Windows, `hl_sys_rename` calls `MoveFileExW(from, to, MOVEFILE_REPLACE_EXISTING | MOVEFILE_COPY_ALLOWED)` instead of `_wrename`. An existing destination file is replaced, as POSIX `rename` does. `MOVEFILE_COPY_ALLOWED` keeps the moves across volumes that `_wrename` already allowed. A rename onto an existing directory still fails; renaming a directory to a free name still works.
- Other platforms are unchanged.

## Capabilities

### New Capabilities
- `sys-rename`: what `sys_rename` does when the destination exists.

### Modified Capabilities

## Impact
- `src/std/sys.c` (code). Windows only; a rename that used to fail because the destination file existed now succeeds.
