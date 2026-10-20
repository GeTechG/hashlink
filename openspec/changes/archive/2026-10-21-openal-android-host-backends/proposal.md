## Why
In an Android cross build with `DOWNLOAD_DEPENDENCIES`, OpenAL-soft's `pkg_check_modules` runs the build host's `pkg-config`, which is not confined to the NDK sysroot. On a Linux host with PipeWire and D-Bus development files it finds `libpipewire-0.3` and `dbus-1`, and OpenAL-soft compiles its PipeWire backend and RTKit support against host headers (`/usr/include/pipewire-0.3`, `/usr/include/dbus-1.0`). The backends reported are `PipeWire, OpenSL, WaveFile, Null`. On a device the PipeWire backend only logs `Failed to load libpipewire-0.3.so.0` and OpenAL-soft falls through to OpenSL, but what goes into an Android library must not depend on what the build host happens to have installed.

## What Changes
- On Android, OpenAL-soft is configured with the backends that cannot exist there turned off: PipeWire, PulseAudio, ALSA, OSS, Solaris, SndIO, JACK and PortAudio, and without RTKit (`ALSOFT_RTKIT=OFF`). OpenSL ES stays required; Oboe (only used when its package is provided) and the WaveFile/Null backends are untouched.
- Turning these off by name, rather than steering `pkg-config` away from the host through the environment, keeps the decision inside OpenAL-soft's configuration and leaves the rest of the build's `pkg-config` use alone.

## Capabilities

### New Capabilities

### Modified Capabilities
- `openal-static`: the OpenAL-soft fetched for Android contains no desktop backend found on the build host.

## Impact
- `libs/openal/CMakeLists.txt` (code). `libopenal.a` for Android loses `alc/backends/pipewire.cpp` and the RTKit/D-Bus wrapper; the backends become `OpenSL, WaveFile, Null` whatever the host has installed. No change on other platforms.
