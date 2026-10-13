## Context
`sys_android.c` needs the `JavaVM` for one thing: `sys_special("android_external_storage_path" | "android_internal_storage_path")`. It gets it in `JNI_OnLoad`, which Android calls on the library given to `System.loadLibrary`. With a shared `libhl.so` that library is `libhl.so`. With a static `libhl` it is the application's library (`libmain.so` under SDL's activity), and `sys_android.c` is one member of `libhl.a`: the linker takes it only if something refers to a symbol it defines.

## Goals / Non-Goals
- Goal: decide how the Java VM reaches a statically linked `libhl`, and make the result safe under SDL's activity.
- Non-goal: a new public API to hand a `JavaVM` to the runtime; an application with its own `JNI_OnLoad`.

## Decisions
**No forced link.** `sys_android.c` defines two external symbols, `JNI_OnLoad` and `hl_sys_special` (`sys.c` does not define the latter on a mobile target). HL/C calls a native by its C name, so a program that uses `sys_special` refers to `hl_sys_special`, the linker takes the member, and `JNI_OnLoad` comes with it and is exported (`JNIEXPORT`). A program that does not use it has no `JNI_OnLoad` from `libhl` and does not need one. So static linking already delivers the VM exactly where it is used; a shared `libhl.so` is not required. Rejected: a reference to `JNI_OnLoad` from `hlc_main.c`, or `--whole-archive`/`-u` in the CMake target — they add a load-time JNI lookup to every application for a function most never call.

**The activity class.** What a forced or natural link then runs is `JNI_OnLoad`, and it assumed `org/haxe/HashLinkActivity`. It needs only a class with `static Context getContext()`; `org.libsdl.app.SDLActivity` has one, and `HashLinkActivity` of the upstream Android sample extends it. So: try `HL_ANDROID_ACTIVITY`, then `org/libsdl/app/SDLActivity`; clear the exception of a failed lookup (a pending exception would be thrown by `System.loadLibrary`); with no class, load anyway and return `NULL` paths.

## Risks / Trade-offs
- An application that defines its own `JNI_OnLoad` in the library it links `libhl` into statically gets a duplicate symbol as soon as it uses `sys_special`. Not addressed: no known user; the fix would be an init function taking the `JavaVM`.
