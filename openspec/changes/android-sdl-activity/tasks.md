## 1. Code

- [ ] 1.1 `src/hlc_main.c`: include `<SDL3/SDL_main.h>` on a mobile target when the header is found
- [ ] 1.2 `libs/sdl/sdl.c`: `win_create_ex` does not start text input on a mobile target
- [ ] 1.3 `libs/fmt/CMakeLists.txt`: pass `CMAKE_MAKE_PROGRAM` to the sub-builds
- [ ] 1.4 `src/std/sys_android.c`: `JNI_OnLoad` falls back to SDL's activity and clears failed lookups; `NULL` paths without a VM or a class

## 2. Verification

- [ ] 2.1 The Sprout mobile gate applications, built against this branch without the three workarounds (`main=SDL_main`, `stopTextInput()`, ninja on `PATH`), build and start on the emulator; the keyboard stays closed
- [ ] 2.2 A gate application that calls `sys_special("android_internal_storage_path")` has `JNI_OnLoad` in `libmain.so` and gets the files directory; one that does not call it has none
- [ ] 2.3 Desktop: `make`, `HelloWorld` in bytecode and in HL/C
- [ ] 2.4 Cross-review of the branch diff
