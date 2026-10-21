## ADDED Requirements

### Requirement: Rename replaces an existing file
`sys_rename(from, to)` SHALL move `from` to `to` and return `true` on success, `false` on failure. When `to` is an existing file, it SHALL be replaced by `from`, on every platform, in one step: no moment where `to` is missing (POSIX `rename`; on Windows `MoveFileExW` with `MOVEFILE_REPLACE_EXISTING`). When `to` is an existing directory and `from` a file, the call SHALL fail and leave both untouched. Renaming a directory to a name that does not exist SHALL succeed.

#### Scenario: Replace an existing file
- **WHEN** `a.tmp` holds `new`, `a.txt` holds `old`, and `sys_rename("a.tmp", "a.txt")` is called
- **THEN** it returns `true`, `a.tmp` no longer exists and `a.txt` holds `new`

#### Scenario: Destination is a directory
- **WHEN** `a.tmp` is a file, `dir` is an existing directory, and `sys_rename("a.tmp", "dir")` is called
- **THEN** it returns `false`, and `a.tmp` and `dir` are unchanged

#### Scenario: Rename a directory
- **WHEN** `d1` is a directory, `d2` does not exist, and `sys_rename("d1", "d2")` is called
- **THEN** it returns `true` and `d2` is the former `d1`
