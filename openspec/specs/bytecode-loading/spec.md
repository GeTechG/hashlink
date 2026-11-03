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
For every function, the loader SHALL verify each operand the JIT reads while compiling it, and refuse the file when one is invalid. The operands verified are registers, jump targets, field indices, closure methods, enum constructors and parameters, result registers of arithmetic and `ORefOffset`, and the function's own type; the scenarios state each rule.

#### Scenario: Register out of range
- **WHEN** an opcode of a function names register 40 and the function has 12 registers, directly or in the argument list of a call
- **THEN** `hl_code_read` refuses the file with `Invalid opcode register`

#### Scenario: Jump out of the function
- **WHEN** the target of a conditional or unconditional jump, an `OSwitch` case or an `OTrap` leads before the first or past the last opcode of its function
- **THEN** `hl_code_read` refuses the file with `Invalid opcode jump`

#### Scenario: Trap target before the trap
- **WHEN** the target of an `OTrap` does not come after the trap
- **THEN** `hl_code_read` refuses the file

#### Scenario: Field of the wrong type
- **WHEN** an `OField`, `OSetField`, `OGetThis`, `OSetThis`, `OPrefetch` or `OCallMethod` on a virtual names field 7 of a register whose type has 3 fields, or of a register that is not an object or a virtual
- **THEN** `hl_code_read` refuses the file with `Invalid opcode field`

#### Scenario: Closure of something that is not a bytecode method
- **WHEN** the method of an `OVirtualClosure` does not exist in the class of its register or is not a bytecode function, or the function of an `OInstanceClosure` is not a bytecode function
- **THEN** `hl_code_read` refuses the file

#### Scenario: Enum constructor or parameter out of range
- **WHEN** an `OMakeEnum`, `OEnumAlloc`, `OEnumField` or `OSetEnumField` names a constructor, a parameter index or a parameter count that the enum type of its register does not have
- **THEN** `hl_code_read` refuses the file

#### Scenario: Result register of the wrong kind
- **WHEN** the result register of an arithmetic operation is `void`, or the result of `ORefOffset` is not a reference
- **THEN** `hl_code_read` refuses the file with `Invalid opcode type`

#### Scenario: Function type
- **WHEN** a function's own type is not a function type, or has more arguments than the function has registers
- **THEN** `hl_code_read` refuses the file with `Invalid function type`

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

### Requirement: Compiler output is accepted
The loader SHALL accept every file produced by the Haxe compiler. A check is added only for an operand the JIT reads without checking it; the loader does not type-check the code.

#### Scenario: Valid program
- **WHEN** a program compiled by `haxe -hl` is loaded
- **THEN** it loads, compiles and runs as before

#### Scenario: Well-formed but wrong code
- **WHEN** a function passes a register of the wrong type to a call
- **THEN** the loader accepts the file; what the code does when it runs is outside this capability

### Requirement: Removed fields of ResourceContent are skipped
The compiler numbers the fields of `haxe._Resource.ResourceContent` by rank, including fields its DCE removed. An `OSetField` on a register of that class whose field index is positive and past the fields of the class SHALL be replaced by `ONop` instead of being refused. This is the only exception to the field check.

#### Scenario: Resource whose data is not read
- **WHEN** a program compiled with `-resource` calls `haxe.Resource.listNames()` and neither `getString` nor `getBytes`, so that `ResourceContent` keeps only its field `name`
- **THEN** the file loads and runs, and the write to field 1 of the resource is not executed

#### Scenario: Removed field of another class
- **WHEN** an `OSetField` names field 1 of a register whose class has one field and is not `haxe._Resource.ResourceContent`
- **THEN** `hl_code_read` refuses the file with `Invalid opcode field`
