## MODIFIED Requirements

### Requirement: The verifier does not refuse compiler output
The loader SHALL accept every file produced by the Haxe compiler. A check is added only for an operand the JIT reads without checking it; the loader does not type-check the code.

The compiler fills the resource table with code that numbers the fields of `haxe._Resource.ResourceContent` by rank, including the ones its DCE has removed. An `OSetField` on a register of the class named `haxe._Resource.ResourceContent` whose field index is positive and past the fields of the class SHALL be replaced by `ONop` instead of being refused. This is the only exception to the field check: any other field index out of range is refused.

#### Scenario: Valid program
- **WHEN** a program compiled by `haxe -hl` is loaded
- **THEN** it loads, compiles and runs as before

#### Scenario: Well-formed but wrong code
- **WHEN** a function passes a register of the wrong type to a call
- **THEN** the loader accepts the file; what the code does when it runs is outside this capability

#### Scenario: Resource whose data is not read
- **WHEN** a program compiled with `-resource` calls `haxe.Resource.listNames()` and neither `getString` nor `getBytes`, so that `ResourceContent` keeps only its field `name`
- **THEN** the file loads and runs, and the write to field 1 of the resource is not executed

#### Scenario: Removed field of another class
- **WHEN** an `OSetField` names field 1 of a register whose class has one field and is not `haxe._Resource.ResourceContent`
- **THEN** `hl_code_read` refuses the file with `Invalid opcode field`
