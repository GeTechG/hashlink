## Why
A program compiled by Haxe that only lists its resources does not load: `hl` prints `Invalid opcode field` and exits. `haxe.Resource.listNames()` reads the `name` of a `haxe._Resource.ResourceContent` and nothing else, so the compiler's DCE removes the fields `data` and `dataLen` and the class is left with one field. The code that fills the resource table is written by `genhl.ml` (`$resources`), not compiled from Haxe, and it numbers the fields by rank: `OSetField (ro,0,…)` for the name, `OSetField (ro,1,…)` for the data whatever the class still has, and `OSetField (ro,2,…)` only when a field `dataLen` exists. Checked with Haxe 4.3.6; the `development` branch has the same code.

So the compiler writes a field index the class does not have, and the verifier refuses it — against the requirement that compiler output is accepted. Accepting the opcode as it is is not an option: the JIT reads `rt->fields_indexes[1]` past a one-entry table and compiles a write at whatever offset it finds there, which is what the loader did before the verifier existed.

## What Changes
- An `OSetField` whose field index is past the fields of `haxe._Resource.ResourceContent` is replaced by `ONop` when the file is loaded: the field was removed because nothing reads it, so the write has no reader either.
- No change for any other class, for `OField`, or for a negative index: those are refused as before.

## Capabilities

### New Capabilities

### Modified Capabilities
- `bytecode-loading`: the write to a removed field of a resource is dropped instead of refused.

## Impact
- `src/code.c` (`hl_check_function`).
- Programs with `-resource` that use `haxe.Resource.listNames()` and neither `getString` nor `getBytes` load again. A program that uses one of those keeps `data`, and loaded before.
- The class is recognised by its name. A file that is not compiler output and names a class `haxe._Resource.ResourceContent` has its out-of-range field writes dropped instead of being refused; nothing is read or written out of bounds either way.
