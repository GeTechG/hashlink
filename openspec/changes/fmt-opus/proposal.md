## Why
A HashLink program can decode Ogg Vorbis and MP3 with `fmt.hdll`, but not Ogg Opus, the codec a game now ships its sounds in more and more (smaller files at the same quality, the format browsers decode natively). On the web the browser decodes it; on HashLink there is nothing to call.

## What Changes
- `fmt.hdll` gets an Ogg Opus decoder with the same shape as its Ogg Vorbis one: `opus_open` (from bytes in memory), `opus_info` (bitrate, rate, length in samples, channels), `opus_tell`, `opus_seek`, `opus_read` (interleaved PCM, signed 16-bit or 32-bit float).
- libopus (1.5.2) and opusfile (0.12) are pinned releases (URL and SHA-256 in `libs/fmt/CMakeLists.txt`), downloaded at configure time and compiled from their sources into `fmt.hdll`: statically, on every CMake target (Linux, macOS, Windows, Android), nothing needed on the system.
- `WITH_OPUS` (default `ON` with CMake 3.18 or later) builds the decoder in. Without it — an older CMake, the `Makefile`, the Visual Studio projects — the primitives exist and `opus_open` throws.
- Tests: one Haxe program, run as bytecode under `hl` and compiled to C, decodes a mono and a stereo clip and compares the PCM with the output of `opusdec`; damaged and truncated streams are refused or decoded as far as they go, never a crash.

## Capabilities

### New Capabilities
- `fmt-opus`: what the Ogg Opus primitives of `fmt.hdll` do and how libopus and opusfile are built in.

### Modified Capabilities

## Impact
- `libs/fmt/fmt.c`: the Opus primitives. `libs/fmt/CMakeLists.txt`: the download and the sources of libopus and opusfile.
- `CMakeLists.txt`: option `WITH_OPUS` and the test, bytecode and HL/C. New: `other/tests/OpusTest.hx` and its clips under `other/tests/opus/`.
- A CMake build with `WITH_OPUS=ON` downloads about 9 MB at configure time. The `Makefile` and `fmt.vcxproj` are unchanged and build `fmt.hdll` without Opus.
