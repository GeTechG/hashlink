## ADDED Requirements

### Requirement: HarfBuzz is built into the library from a pinned release
`harfbuzz.hdll` SHALL contain HarfBuzz compiled from the release whose URL and SHA-256 `libs/harfbuzz/CMakeLists.txt` pins, with no FreeType, ICU, GLib or platform shaper, and SHALL NOT need a HarfBuzz installed on the system. The same `libs/harfbuzz/CMakeLists.txt` SHALL build it for desktop targets and, with the NDK toolchain, for Android. `WITH_HARFBUZZ=OFF` SHALL leave it out of the build.

#### Scenario: Desktop build
- **WHEN** the repo is built with CMake on Linux, macOS or Windows with `WITH_HARFBUZZ` left on
- **THEN** `harfbuzz.hdll` is built, and it loads on a machine without a HarfBuzz library

#### Scenario: Android build
- **WHEN** the repo is configured with the NDK toolchain file, `BUILD_SHARED_LIBS=OFF` and `WITH_VM=OFF`, as the `Build` workflow does
- **THEN** the static `harfbuzz.hdll` builds, and an HL/C program linked with it shapes text

### Requirement: A face and a font are created from the bytes of a font file
`harfbuzz.Face.fromBytes(bytes, index)` SHALL create a face from the face `index` of the font file held in `bytes` and SHALL keep its own copy of them. Bytes that hold no font with glyphs SHALL raise an exception. `new harfbuzz.Font(face)` SHALL create a font of that face; its scale SHALL be the units per em of the face until `setScale(x, y)` sets another, and advances and offsets SHALL be in units of that scale. A face, a font and a buffer SHALL be released when the garbage collector frees the Haxe object.

#### Scenario: Font file
- **WHEN** a program reads a TrueType file into `haxe.io.Bytes` and calls `Face.fromBytes(bytes, 0)`
- **THEN** it gets a face whose `upem` and `glyphCount` are those of the file

#### Scenario: Not a font
- **WHEN** a program calls `Face.fromBytes` with bytes that are not a font file
- **THEN** the call throws

#### Scenario: Scale
- **WHEN** the same text is shaped once with the default scale and once after `setScale(2 * upem, 2 * upem)`
- **THEN** every advance of the second run is twice the advance of the first

### Requirement: A buffer holds the text and its segment properties
`harfbuzz.Buffer` SHALL take UTF-16 text from a Haxe `String` (all of it or a range), with the rest of the string as context. It SHALL set and report direction, script (ISO 15924 tag, e.g. `"Arab"`) and language (BCP 47, e.g. `"ar"`), and `guessSegmentProperties()` SHALL fill those not set from the text. Clusters SHALL be UTF-16 indices into the string. `clear()` SHALL empty the buffer and its properties so that it can be filled again.

#### Scenario: Arabic text
- **WHEN** the buffer holds the Arabic word `سلام` and `guessSegmentProperties()` is called
- **THEN** the direction is right to left and the script is `"Arab"`

#### Scenario: Properties set by the program
- **WHEN** the program sets direction, script and language before shaping
- **THEN** the buffer reports the values it set

### Requirement: Shaping turns the text into positioned glyphs
`font.shape(buffer, features)` SHALL shape the buffer with HarfBuzz; `features` is null or a comma-separated list in HarfBuzz feature syntax (e.g. `"-liga,kern"`), and a list HarfBuzz cannot read SHALL raise an exception. Shaping a buffer whose direction is not set, or that is already shaped, and adding text to a shaped buffer SHALL raise an exception. `buffer.glyphs()` SHALL then return, for each glyph in visual order, its glyph id, cluster, x and y advance, and x and y offset.

#### Scenario: Latin ligature
- **WHEN** the string `"fi"` is shaped with a font whose `liga` feature substitutes the `fi` ligature
- **THEN** there is one glyph, not the glyph of `f` or `i`, with cluster 0

#### Scenario: Ligature turned off
- **WHEN** the same string is shaped with features `"-liga"`
- **THEN** there are two glyphs, with clusters 0 and 1

#### Scenario: Arabic word
- **WHEN** `سلام` is shaped with a font of the Arabic script after `guessSegmentProperties()`
- **THEN** there are three glyphs, as lam and alef form one ligature, and their clusters decrease from first to last

#### Scenario: Direction not set
- **WHEN** a buffer with text and no direction is shaped
- **THEN** the call throws

#### Scenario: Same program in bytecode and in C
- **WHEN** the shaping test is run as bytecode under `hl` and as an HL/C program, on desktop and on Android
- **THEN** all runs pass and report the same glyphs
