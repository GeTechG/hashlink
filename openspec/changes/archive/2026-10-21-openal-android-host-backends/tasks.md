## 1. Build

- [x] 1.1 `libs/openal/CMakeLists.txt`: on Android, turn off OpenAL-soft's PipeWire, PulseAudio, ALSA, OSS, Solaris, SndIO, JACK and PortAudio backends and RTKit

## 2. Verification

- [x] 2.1 The `android-openal-static` configuration with NDK r27 on a host with PipeWire and D-Bus development files: OpenAL-soft reports the backends `OpenSL, WaveFile, Null`, no `libpipewire-0.3` or `dbus-1` module is checked, no host include path appears in the OpenAL build, and `openal.hdll` links; before the change `PipeWire, OpenSL, WaveFile, Null` and both modules found on the host (verified: the before configure had `-I/usr/include/pipewire-0.3`, `-I/usr/include/spa-0.2`, `-I/usr/include/dbus-1.0` in its flags, the after one has no `/usr` include path)
- [x] 2.2 Host (Linux) configure with `DOWNLOAD_DEPENDENCIES` unchanged: the desktop backends are still enabled there (host backends: `PipeWire, PulseAudio, ALSA, OSS, WaveFile, Null`)
