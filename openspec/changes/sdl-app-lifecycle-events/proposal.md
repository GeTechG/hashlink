## Why
`sdl.c`'s `event_loop` drops every SDL event that has no `sdl.Event.EventType`, and SDL 3 never puts the application lifecycle events (`SDL_EVENT_TERMINATING`, `SDL_EVENT_LOW_MEMORY`, `SDL_EVENT_WILL_ENTER_BACKGROUND`, `SDL_EVENT_DID_ENTER_BACKGROUND`, `SDL_EVENT_WILL_ENTER_FOREGROUND`, `SDL_EVENT_DID_ENTER_FOREGROUND`) in its queue at all: `SDL_SendAppEvent` only hands them to event watchers. `SDL_EVENT_RENDER_DEVICE_RESET` is queued but has no `EventType` either. On Android a game therefore cannot tell that it went to the background (it only sees `WindowState` `Blur`/`Minimize`, which a desktop also sends) and cannot tell that SDL replaced its EGL context on return, which invalidates every GL object it holds.

## What Changes
- New `sdl.Event.EventType` values, mirrored in `sdl.c`'s `event_type`: `AppTerminating = 600`, `AppLowMemory = 601`, `AppWillEnterBackground = 602`, `AppDidEnterBackground = 603`, `AppWillEnterForeground = 604`, `AppDidEnterForeground = 605`, and `RenderDeviceReset = 700`.
- `init_once` registers one SDL event type of its own and an event watch. The watch, which SDL calls while it sends a lifecycle event, puts an event of that type in the queue with the SDL event type in `user.code` (through `SDL_PeepEvents`, so the watchers do not run again). `event_loop` maps it to the matching `EventType`; the lifecycle events are thus delivered in queue order with the others, from the thread that polls.
- When the handler accepts `Quit`, `processEvents` still drains the queue and hands it any `AppTerminating` before returning `false`: when the OS ends the app (Android `onDestroy`), SDL sends `SDL_EVENT_TERMINATING` right after `SDL_EVENT_QUIT`, and an app that stops polling on `false` would otherwise never see it. The other events behind an accepted `Quit` are dropped instead of left in the queue.
- `event_loop` maps `SDL_EVENT_RENDER_DEVICE_RESET` to `RenderDeviceReset` with the window in `windowId` (`0` when SDL names none).
- Handling stays asynchronous: the Haxe handler sees a lifecycle event at the next `processEvents`, not inside SDL's call. With SDL's default `SDL_HINT_ANDROID_BLOCK_ON_PAUSE`, SDL 3.4 blocks inside the same event pump that sent the background pair (its `GetLifecycleEventTimeout` looks at the global paused state as soon as the pause is handled), so on Android the game sees `AppWillEnterBackground`/`AppDidEnterBackground` on return, right before `AppWillEnterForeground`/`AppDidEnterForeground`; with the hint set to `0` it sees them while in the background.
- Platforms that never send these events behave as before, and handlers that ignore unknown types keep working.

## Capabilities

### New Capabilities
- `sdl-events`: which SDL events reach Haxe through `sdl.Sdl.processEvents` and with which `EventType` — this change specifies the lifecycle and render-device-reset part.

### Modified Capabilities

## Impact
- `libs/sdl/sdl.c`, `libs/sdl/sdl/Event.hx` and `libs/sdl/sdl/Sdl.hx` (code). Additive API: new `EventType` values, no existing value renumbered. Code that reads raw events through `event_poll` sees one more SDL user event type, registered by `sdl.hdll`.
