## ADDED Requirements

### Requirement: libopus and opusfile are built into fmt.hdll from pinned releases
A CMake build with `WITH_OPUS` on SHALL compile libopus and opusfile from the releases whose URLs and SHA-256 `libs/fmt/CMakeLists.txt` pins into `fmt.hdll`, and `fmt.hdll` SHALL NOT need a libopus or opusfile installed on the system. The same `libs/fmt/CMakeLists.txt` SHALL do it for Linux, macOS, Windows and, with the NDK toolchain, Android. `WITH_OPUS` SHALL default to on with CMake 3.18 or later and to off with an older CMake.

#### Scenario: Desktop build
- **WHEN** the repo is built with CMake 3.18 or later with `WITH_OPUS` left at its default
- **THEN** `fmt.hdll` decodes Ogg Opus, and it loads on a machine without libopus or opusfile

#### Scenario: Build without Opus
- **WHEN** `fmt.hdll` is built with `WITH_OPUS=OFF`, by the `Makefile` or by the Visual Studio project
- **THEN** the Opus primitives exist, and `opus_open` throws an exception saying that Opus is not supported

### Requirement: An Ogg Opus stream is opened from bytes in memory
`fmt.opus_open(bytes, size)` SHALL open the Ogg Opus stream held in the first `size` bytes and SHALL keep its own copy of them. It SHALL return null, not crash, when the bytes are not an Ogg Opus stream or end before its headers do. `fmt.opus_info` SHALL report the bitrate in bits per second, the rate (always 48000), the length in samples per channel after pre-skip, and the number of channels. The stream SHALL be released when the garbage collector frees its handle.

#### Scenario: Mono and stereo clips
- **WHEN** a program opens a mono and a stereo Ogg Opus clip of 12000 samples
- **THEN** `opus_info` reports rate 48000, 12000 samples, and 1 and 2 channels

#### Scenario: Not an Opus stream
- **WHEN** a program opens bytes that are not Ogg Opus, or only the first bytes of a clip
- **THEN** `opus_open` returns null

### Requirement: The stream is decoded to interleaved PCM in chunks
`fmt.opus_read(stream, out, size, format)` SHALL decode the next samples into `out`, at most `size` bytes, as interleaved PCM in native byte order: signed 16-bit for format 2, 32-bit float for format 3. It SHALL return the number of bytes written, 0 at the end of the stream, a negative value where the data cannot be decoded (after which reading may continue), and -1 for any other format. `fmt.opus_tell` SHALL return the position in samples per channel, and `fmt.opus_seek(stream, sample)` SHALL move to that sample and return whether it could.

#### Scenario: PCM matches opusdec
- **WHEN** a clip is read to the end in chunks, once as 16-bit and once as float
- **THEN** each read yields exactly samples × channels values, and they match the output of `opusdec --no-dither` for the same clip within a small tolerance

#### Scenario: Seek
- **WHEN** a program seeks to sample 6000 of a clip and reads
- **THEN** `opus_tell` reports 6000 and the samples read match the reference from sample 6000 on

#### Scenario: Damaged or truncated stream
- **WHEN** a clip with bytes overwritten in the middle, or cut after its headers, is opened and read until `opus_read` returns 0 or stops making progress
- **THEN** the program does not crash, and a cut clip yields at most the samples of the whole one

#### Scenario: Same program in bytecode and in C
- **WHEN** the Opus test is run as bytecode under `hl` and as an HL/C program
- **THEN** both runs pass
