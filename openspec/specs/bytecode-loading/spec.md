# bytecode-loading Specification

## Purpose
What `hl_code_read` guarantees about a `.hl` file before the module is initialised and compiled: a malformed file is refused, never executed.

## Requirements

### Requirement: A malformed bytecode file is refused, not executed
`hl_code_read` SHALL return NULL and set `error_msg` for a file it cannot accept. It SHALL NOT abort the process: the caller (program start, hot reload, plugin load) decides what a refusal means.

#### Scenario: Truncated file
- **WHEN** a `.hl` file is cut short
- **THEN** `hl_code_read` returns NULL with an error message and the process keeps running

### Requirement: Opcode operands are verified before the JIT
For every function, the loader SHALL verify the operands that the JIT uses while compiling it, and refuse the file when one is invalid:
- every register operand, including the argument lists of calls, is a register of the function;
- every jump target (conditional and unconditional jumps, `OSwitch` cases, `OTrap`) is an opcode of the function, and an `OTrap` target comes after the trap;
- a field index (`OField`, `OSetField`, `OGetThis`, `OSetThis`, `OPrefetch`, `OCallMethod` on a virtual) exists in the type of the register it applies to;
- the method of an `OVirtualClosure` exists in the class of the register and is a bytecode function, and the function of an `OInstanceClosure` is a bytecode function;
- an enum constructor index and its parameter index or count (`OMakeEnum`, `OEnumAlloc`, `OEnumField`, `OSetEnumField`) exist in the enum type of the register;
- the result register of an arithmetic operation is not `void`, and the result of `ORefOffset` is a reference;
- the function's own type is a function type with no more arguments than registers.

#### Scenario: Register out of range
- **WHEN** an opcode of a function names register 40 and the function has 12 registers
- **THEN** `hl_code_read` refuses the file with `Invalid opcode register`

#### Scenario: Jump out of the function
- **WHEN** a jump offset leads before the first or past the last opcode of its function
- **THEN** `hl_code_read` refuses the file with `Invalid opcode jump`

#### Scenario: Field of the wrong type
- **WHEN** an `OField` names field 7 of a register whose class has 3 fields, or of a register that is not an object or a virtual
- **THEN** `hl_code_read` refuses the file with `Invalid opcode field`

### Requirement: The verifier does not refuse compiler output
The loader SHALL accept every file produced by the Haxe compiler. A check is added only for an operand the JIT reads without checking it; the loader does not type-check the code.

#### Scenario: Valid program
- **WHEN** a program compiled by `haxe -hl` is loaded
- **THEN** it loads, compiles and runs as before

#### Scenario: Well-formed but wrong code
- **WHEN** a function passes a register of the wrong type to a call
- **THEN** the loader accepts the file; what the code does when it runs is outside this capability
