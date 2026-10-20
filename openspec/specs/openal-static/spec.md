# openal-static Specification

## Purpose
What `openal.hdll` built against a static OpenAL-soft needs from that library: it links to the release `libs/openal/CMakeLists.txt` pins, an extension function the release does not provide is looked up at run time and throws when called, and on Android the library has a playback backend.

## Requirements

### Requirement: openal.hdll links to the OpenAL-soft release it pins
`openal.hdll` built with `WITH_STATIC_OPENAL=ON` SHALL reference only the functions the OpenAL-soft release pinned in `libs/openal/CMakeLists.txt` exports. An extension function that release declares but does not export SHALL be looked up at run time with `alGetProcAddress` by `al_load_extensions`, not linked.

#### Scenario: Static link of a program with sound
- **WHEN** a program links `openal.hdll` and the static OpenAL-soft 1.24.3 into one shared library, as an Android HL/C application does
- **THEN** the link has no undefined `al*` or `alc*` symbol

### Requirement: A missing extension function throws when called
The primitive of an extension function that `al_load_extensions` did not find SHALL throw "Unsupported extension function" when called, in the static build as in the dynamic one.

#### Scenario: Foldback with OpenAL-soft 1.24.3
- **WHEN** a program on a static OpenAL-soft 1.24.3 calls `AL.loadExtensions()` and then `ExtAL.requestFoldbackStart` or `ExtAL.requestFoldbackStop`
- **THEN** the call throws "Unsupported extension function"

### Requirement: CI links openal.hdll to the static OpenAL-soft for Android
The fork's `CI` workflow SHALL build, on every push to `master` and every pull request, `openal.hdll` for Android as a shared library linked with `-Wl,--no-undefined` to the static OpenAL-soft that `libs/openal/CMakeLists.txt` pins, and SHALL fail when that link fails.

#### Scenario: An undefined OpenAL symbol
- **WHEN** `openal.c` built with `OPENAL_STATIC` references a function the pinned OpenAL-soft does not export
- **THEN** the `android-openal-static` job fails with an undefined reference to it

#### Scenario: openal.hdll links
- **WHEN** every `al*` and `alc*` symbol `openal.c` references is exported by the pinned OpenAL-soft
- **THEN** the job passes

### Requirement: OpenAL-soft for Android has a playback backend
The OpenAL-soft that `libs/openal/CMakeLists.txt` fetches with `DOWNLOAD_DEPENDENCIES` SHALL, when built for Android, include the OpenSL ES playback backend, which loads the system `libOpenSLES.so` at run time, also with `WITH_STATIC_OPENAL=ON`. A configuration that cannot enable it SHALL fail.

#### Scenario: Static OpenAL-soft for Android
- **WHEN** `openal.hdll` is configured for Android with `DOWNLOAD_DEPENDENCIES` and `WITH_STATIC_OPENAL=ON`
- **THEN** OpenAL-soft lists OpenSL among its enabled backends and `openal.hdll` links

#### Scenario: Sound on a device
- **WHEN** a program linked to that OpenAL-soft calls `alcOpenDevice(NULL)` on an Android device
- **THEN** it gets a device, not `No playback backend available!`

#### Scenario: OpenSL ES not found
- **WHEN** the OpenSL ES library or headers are not found while configuring for Android
- **THEN** the configure fails with "Failed to enable required OpenSL backend"

### Requirement: OpenAL-soft for Android has no desktop backends
The OpenAL-soft that `libs/openal/CMakeLists.txt` fetches with `DOWNLOAD_DEPENDENCIES` SHALL, when built for Android, be configured without the PipeWire, PulseAudio, ALSA, OSS, Solaris, SndIO, JACK and PortAudio backends and without RTKit support, so that nothing the build host has installed is compiled into it.

#### Scenario: Host with PipeWire and D-Bus development files
- **WHEN** `openal.hdll` is configured for Android with `DOWNLOAD_DEPENDENCIES` on a Linux host where `pkg-config` finds `libpipewire-0.3` and `dbus-1`
- **THEN** OpenAL-soft lists `OpenSL, WaveFile, Null` as its backends and compiles nothing against the host's PipeWire or D-Bus headers

#### Scenario: Other platforms
- **WHEN** OpenAL-soft is fetched with `DOWNLOAD_DEPENDENCIES` for a platform other than Android
- **THEN** its backend options keep OpenAL-soft's defaults
