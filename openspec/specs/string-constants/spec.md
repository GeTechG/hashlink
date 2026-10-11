# string-constants Specification

## Purpose
What the runtime guarantees about the string constants of a loaded `.hl` file.

## Requirements

### Requirement: A string constant keeps every character of the literal
The UTF-16 buffer the runtime builds for a string constant of a `.hl` file SHALL hold the conversion of all the bytes stored for it, NUL characters included, followed by a terminator. Its length in UTF-16 code units SHALL be the length the compiler gave the `String`, so no character of the `String` is read outside the buffer.

#### Scenario: NUL in the middle of a literal
- **WHEN** a program compiled by `haxe -hl` reads the characters of the literal `"a\x00b"`
- **THEN** they are `a`, NUL, `b`, and the literal equals `"a" + String.fromCharCode(0) + "b"`

#### Scenario: NUL next to multi-byte characters
- **WHEN** a literal holds a NUL before and after a character outside the BMP
- **THEN** the character is its surrogate pair, with a NUL on each side

#### Scenario: Literal without NUL
- **WHEN** a literal holds no NUL character
- **THEN** its buffer is the same as before

### Requirement: A string that is not valid UTF-8 has a bounded buffer
The UTF-16 buffer of a string that is not valid UTF-8 SHALL hold the conversion of each NUL separated part up to its first invalid sequence, followed by a terminator, and every code unit of the buffer SHALL be initialised. A `String` constant of a loaded file SHALL NOT be longer than the buffer of its string.

#### Scenario: Part ending with an invalid lead byte
- **WHEN** a string holds `a`, then the byte `0xF8`
- **THEN** its buffer is `a`, a zero code unit and the terminator
