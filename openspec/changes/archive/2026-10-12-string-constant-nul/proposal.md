## Why
A string literal that contains a NUL character is stored in the `.hl` file with its full byte length, and the compiler gives the `String` its full length in characters. `hl_get_ustring` ignored the stored length: it sized and converted the UTF-16 buffer up to the first NUL only. The `String` then had the full length over a buffer that ended at the NUL, and every character after it was read from whatever the `code->alloc` arena held next — usually another string constant, so the content depended on the order of first uses.

The file is correct (bytes and length are both there), so the fix belongs to the runtime, not to the compiler. HL/C is not affected: it does not go through `hl_get_ustring`.

## What Changes
- `hl_get_ustring` converts the whole string constant, `strings_lens[index]` bytes, NUL characters included.
- `hl_read_strings` pads the string data with two zero bytes: the UTF-8 decoding of an invalid string reads up to two bytes after its terminator, and with the change above that can be the last bytes of the data.
- No change for a string without NUL.

## Capabilities

### New Capabilities
- `string-constants`: what the runtime guarantees about the string constants of a loaded `.hl` file.

### Modified Capabilities

## Impact
- `src/code.c` (`hl_get_ustring`, `hl_read_strings`).
