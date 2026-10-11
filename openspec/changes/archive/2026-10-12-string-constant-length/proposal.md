## Why
`hl_get_ustring` sizes the UTF-16 buffer of a string constant with `hl_utf8_length`, which stops at the first invalid UTF-8 sequence. A `String` constant is a pair (string index, length) in the file; when the length is larger than what the bytes decode to — a damaged `.hl`, a hot reload or a plugin with invalid UTF-8 in the string table, or simply a wrong length — the characters past the end of the buffer are read from whatever the `code->alloc` arena holds next. Same class of error as the NUL case fixed before, for a file the compiler does not write.

Refusing every string that is not valid UTF-8 in `hl_read_strings` is not an option: the compiler does write such strings. Checked with Haxe 4.3.6: the name of `-resource file@name` goes into the string table as the bytes of the command line (`a\xE9b` stays `61 E9 62`), and bytecode before version 5 keeps `OBytes` data there. Only the strings of `String` constants are validated by the compiler (`to_utf8` in `genhl.ml`: `UTF8.validate`, Latin-1 fallback, the length counted from the validated string), and those are the only ones that carry a length the runtime trusts.

## What Changes
- `hl_code_read` refuses a file with `Invalid constant string` when a constant has a bytes field followed by an int field — the layout of `String`, the only constant the compiler writes — and the int is negative or larger than the number of UTF-16 code units the bytes decode to.
- `hl_get_ustring` zero-fills the buffer: `hl_utf8_length` counts a byte `>= 0xF8` that ends a part and `hl_from_utf8` writes nothing for it, so that code unit is part of the buffer the check above measures. The check is about bounds, not about UTF-8: such a constant is accepted and reads a zero there.
- No change for a string that is not part of a constant: it is decoded up to the first invalid sequence, as before, and its length is taken from its terminator.

## Capabilities

### New Capabilities

### Modified Capabilities
- `bytecode-loading`: the length of a `String` constant is verified against its string.
- `string-constants`: the buffer guarantee covers a string that is not valid UTF-8.

## Impact
- `src/code.c` (`hl_get_ustring`, `hl_read_constant`).
- A file whose `String` constant is longer than its string no longer loads. The compiler does not write one: the string of a constant has passed `UTF8.validate`, and for those the runtime and the compiler count the same. The one gap is a 5- or 6-byte UTF-8 sequence that encodes a code point below U+110000, which `UTF8.validate` may accept and only a macro can put in a literal; such a constant read out of bounds before and is refused now.
