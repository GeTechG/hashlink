## Why
A game picks its starting locale from the user's preferred locales. On HashLink the only source today is `std.sys_locale`, which reads `getenv("LANG")`: on Android that variable is empty, and it gives one locale, not a list. SDL 3 has `SDL_GetPreferredLocales`, which reads the system settings on desktop and the `LocaleList` on Android, but `sdl.Sdl` has no binding for it.

## What Changes
- New `sdl.Sdl.getPreferredLocales() : Array<String>`, backed by a new `get_preferred_locales` primitive in `sdl.c` that calls `SDL_GetPreferredLocales`. Each element is `language` or `language-COUNTRY` (BCP 47 form, joined with `-`), in the user's order of preference. When SDL reports nothing or fails, the array is empty. The list SDL allocates is released with `SDL_free`.

## Capabilities

### New Capabilities
- `sdl-locale`: the system's preferred locales as `sdl.Sdl` reports them.

### Modified Capabilities

## Impact
- `libs/sdl/sdl.c`, `libs/sdl/sdl/Sdl.hx` (code). Additive API.
