## ADDED Requirements

### Requirement: The length of a String constant is verified against its string
For a constant with a bytes field followed by an int field, the loader SHALL refuse the file when the int is negative or larger than the number of UTF-16 code units in the buffer the runtime builds for the string. The loader SHALL NOT refuse a string for not being valid UTF-8: the string table of a compiler-written file can hold one outside constants.

#### Scenario: Invalid UTF-8 in a String constant
- **WHEN** a byte of the string of a `String` constant, other than the last of a NUL separated part, is replaced by `0xFF` and its length is left as the compiler wrote it
- **THEN** `hl_code_read` refuses the file with `Invalid constant string`

#### Scenario: Invalid last byte
- **WHEN** the last byte of the string of a `String` constant is replaced by `0xFF`
- **THEN** the loader accepts the file: the buffer is as long as the `String`, with a zero code unit in place of the byte

#### Scenario: Length larger than the string
- **WHEN** the length of a `String` constant is larger than the number of UTF-16 code units of its string
- **THEN** `hl_code_read` refuses the file with `Invalid constant string`

#### Scenario: Invalid UTF-8 outside constants
- **WHEN** a string that no constant refers to — a class name, the name of a resource — is not valid UTF-8
- **THEN** the loader does not refuse the file for it
