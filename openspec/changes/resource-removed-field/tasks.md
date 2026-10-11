## 1. Runtime

- [ ] 1.1 `hl_check_function` in `src/code.c`: an `OSetField` past the fields of `haxe._Resource.ResourceContent` becomes `ONop`

## 2. Verification

- [ ] 2.1 A program with `-resource` that only calls `haxe.Resource.listNames()` loads and runs; the loader before the change refuses it with `Invalid opcode field`
- [ ] 2.2 Programs that call `getString` or `getBytes`, and the same programs with `-dce no`, still run
- [ ] 2.3 The same out-of-range `OSetField` on another class, and a negative index on the resource class, are still refused
- [ ] 2.4 `HelloWorld` (bytecode and HL/C) still passes
- [ ] 2.5 Cross-review of the branch diff
