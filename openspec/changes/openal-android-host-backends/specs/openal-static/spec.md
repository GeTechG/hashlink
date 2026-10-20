## ADDED Requirements

### Requirement: OpenAL-soft for Android has no desktop backends
The OpenAL-soft that `libs/openal/CMakeLists.txt` fetches with `DOWNLOAD_DEPENDENCIES` SHALL, when built for Android, be configured without the PipeWire, PulseAudio, ALSA, OSS, Solaris, SndIO, JACK and PortAudio backends and without RTKit support, so that nothing the build host has installed is compiled into it.

#### Scenario: Host with PipeWire and D-Bus development files
- **WHEN** `openal.hdll` is configured for Android with `DOWNLOAD_DEPENDENCIES` on a Linux host where `pkg-config` finds `libpipewire-0.3` and `dbus-1`
- **THEN** OpenAL-soft lists `OpenSL, WaveFile, Null` as its backends and compiles nothing against the host's PipeWire or D-Bus headers

#### Scenario: Other platforms
- **WHEN** OpenAL-soft is fetched with `DOWNLOAD_DEPENDENCIES` for a platform other than Android
- **THEN** its backend options keep OpenAL-soft's defaults
