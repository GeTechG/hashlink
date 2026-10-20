## 1. Implementation

- [ ] 1.1 `libs/sdl/sdl.c`: add `win_get_safe_area(win, &x, &y, &w, &h)` calling `SDL_GetWindowSafeArea`, falling back to `0, 0` and the window size when SDL fails
- [ ] 1.2 `libs/sdl/sdl/Window.hx`: add `getSafeArea() : { x : Int, y : Int, width : Int, height : Int }` over the primitive
- [ ] 1.3 `libs/sdl/sdl/Sdl.hx`: `SDL_HINT_ORIENTATIONS = "SDL_ORIENTATIONS"`

## 2. Verification

- [ ] 2.1 Host build (`make`) and the bytecode and HL/C smoke tests pass
- [ ] 2.2 Desktop check: an HL program that opens a window prints `getSafeArea()` as `0, 0, width, height` of that window, and `SDL_HINT_ORIENTATIONS` as `SDL_ORIENTATIONS`
- [ ] 2.3 Android build of `sdl.hdll` (`hl_android`) compiles with the new primitive
