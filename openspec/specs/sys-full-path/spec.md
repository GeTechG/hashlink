# sys-full-path Specification

## Purpose
What `sys_full_path` (`sys.FileSystem.fullPath`) returns, and that it resolves symbolic links.

## Requirements

### Requirement: Full path resolves links
`sys_full_path(path)` SHALL return the absolute path of an existing `path` with `.` and `..` removed and every symbolic link in it resolved: POSIX `realpath`; on desktop Windows symbolic links and junctions (directory or file, in any component). On Windows, when the path cannot be opened (access denied) or its final path does not fit in `MAX_PATH` or has no drive-letter or UNC name, links are left unresolved, as for a missing path; on Xbox they are never resolved. On Windows the result SHALL use `\` separators, an upper-case drive letter, each component in the case stored on disk, and no `\\?\` prefix (a UNC path is returned as `\\server\share\...`).

#### Scenario: Directory junction or symbolic link
- **WHEN** `root\saves` is a junction or a directory symbolic link to `C:\elsewhere`, and `sys_full_path("root\\saves\\a.txt")` is called for an existing `C:\elsewhere\a.txt`
- **THEN** it returns `C:\elsewhere\a.txt`

#### Scenario: File symbolic link
- **WHEN** `root\link.txt` is a symbolic link to the file `C:\data\real.txt`
- **THEN** `sys_full_path("root\\link.txt")` returns `C:\data\real.txt`

#### Scenario: Path without links
- **WHEN** `c:\Data\File.TXT` exists as `C:\data\file.txt` and has no link in it
- **THEN** `sys_full_path("c:\\Data\\..\\Data\\File.TXT")` returns `C:\data\file.txt`

### Requirement: Full path of a missing path
When `path` does not exist, `sys_full_path` SHALL return `null` on POSIX (as `realpath`). On Windows it SHALL return the absolute path built from the current directory, with `.` and `..` removed and the existing leading components in the case stored on disk; links in it are not resolved.

#### Scenario: Missing file on Windows
- **WHEN** the current directory is `C:\work` and `missing.txt` does not exist
- **THEN** `sys_full_path("missing.txt")` returns `C:\work\missing.txt`
