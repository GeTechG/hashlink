## Why
An HL/C application built for Android with the NDK and CMake (`add_subdirectory` of this repo, `BUILD_SHARED_LIBS=OFF`, `WITH_VM=OFF`) and started by SDL's own activity (`org.libsdl.app.SDLActivity`, SDL 3.4) runs only with workarounds in the application:

1. `src/hlc_main.c` includes `<SDL_main.h>` on a mobile target only when `sdl__Sdl__val` is defined. The C that Haxe 5 writes defines no such macro, and SDL3 installs the header as `<SDL3/SDL_main.h>`. The library exports `main`, the activity reports `Couldn't find function SDL_main` and the application closes.
2. `win_create_ex` in `libs/sdl/sdl.c` starts text input for every new window ("SDL2 compat"). On a device with an on-screen keyboard that opens the keyboard at start. SDL2 itself did not start text input on such a device.
3. The `ExternalProject_Add` sub-builds of `libs/fmt` (libpng, libjpeg-turbo, libogg, libvorbis) get the generator of the parent build but not its build program. Gradle passes `CMAKE_MAKE_PROGRAM` with the path of the ninja of the SDK, which is not on `PATH`, and the sub-builds stop with `CMake was unable to find a build program corresponding to "Ninja"`.
4. `JNI_OnLoad` of `src/std/sys_android.c` looks up the class `org/haxe/HashLinkActivity` and goes on with a null class when there is none: under SDL's activity the library fails while it is loaded. A statically linked `libhl` hides that today only because the linker leaves `sys_android.c` out of a program that does not call `sys_special`. Two more faults sit behind it: SDL3 declares `SDLActivity.getContext()` as returning `Activity`, not `Context`, so the method lookup fails too; and the internal path is asked from `getFilesDir(String)`, a method `Context` does not have (it takes no argument), which aborts the process in JNI.

## What Changes
- `hlc_main.c`: on a mobile target `<SDL3/SDL_main.h>` is included whenever the compiler can find it, so the entry point is `SDL_main`. An application that does not want that defines `SDL_MAIN_HANDLED`. The `sdl__Sdl__val` test stays for an SDL2 header layout.
- `sdl.c`: a new window starts text input only when the target is not mobile. The application opens the keyboard with `Window.startTextInput()`.
- `libs/fmt/CMakeLists.txt`: the sub-builds get `CMAKE_MAKE_PROGRAM` of the parent build.
- `sys_android.c`: `JNI_OnLoad` falls back to `org/libsdl/app/SDLActivity` when the class `HL_ANDROID_ACTIVITY` names does not exist, accepts `getContext()` declared with either return type, calls `getFilesDir()` with its real signature, and leaves no pending Java exception. Without either class, or without a Java VM, the storage paths are `NULL` instead of a crash.
- Decision on static linking (see `design.md`): nothing is added to keep `sys_android.c` in a statically linked program. The linker brings it in, with its `JNI_OnLoad`, exactly when the program calls `sys_special`, which is the only thing that needs the Java VM.

## Capabilities

### New Capabilities
- `android-app`: what an HL/C application gets from this repo on Android under SDL's activity: entry point, keyboard at start, build of the dependencies, access to the Java VM.

### Modified Capabilities

## Impact
- `src/hlc_main.c`, `libs/sdl/sdl.c`, `libs/fmt/CMakeLists.txt`, `src/std/sys_android.c`.
- A mobile application that relied on the keyboard opening with the window has to call `Window.startTextInput()`. Desktop targets are unchanged.
- A mobile HL/C application that has the SDL3 headers on its include path and its own `main` handling defines `SDL_MAIN_HANDLED`.
