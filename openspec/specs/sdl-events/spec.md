# sdl-events Specification

## Purpose
Which SDL events reach Haxe through `sdl.Sdl.processEvents`, and with which `sdl.Event.EventType`.

## Requirements

### Requirement: Application lifecycle events reach Haxe
`sdl.Sdl.processEvents` SHALL deliver SDL's application lifecycle events to its handler, in the order SDL sent them relative to the other events, with these `sdl.Event.EventType` values: `SDL_EVENT_TERMINATING` as `AppTerminating` (600), `SDL_EVENT_LOW_MEMORY` as `AppLowMemory` (601), `SDL_EVENT_WILL_ENTER_BACKGROUND` as `AppWillEnterBackground` (602), `SDL_EVENT_DID_ENTER_BACKGROUND` as `AppDidEnterBackground` (603), `SDL_EVENT_WILL_ENTER_FOREGROUND` as `AppWillEnterForeground` (604) and `SDL_EVENT_DID_ENTER_FOREGROUND` as `AppDidEnterForeground` (605). Each lifecycle event SDL sends SHALL be delivered once, by a later `processEvents` call on the polling thread, not from inside SDL's call.

#### Scenario: Android app sent to the background and back
- **WHEN** an Android app polls events with `processEvents` and the user presses HOME, then returns to the app
- **THEN** the handler receives `AppWillEnterBackground`, `AppDidEnterBackground`, `AppWillEnterForeground` and `AppDidEnterForeground`, in that order

#### Scenario: Android app that does not block on pause
- **WHEN** the app sets the hint `SDL_ANDROID_BLOCK_ON_PAUSE` to `0` before `sdl.Sdl.init`, the user presses HOME and later returns
- **THEN** the handler receives `AppWillEnterBackground` and `AppDidEnterBackground` while the app is in the background, and `AppWillEnterForeground` and `AppDidEnterForeground` after it returns

#### Scenario: The OS ends the app
- **WHEN** SDL sends `SDL_EVENT_QUIT` followed by `SDL_EVENT_TERMINATING` (Android `onDestroy`) and the handler returns `true` for `Quit`
- **THEN** the same `processEvents` call hands `AppTerminating` to the handler after `Quit`, then returns `false`

#### Scenario: Platform without lifecycle events
- **WHEN** the platform's SDL never sends application lifecycle events (a desktop)
- **THEN** `processEvents` delivers the same events as before

### Requirement: Render device reset reaches Haxe
`sdl.Sdl.processEvents` SHALL deliver `SDL_EVENT_RENDER_DEVICE_RESET` to its handler as `RenderDeviceReset` (700), with `windowId` set to the event's window ID (`0` when SDL names no window), so that a game learns its graphics context was recreated and its GPU resources are gone.

#### Scenario: EGL context recreated on return from background
- **WHEN** SDL on Android cannot restore the old EGL context on return from the background, creates a new one and queues `SDL_EVENT_RENDER_DEVICE_RESET`
- **THEN** the handler receives an event of type `RenderDeviceReset` whose `windowId` is that window's ID
