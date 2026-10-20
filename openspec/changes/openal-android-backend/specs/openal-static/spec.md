## ADDED Requirements

### Requirement: OpenAL-soft for Android has a playback backend
The OpenAL-soft that `libs/openal/CMakeLists.txt` fetches with `DOWNLOAD_DEPENDENCIES` SHALL, when built for Android, include the OpenSL ES playback backend, linked to the NDK's shared `libOpenSLES`, also with `WITH_STATIC_OPENAL=ON`. A configuration that cannot enable it SHALL fail.

#### Scenario: Static OpenAL-soft for Android
- **WHEN** `openal.hdll` is configured for Android with `DOWNLOAD_DEPENDENCIES` and `WITH_STATIC_OPENAL=ON`
- **THEN** OpenAL-soft lists OpenSL among its enabled backends and `openal.hdll` needs `libOpenSLES.so`

#### Scenario: Sound on a device
- **WHEN** a program linked to that OpenAL-soft calls `alcOpenDevice(NULL)` on an Android device
- **THEN** it gets a device, not `No playback backend available!`

#### Scenario: OpenSL ES not found
- **WHEN** the OpenSL ES library or headers are not found while configuring for Android
- **THEN** the configure fails with "Failed to enable required OpenSL backend"
