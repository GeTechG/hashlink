## ADDED Requirements

### Requirement: Display usable bounds
Each `sdl.Display` returned by `sdl.Sdl.getDisplays()` SHALL carry `usableLeft`, `usableTop`, `usableRight` and `usableBottom`: the edges, in global desktop coordinates like `left`/`top`/`right`/`bottom`, of the display area SDL reports as usable (`SDL_GetDisplayUsableBounds`), i.e. without the OS task bar, dock or menu bar. When SDL cannot report it, they SHALL equal the full bounds.

#### Scenario: Desktop with a task bar
- **WHEN** a program calls `getDisplays()` on a desktop whose display has a task bar along one edge
- **THEN** the usable rectangle lies inside `left, top, right, bottom` and excludes the task bar's edge

#### Scenario: Display without OS panels
- **WHEN** nothing of the OS reserves part of a display
- **THEN** its usable edges equal `left`, `top`, `right`, `bottom`

### Requirement: Display of a window
`sdl.Window.currentMonitor` SHALL return the handle of the display that holds the window, equal to the `handle` of that display's entry in `sdl.Sdl.getDisplays()`, so that a program can find the usable bounds of its window's display. When SDL cannot tell the display, it SHALL return `0`, which matches no entry.

#### Scenario: Usable area for the window's display
- **WHEN** a program opens a window and looks up the `getDisplays()` entry whose `handle` equals `window.currentMonitor`
- **THEN** it finds exactly one entry, the display the window is on

#### Scenario: Display unknown
- **WHEN** SDL cannot tell which display holds the window
- **THEN** `currentMonitor` is `0` and no `getDisplays()` entry has that handle
