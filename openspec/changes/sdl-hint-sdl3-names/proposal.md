## Why
`sdl.SDLHint` (in `sdl/Sdl.hx`) was written for SDL 2. Under SDL 3 a good part of it names hints SDL no longer reads: setting them through `sdl.Sdl.setHint` silently does nothing (`SDL_HINT_IDLE_TIMER_DISABLED`, `SDL_HINT_RENDER_SCALE_QUALITY`, …), and three of them have an SDL 3 replacement under another name that the enum does not offer. Checked against SDL 3.4.10's `SDL_hints.h` and the hint section of SDL's `README-migration.md`: 20 of the 44 constants already hold an SDL 3 name, 24 do not.

## What Changes
- Renamed in SDL 3, same meaning: new `SDL_HINT_WINDOW_ALLOW_TOPMOST = "SDL_WINDOW_ALLOW_TOPMOST"`. `SDL_HINT_ALLOW_TOPMOST` takes the same SDL 3 value (so existing code starts working again) and is deprecated in favour of the new name.
- Replaced in SDL 3 by a hint with other values: new `SDL_HINT_IME_IMPLEMENTED_UI = "SDL_IME_IMPLEMENTED_UI"` and `SDL_HINT_WINDOWS_CLOSE_ON_ALT_F4 = "SDL_WINDOWS_CLOSE_ON_ALT_F4"`. `SDL_HINT_IME_INTERNAL_EDITING` and `SDL_HINT_WINDOWS_NO_CLOSE_ON_ALT_F4` keep their SDL 2 values (copying a value across would mean the opposite or something else) and are deprecated with a pointer to the replacement.
- Removed in SDL 3 with no hint to replace them: `SDL_HINT_RENDER_OPENGL_SHADERS`, `SDL_HINT_RENDER_SCALE_QUALITY`, `SDL_HINT_VIDEO_X11_XVIDMODE`, `SDL_HINT_VIDEO_X11_XINERAMA`, `SDL_HINT_MOUSE_RELATIVE_MODE_WARP`, `SDL_HINT_IDLE_TIMER_DISABLED`, `SDL_HINT_ACCELEROMETER_AS_JOYSTICK`, `SDL_HINT_XINPUT_USE_OLD_JOYSTICK_MAPPING`, `SDL_HINT_THREAD_STACK_SIZE`, `SDL_HINT_VIDEO_HIGHDPI_DISABLED`, `SDL_HINT_VIDEO_WINDOW_SHARE_PIXEL_FORMAT`, the three `SDL_HINT_WINRT_*`, the two `SDL_HINT_ANDROID_APK_EXPANSION_*` and `SDL_HINT_ANDROID_SEPARATE_MOUSE_AND_TOUCH`. They are kept, with their values, and marked `@:deprecated` with what SDL 3 does instead — deprecated rather than removed, so code that names them still compiles and is told why the hint has no effect.
- `SDL_HINT_GRAB_KEYBOARD` stays as it is: SDL 3 dropped it, but hlsdl emulates it (`hint_value` and `set_window_grab` in `sdl.c`).
- Not in this change: bindings for SDL 3 hints the enum has never had, and bindings for the APIs that replace the removed hints (`SDL_SetTextureScaleMode`, `SDL_DisableScreenSaver`, …).

## Capabilities

### New Capabilities
- `sdl-hints`: which names `sdl.SDLHint` holds under SDL 3 — SDL 3 hint names, the emulated keyboard grab hint, and deprecated SDL 2 names.

### Modified Capabilities

## Impact
- `libs/sdl/sdl/Sdl.hx` (code). Additive constants; `SDL_HINT_ALLOW_TOPMOST` changes value, so code that set it takes effect again; code that uses one of the deprecated constants gets a compiler warning, nothing more.
