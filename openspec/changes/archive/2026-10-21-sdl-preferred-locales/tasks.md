## 1. Implementation

- [x] 1.1 `libs/sdl/sdl.c`: add `get_preferred_locales()` calling `SDL_GetPreferredLocales`, returning an array of UTF-8 `language` / `language-COUNTRY` strings in SDL's order (empty when SDL returns nothing), and releasing SDL's list with `SDL_free`
- [x] 1.2 `libs/sdl/sdl/Sdl.hx`: add `getPreferredLocales() : Array<String>` over the primitive

## 2. Verification

- [x] 2.1 Host build (`make`) and the bytecode and HL/C smoke tests pass
- [x] 2.2 Desktop check: an HL program run with `LANG=ru_RU.UTF-8` prints `getPreferredLocales()` starting with `ru-RU` (or `ru`)
- [x] 2.3 Android build of `sdl.hdll` (NDK, arm64-v8a, CMake with SDL 3) compiles and exports `get_preferred_locales`
