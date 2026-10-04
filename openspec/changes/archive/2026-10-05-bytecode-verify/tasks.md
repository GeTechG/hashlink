## 1. Verifier

- [x] 1.1 `hl_check_function` in `src/code.c`: registers, jump targets, field / method / constructor indexes, called from `hl_code_read` after the function indexes are checked
- [x] 1.2 Loader checks the verifier relies on: packed type wraps an object type, native type is a function type, `OCatch` global in range
- [x] 1.3 `src/jit_emit.c`: bound the `OTrap` lookahead to the opcodes of the function

## 2. Verification

- [x] 2.1 Fuzz: mutated `.hl` files through load + JIT under ASan, no crash left in `src/code.c` / `src/jit_emit.c`
- [x] 2.2 Valid bytecode still loads and runs: `HelloWorld`, the programs in `other/tests`, the Haxe standard library built with `-dce no`
- [x] 2.3 Cross-review of the branch diff
