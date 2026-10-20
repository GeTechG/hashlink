## 1. Implementation

- [ ] 1.1 `libs/sdl/sdl/Event.hx`: add `AppTerminating`, `AppLowMemory`, `AppWillEnterBackground`, `AppDidEnterBackground`, `AppWillEnterForeground`, `AppDidEnterForeground` (600–605) and `RenderDeviceReset` (700) to `EventType`
- [ ] 1.2 `libs/sdl/sdl.c`: mirror them in `event_type`; in `init_once` register an event type and an event watch that queues the lifecycle events under it; map them and `SDL_EVENT_RENDER_DEVICE_RESET` (with `windowId`) in `event_loop`
- [ ] 1.3 `libs/sdl/sdl/Sdl.hx`: on an accepted `Quit`, `processEvents` drains the queue and delivers any `AppTerminating` before returning `false`

## 2. Verification

- [ ] 2.1 Host build (`make`) and the bytecode and HL/C smoke tests pass
- [ ] 2.2 Mapping check: a C program linked to the host `sdl.hdll` calls `init_once`, pushes each of the seven SDL events with `SDL_PushEvent` and reads each back exactly once through `event_loop` with the expected type (600–605, 700; `windowId` 42 for `RenderDeviceReset`); a Haxe program prints the seven `EventType` values as the same numbers. Through `processEvents` on host HL (events pushed by a test `.hdll`): the seven arrive as `600…605, 700` (`windowId` 7); `Quit`, `TERMINATING`, a key event with a handler accepting `Quit` give `[0, 600]`, `false`, and the next call finds the queue empty
- [ ] 2.3 Android emulator (API 35 x86_64), an HL/C app on SDL's activity logging `processEvents`: HOME then return delivers `AppWillEnterBackground`, `AppDidEnterBackground`, `AppWillEnterForeground`, `AppDidEnterForeground` in that order (before the change: only `WindowState` events). With the default block-on-pause the background pair arrives on return, right after `Minimize`; with `SDL_ANDROID_BLOCK_ON_PAUSE=0` it arrives on HOME, the foreground pair on return. `AppLowMemory` also arrived (the emulator trims memory in the background)
