## REMOVED Requirements

### Requirement: The stream is decoded to interleaved PCM in chunks
**Reason**: Split so that each requirement states one behaviour in at most 500 characters.
**Migration**: *The stream is decoded to interleaved PCM*, *The stream position is reported and can be moved* state the same behaviour; nothing to migrate.

## ADDED Requirements

### Requirement: The stream is decoded to interleaved PCM
`fmt.opus_read(stream, out, size, format)` SHALL decode the next samples into `out`, at most `size` bytes, as interleaved PCM in native byte order: signed 16-bit for format 2, 32-bit float for format 3. It SHALL return the number of bytes written, 0 at the end of the stream, a negative value where the data cannot be decoded (after which reading may continue), and -1 for any other format.

#### Scenario: PCM matches opusdec
- **WHEN** a clip is read to the end in chunks, once as 16-bit and once as float
- **THEN** each read yields exactly samples × channels values, and they match the output of `opusdec --no-dither` for the same clip within a small tolerance

#### Scenario: Damaged or truncated stream
- **WHEN** a clip with bytes overwritten in the middle, or cut after its headers, is opened and read until `opus_read` returns 0 or stops making progress
- **THEN** the program does not crash, and a cut clip yields at most the samples of the whole one

#### Scenario: Unknown format
- **WHEN** `opus_read` is called with a format other than 2 or 3
- **THEN** it returns -1

#### Scenario: Same program in bytecode and in C
- **WHEN** the Opus test is run as bytecode under `hl` and as an HL/C program
- **THEN** both runs pass

### Requirement: The stream position is reported and can be moved
`fmt.opus_tell(stream)` SHALL return the position in samples per channel, and `fmt.opus_seek(stream, sample)` SHALL move to that sample and return whether it could.

#### Scenario: Seek
- **WHEN** a program seeks to sample 6000 of a clip and reads
- **THEN** `opus_seek` returns true, `opus_tell` reports 6000 and the samples read match the reference from sample 6000 on
