## MODIFIED Requirements

### Requirement: The Java VM reaches a statically linked runtime that uses it
A program that calls `sys_special` and links `libhl` statically SHALL have the `JNI_OnLoad` of the runtime in its own library, without a link option of its own. A program that does not call `sys_special` MAY have no `JNI_OnLoad` from the runtime.

#### Scenario: Storage path under SDL's activity
- **WHEN** a statically linked HL/C application started by `org.libsdl.app.SDLActivity`, with no class `org.haxe.HashLinkActivity`, asks `sys_special` for `android_internal_storage_path`
- **THEN** it gets the files directory of the application

#### Scenario: Program that does not use sys_special
- **WHEN** a statically linked HL/C application does not call `sys_special`
- **THEN** it loads and runs whether or not its library has a `JNI_OnLoad`

## ADDED Requirements

### Requirement: JNI_OnLoad finds the application context
`JNI_OnLoad` SHALL take the application context from the class `HL_ANDROID_ACTIVITY` names and, when there is no such class, from `org/libsdl/app/SDLActivity`, and SHALL NOT return with a Java exception pending. When it finds no context, the storage paths of `sys_special` SHALL be `NULL`.

#### Scenario: getContext declared by SDL2 or SDL3
- **WHEN** the activity class declares `getContext()` as returning `Context` (SDL2) or `Activity` (SDL3)
- **THEN** `JNI_OnLoad` takes the context from it either way

#### Scenario: Neither class exists
- **WHEN** neither the class `HL_ANDROID_ACTIVITY` names nor `org/libsdl/app/SDLActivity` exists
- **THEN** `JNI_OnLoad` returns with no Java exception pending, and `sys_special` returns `NULL` for the storage paths

#### Scenario: Library loaded without JNI_OnLoad
- **WHEN** the library is loaded without `JNI_OnLoad` being called
- **THEN** `sys_special` returns `NULL` for the storage paths
