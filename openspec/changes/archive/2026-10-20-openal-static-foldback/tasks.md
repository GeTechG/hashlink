## 1. Library

- [x] 1.1 `libs/openal/openal.c`: with `OPENAL_STATIC`, function pointers for `alRequestFoldbackStart`/`alRequestFoldbackStop`, filled by `al_load_extensions` through `alGetProcAddress`

## 2. Verification

- [x] 2.1 OpenAL-soft 1.24.3 built as a static library; `openal.c` with `OPENAL_STATIC` linked into a shared library with `--no-undefined`: before the change two undefined symbols, after it none
- [x] 2.2 Under `hl` with that library: `AL.loadExtensions()`, then `ExtAL.requestFoldbackStart`/`requestFoldbackStop` throw "Unsupported extension function"
- [x] 2.3 `make`, `HelloWorld` in bytecode and in HL/C
- [x] 2.4 Cross-review of the branch diff (codex, lite, 1 round: clean)
