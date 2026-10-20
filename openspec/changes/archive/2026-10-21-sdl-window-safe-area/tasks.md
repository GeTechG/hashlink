## 1. Implementation

- [x] 1.1 `libs/sdl/sdl.c`: add `win_get_safe_area(win, &x, &y, &w, &h)` calling `SDL_GetWindowSafeArea`, falling back to `0, 0` and the window size when SDL fails
- [x] 1.2 `libs/sdl/sdl/Window.hx`: add `getSafeArea() : { x : Int, y : Int, width : Int, height : Int }` over the primitive
- [x] 1.3 `libs/sdl/sdl/Sdl.hx`: `SDL_HINT_ORIENTATIONS = "SDL_ORIENTATIONS"`

## 2. Verification

- [x] 2.1 Host build (`make`) and the bytecode and HL/C smoke tests pass
- [x] 2.2 Desktop check: an HL program that opens a window prints `getSafeArea()` as `0, 0, width, height` of that window, and `SDL_HINT_ORIENTATIONS` as `SDL_ORIENTATIONS`
- [x] 2.3 Android build of `sdl.hdll` (NDK r27c, arm64-v8a, CMake with downloaded SDL 3.4.10) compiles and exports `win_get_safe_area`
