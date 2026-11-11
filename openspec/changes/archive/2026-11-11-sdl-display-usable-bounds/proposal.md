## Why
An application on hlsdl cannot learn the usable area of a display — the part not taken by the OS task bar, dock or menu bar. `sdl.Sdl.getDisplays()` reports only `SDL_GetDisplayBounds` (the whole display) and `getScreenWidth/Height` the whole screen too. An editor that limits its minimum window size to the work area (as Godot does) has to approximate it, e.g. as 90 % of the screen.

## What Changes
- `sdl.Display` (the entries of `sdl.Sdl.getDisplays()`) gets `usableLeft`, `usableTop`, `usableRight`, `usableBottom`, filled by the `get_displays` primitive in `sdl.c` from `SDL_GetDisplayUsableBounds`. When SDL cannot report the usable area, they repeat the full bounds.
- The display of a window is already available as `sdl.Window.currentMonitor` (`SDL_GetDisplayForWindow`), the same handle as `Display.handle`; no new window helper is added.

## Capabilities

### New Capabilities
- `sdl-display`: the displays `sdl.Sdl` reports, with their full and usable bounds.

### Modified Capabilities

## Impact
- `libs/sdl/sdl.c`, `libs/sdl/sdl/Sdl.hx` (code). Additive API: new fields on the `Display` typedef; code that builds a `Display` literal itself must add them.
