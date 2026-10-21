# sdl-hints Specification

## Purpose
Which hint names `sdl.SDLHint` holds under SDL 3: the names SDL 3 reads, the keyboard grab hint hlsdl emulates, and the SDL 2 names kept as deprecated.

## Requirements

### Requirement: SDLHint constants name SDL 3 hints
Every constant of `sdl.SDLHint` (in `sdl/Sdl.hx`) that is not deprecated SHALL hold the name SDL 3 reads for that hint, as defined in SDL 3's `SDL_hints.h` — except `SDL_HINT_GRAB_KEYBOARD`, which keeps `"SDL_GRAB_KEYBOARD"` because hlsdl itself reads it to decide whether `Window.grab` also grabs the keyboard.

#### Scenario: Hint renamed in SDL 3
- **WHEN** a program calls `setHint(SDL_HINT_WINDOW_ALLOW_TOPMOST, "0")` or the deprecated `setHint(SDL_HINT_ALLOW_TOPMOST, "0")`
- **THEN** SDL sees the value under `SDL_WINDOW_ALLOW_TOPMOST`

#### Scenario: Replacement with other values
- **WHEN** a program needs the SDL 3 replacements of `SDL_HINT_IME_INTERNAL_EDITING` or `SDL_HINT_WINDOWS_NO_CLOSE_ON_ALT_F4`
- **THEN** `SDLHint` offers `SDL_HINT_IME_IMPLEMENTED_UI` (`"SDL_IME_IMPLEMENTED_UI"`) and `SDL_HINT_WINDOWS_CLOSE_ON_ALT_F4` (`"SDL_WINDOWS_CLOSE_ON_ALT_F4"`)

### Requirement: SDL 2 hints without an SDL 3 name are deprecated
A constant of `sdl.SDLHint` whose hint SDL 3 no longer reads SHALL be kept with its SDL 2 value and marked `@:deprecated`, with a message that says what SDL 3 does instead, so that code naming it still compiles and is warned that the hint has no effect.

#### Scenario: Deprecated hint used
- **WHEN** a program compiles a call `setHint(SDL_HINT_RENDER_SCALE_QUALITY, "0")`
- **THEN** the compilation succeeds with a deprecation warning that points to `SDL_SetTextureScaleMode`
