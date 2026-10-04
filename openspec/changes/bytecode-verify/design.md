## Context
The JIT front end reads opcode operands as trusted: `R(o->p1)` indexes the register array, jumps index `pos_map`, `OField` indexes `fields_indexes` of the register's type, and so on. A `jit_error` inside the JIT is already a clean refusal (`hl_jit_function` returns -1, `hl_module_init` fails), but most of these reads happen without any check.

## Goals / Non-Goals
**Goals:** a corrupted function body is refused before the JIT sees it; valid compiler output is never refused.
**Non-Goals:** type-checking the code. A function that is well formed but wrong (a register of the wrong type passed to a call, a bad virtual method slot) still compiles and misbehaves when it runs; that is not a loader concern.

## Decisions
- **A verifier pass in `hl_code_read`, not checks spread through `jit_emit.c`.** The loader already owns refusal through `error_msg`, runs once for every way code enters the VM (start, hot reload, plugins), and protects the other readers of the opcodes (hashing, module init) too. Checks inside the JIT would have to be repeated at every use of an operand and would leave those other readers exposed.
- **The rule for what is checked: what the JIT dereferences at compile time.** The meaning of each operand is taken from `emit_opcode`, not from the table in `opcodes.h`, which is inaccurate for some opcodes (`OEndTrap`, `OEnumAlloc`, `ORefOffset`). Conditions on which the JIT already raises `jit_error` are not duplicated.
- **A jump target must be an opcode of the function (`< nops`)**, not `<= nops`: the JIT has no position for "past the last opcode", and the compiler always ends a function with `ORet`.
- **The JIT keeps one guard of its own**: the `OTrap` lookahead reads the opcode after the catch target, which may be past the end in valid code.

## Risks / Trade-offs
- A check stricter than what the compiler emits would refuse valid programs → every check mirrors a dereference the JIT already makes unconditionally; verified against the repo tests and a build of the whole Haxe standard library with `-dce no`.
