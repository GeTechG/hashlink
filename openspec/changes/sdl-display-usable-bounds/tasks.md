## 1. Implementation

- [ ] 1.1 `libs/sdl/sdl.c`: in `get_displays`, set `usableLeft/Top/Right/Bottom` from `SDL_GetDisplayUsableBounds`, falling back to the full bounds when it fails — checked by `make` and the desktop check 2.2
- [ ] 1.2 `libs/sdl/sdl/Sdl.hx`: add the four fields to `Display` and copy them in `getDisplays()` — checked by the bytecode build of the check program in 2.2

## 2. Verification

- [ ] 2.1 Host build (`make`) and the bytecode and HL/C smoke tests pass
- [ ] 2.2 Desktop check (X11): an HL program prints, after `Sdl.init` and opening a window, each display's full and usable bounds and the window's `currentMonitor`; the usable rectangle is inside the full one and `currentMonitor` matches one `handle`

## Workflow follow-up

- Cross-review of the branch diff (`/ai-brainstorm:ai-review`), archive as the last commit, merge to `master`.
