## Why
`hl_code_read` checks the counts, sizes and table indexes of a `.hl` file, but nothing checks the opcode operands that depend on the function: a file with one changed byte in a function body loads and then crashes the process inside the JIT (`src/jit_emit.c`) — out-of-range register, jump target, field or constructor index. For hot reload and plugins a corrupted file must be refused, not take the host down.

## What Changes
- The loader verifies, per function, every operand the JIT uses while compiling: register indexes, jump targets, and the field, method and enum constructor indexes it looks up in the type of a register. A file that fails is refused through `error_msg`, like any other malformed file.
- The loader also refuses a packed type that does not wrap an object type, a native whose type is not a function, and an `OCatch` whose global is out of range.
- No change for bytecode produced by the Haxe compiler.

## Capabilities

### New Capabilities
- `bytecode-loading`: what `hl_code_read` guarantees about a `.hl` file before the module is initialised and compiled.

### Modified Capabilities

## Impact
- `src/code.c` (the verifier), `src/jit_emit.c` (one bounds guard in the `OTrap` lookahead).
- Load time: one extra linear pass over the opcodes.
