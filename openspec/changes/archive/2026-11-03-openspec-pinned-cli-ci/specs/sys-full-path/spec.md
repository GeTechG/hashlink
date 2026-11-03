## REMOVED Requirements

### Requirement: Full path resolves links
**Reason**: Split so that each requirement states one behaviour in at most 500 characters.
**Migration**: *Full path of an existing path resolves links*, *Links Windows cannot resolve are left as they are*, *Form of a Windows full path* state the same behaviour; nothing to migrate.

## ADDED Requirements

### Requirement: Full path of an existing path resolves links
`sys_full_path(path)` SHALL return the absolute path of an existing `path` with `.` and `..` removed and every symbolic link in it resolved: POSIX `realpath`; on desktop Windows symbolic links and junctions, directory or file, in any component. The Windows exceptions and the form of a Windows result are separate requirements.

#### Scenario: Directory junction or symbolic link
- **WHEN** `root\saves` is a junction or a directory symbolic link to `C:\elsewhere`, and `sys_full_path("root\\saves\\a.txt")` is called for an existing `C:\elsewhere\a.txt`
- **THEN** it returns `C:\elsewhere\a.txt`

#### Scenario: File symbolic link
- **WHEN** `root\link.txt` is a symbolic link to the file `C:\data\real.txt`
- **THEN** `sys_full_path("root\\link.txt")` returns `C:\data\real.txt`

### Requirement: Links Windows cannot resolve are left as they are
On Windows, when `path` cannot be opened (access denied), or its final path does not fit in `MAX_PATH` or has no drive-letter or UNC name, `sys_full_path` SHALL leave links unresolved, as for a missing path. On Xbox it SHALL never resolve them.

#### Scenario: Access denied
- **WHEN** `path` exists on desktop Windows but cannot be opened for lack of access
- **THEN** `sys_full_path` returns the same result as for a missing path at that location: the absolute path with links unresolved

#### Scenario: Xbox
- **WHEN** `sys_full_path` is called on Xbox for a path through a link
- **THEN** the link is not resolved

### Requirement: Form of a Windows full path
On Windows the result of `sys_full_path` SHALL use `\` separators, an upper-case drive letter, each component in the case stored on disk, and no `\\?\` prefix; a UNC path is returned as `\\server\share\...`.

#### Scenario: Path without links
- **WHEN** `c:\Data\File.TXT` exists as `C:\data\file.txt` and has no link in it
- **THEN** `sys_full_path("c:\\Data\\..\\Data\\File.TXT")` returns `C:\data\file.txt`

#### Scenario: UNC path
- **WHEN** `path` resolves to a file on a network share
- **THEN** the result starts with `\\server\share\`, not `\\?\UNC\`
