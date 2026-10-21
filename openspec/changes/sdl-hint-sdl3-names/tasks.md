## 1. Implementation

- [ ] 1.1 `libs/sdl/sdl/Sdl.hx`: add `SDL_HINT_WINDOW_ALLOW_TOPMOST`, `SDL_HINT_IME_IMPLEMENTED_UI`, `SDL_HINT_WINDOWS_CLOSE_ON_ALT_F4` with their SDL 3 names; `SDL_HINT_ALLOW_TOPMOST` takes `"SDL_WINDOW_ALLOW_TOPMOST"`
- [ ] 1.2 `libs/sdl/sdl/Sdl.hx`: mark every constant SDL 3 no longer reads (except `SDL_HINT_GRAB_KEYBOARD`) `@:deprecated`, saying what SDL 3 does instead

## 2. Verification

- [ ] 2.1 Every non-deprecated constant except `SDL_HINT_GRAB_KEYBOARD` holds a name `SDL_hints.h` of SDL 3.4.10 defines
- [ ] 2.2 Host build (`make`) and the bytecode and HL/C smoke tests pass
- [ ] 2.3 A Haxe program using a deprecated constant compiles with a deprecation warning; one using only current constants compiles without
