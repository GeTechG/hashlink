# sdl-touch Specification

## Purpose
The touch devices `sdl.Sdl` reports, so that an application can tell whether the machine has a touch screen.

## Requirements

### Requirement: Touch device count
`sdl.Sdl.getTouchDeviceCount()` SHALL return the number of touch devices SDL reports (`SDL_GetTouchDevices`), as an `Int`. When SDL reports no device or fails, it SHALL return `0`. The array SDL allocates SHALL be released with `SDL_free`. The value is meaningful once the video subsystem is initialised (after `Sdl.init`).

#### Scenario: Machine with a touch screen
- **WHEN** a program on a machine with a touch screen (or a virtual `uinput` touch device) calls `getTouchDeviceCount()` after `Sdl.init`
- **THEN** it returns a value greater than `0`

#### Scenario: Machine without a touch screen
- **WHEN** a program on a machine with no touch device calls `getTouchDeviceCount()` after `Sdl.init`
- **THEN** it returns `0`
