## ADDED Requirements

### Requirement: A string that is not valid UTF-8 has a bounded buffer
The UTF-16 buffer of a string that is not valid UTF-8 SHALL hold the conversion of each NUL separated part up to its first invalid sequence, followed by a terminator, and every code unit of the buffer SHALL be initialised. A `String` constant of a loaded file SHALL NOT be longer than the buffer of its string.

#### Scenario: Part ending with an invalid lead byte
- **WHEN** a string holds `a`, then the byte `0xF8`
- **THEN** its buffer is `a`, a zero code unit and the terminator
