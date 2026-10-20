## ADDED Requirements

### Requirement: openal.hdll links to the OpenAL-soft release it pins
`openal.hdll` built with `WITH_STATIC_OPENAL=ON` SHALL reference only the functions the OpenAL-soft release pinned in `libs/openal/CMakeLists.txt` exports. An extension function that release declares but does not export SHALL be looked up at run time with `alGetProcAddress` by `al_load_extensions`, not linked.

#### Scenario: Static link of a program with sound
- **WHEN** a program links `openal.hdll` and the static OpenAL-soft 1.24.3 into one shared library, as an Android HL/C application does
- **THEN** the link has no undefined `al*` or `alc*` symbol

### Requirement: A missing extension function throws when called
The primitive of an extension function that `al_load_extensions` did not find SHALL throw "Unsupported extension function" when called, in the static build as in the dynamic one.

#### Scenario: Foldback with OpenAL-soft 1.24.3
- **WHEN** a program on a static OpenAL-soft 1.24.3 calls `AL.loadExtensions()` and then `ExtAL.requestFoldbackStart` or `ExtAL.requestFoldbackStop`
- **THEN** the call throws "Unsupported extension function"
