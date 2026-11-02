## Why
An application on hlsdl cannot tell whether the machine has a touch screen: `sdl.Sdl` has no binding for SDL's touch device list. Engines on HashLink (Heaps' `IsTouch`, Sprout's `isTouchscreenAvailable()`) therefore answer by platform only, so a desktop with a touch screen always reports none.

## What Changes
- New `sdl.Sdl.getTouchDeviceCount() : Int`, backed by a new `get_touch_device_count` primitive in `sdl.c` that calls `SDL_GetTouchDevices(&count)` and releases the returned array with `SDL_free`. It returns the number of touch devices SDL sees, `0` when there are none or SDL fails. Valid once the video subsystem is initialised (`Sdl.init`).

## Capabilities

### New Capabilities
- `sdl-touch`: the touch devices `sdl.Sdl` reports.

### Modified Capabilities

## Impact
- `libs/sdl/sdl.c`, `libs/sdl/sdl/Sdl.hx` (code). Additive API.
