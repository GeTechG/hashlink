## 1. Implementation

- [x] 1.1 `libs/sdl/sdl.c`: add `get_touch_device_count()` calling `SDL_GetTouchDevices(&count)`, returning `count` (`0` when SDL returns `NULL`) and releasing SDL's array with `SDL_free`
- [x] 1.2 `libs/sdl/sdl/Sdl.hx`: add `getTouchDeviceCount() : Int` over the primitive

## 2. Verification

- [x] 2.1 Host build (`make`) and the bytecode and HL/C smoke tests pass
- [x] 2.2 Desktop check (X11): an HL program calling `getTouchDeviceCount()` after `Sdl.init` prints `0` on a machine without a touch device, and `1` while a virtual `uinput` touch device (`INPUT_PROP_DIRECT`, multitouch axes) is attached
