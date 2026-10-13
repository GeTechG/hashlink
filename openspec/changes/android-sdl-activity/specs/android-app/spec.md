## ADDED Requirements

### Requirement: The entry point of an HL/C application on a mobile target is the one SDL expects
`hlc_main.c` SHALL include `<SDL3/SDL_main.h>` on a mobile target when the compiler finds that header, so that the function it defines is the entry point SDL's launcher calls. An application that defines `SDL_MAIN_HANDLED` keeps the name `main`.

#### Scenario: Application under SDL's activity
- **WHEN** an HL/C application is built for Android with the SDL3 headers on its include path and loaded by `org.libsdl.app.SDLActivity`
- **THEN** its library exports `SDL_main` and the activity starts the program, with no definition added by the application

#### Scenario: Desktop target
- **WHEN** an HL/C application is built for a desktop target
- **THEN** its entry point is `main` (`wmain` on Windows) as before

### Requirement: A new window does not open the on-screen keyboard
On a mobile target `sdl.hdll` SHALL NOT start text input when it creates a window; text input starts when the application asks for it. On the other targets a new window starts text input.

#### Scenario: Window on Android
- **WHEN** an application creates its window on Android and does not call `startTextInput`
- **THEN** the on-screen keyboard stays closed

#### Scenario: Window on a desktop
- **WHEN** an application creates a window on a desktop target
- **THEN** it receives text input events without asking for them

### Requirement: The dependencies build with the build program of the parent build
The sub-builds CMake starts for the third-party dependencies of `fmt.hdll` SHALL use the `CMAKE_MAKE_PROGRAM` of the build that starts them.

#### Scenario: Ninja that is not on PATH
- **WHEN** the build is configured with the Ninja generator and `CMAKE_MAKE_PROGRAM` set to a ninja that is not on `PATH`, as Gradle does
- **THEN** the dependencies configure and build

### Requirement: The Java VM reaches a statically linked runtime that uses it
A program that calls `sys_special` and links `libhl` statically SHALL have the `JNI_OnLoad` of the runtime in its own library, without a link option of its own. A program that does not call `sys_special` MAY have no `JNI_OnLoad` from the runtime.

`JNI_OnLoad` SHALL take the application context from the class `HL_ANDROID_ACTIVITY` names and, when there is no such class, from `org/libsdl/app/SDLActivity`. It SHALL NOT return with a Java exception pending. When neither class exists, or the library was loaded without `JNI_OnLoad` being called, the storage paths of `sys_special` SHALL be `NULL`.

#### Scenario: Storage path under SDL's activity
- **WHEN** a statically linked HL/C application started by `org.libsdl.app.SDLActivity`, with no class `org.haxe.HashLinkActivity`, asks `sys_special` for `android_internal_storage_path`
- **THEN** it gets the files directory of the application

#### Scenario: Program that does not use sys_special
- **WHEN** a statically linked HL/C application does not call `sys_special`
- **THEN** it loads and runs whether or not its library has a `JNI_OnLoad`
