## Why
On Android a window can be partly covered by the camera cutout and the system bars. SDL 3 already computes the part that is not covered (from `WindowInsets`) and returns it through `SDL_GetWindowSafeArea`, but `sdl.Window` has no binding for it, so a game cannot keep its UI out of the cutout.

Separately, `sdl.SDLHint.SDL_HINT_ORIENTATIONS` (in `sdl/Sdl.hx`) still holds the SDL 2 name `"SDL_IOS_ORIENTATIONS"`. SDL 3 reads `"SDL_ORIENTATIONS"`, so setting the hint through the constant does nothing; on Android, SDL's activity then overrides the manifest's `screenOrientation` with `FULL_USER` for a resizable window.

## What Changes
- New `sdl.Window.getSafeArea() : { x : Int, y : Int, width : Int, height : Int }`, backed by a new `win_get_safe_area` primitive in `sdl.c` that calls `SDL_GetWindowSafeArea`. The rectangle is in the window's coordinates, the units of `Window.width` / `height`. Where nothing covers the window (desktop), it is the whole window: `0, 0, width, height`. If SDL reports an error, the whole window is returned as well.
- `SDLHint.SDL_HINT_ORIENTATIONS` becomes `"SDL_ORIENTATIONS"`, the SDL 3 name.
- Not in this change: an event for `SDL_EVENT_WINDOW_SAFE_AREA_CHANGED`; a caller polls `getSafeArea()`.

## Capabilities

### New Capabilities
- `sdl-window`: what `sdl.Window` reports about the window — this change specifies the safe area — and the SDL 3 name of the orientation hint.

### Modified Capabilities

## Impact
- `libs/sdl/sdl.c`, `libs/sdl/sdl/Window.hx`, `libs/sdl/sdl/Sdl.hx` (code). Additive API; the hint constant changes value, so code that set it now takes effect under SDL 3.
