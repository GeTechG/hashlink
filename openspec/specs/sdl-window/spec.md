# sdl-window Specification

## Purpose
What `sdl.Window` reports about the window, and the SDL 3 names of the hints in `sdl.SDLHint` that act on it.

## Requirements

### Requirement: Window safe area
`sdl.Window.getSafeArea()` SHALL return the rectangle of the window that SDL reports as not covered by a display cutout or system UI (`SDL_GetWindowSafeArea`), as `{ x, y, width, height }` in the window's coordinates — the units of `sdl.Window.width` and `height`. When nothing covers the window, or SDL cannot report the area, it SHALL return the whole window: `x = 0`, `y = 0`, `width = Window.width`, `height = Window.height`.

#### Scenario: Desktop window
- **WHEN** a program on a desktop opens a window and calls `getSafeArea()`
- **THEN** it gets `0, 0, width, height` of that window

#### Scenario: Android window under a camera cutout
- **WHEN** an Android app's window extends under the camera cutout or a system bar and the app calls `getSafeArea()`
- **THEN** the rectangle excludes the covered edge, and it stays inside `0, 0, width, height`

### Requirement: Orientation hint uses the SDL 3 name
`sdl.SDLHint.SDL_HINT_ORIENTATIONS` (in `sdl/Sdl.hx`) SHALL be `"SDL_ORIENTATIONS"`, the name SDL 3 reads, so that setting it through `sdl.Sdl.setHint` before the window is created restricts the orientations SDL allows.

#### Scenario: Hint set before the window
- **WHEN** a program calls `setHint(SDL_HINT_ORIENTATIONS, "LandscapeLeft LandscapeRight")` before creating its window
- **THEN** SDL sees the value under `SDL_ORIENTATIONS`
