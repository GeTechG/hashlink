## Why
Text that is drawn glyph by glyph from a character map has no kerning, no ligatures, no joining scripts (Arabic) and no right-to-left order. A Haxe program on HashLink (JIT and HL/C, desktop and Android) has no text shaper to call: the repo binds SDL, OpenAL, SQLite and others, but not HarfBuzz.

## What Changes
- New library `libs/harfbuzz`: `harfbuzz.hdll`, a binding of HarfBuzz, and the Haxe package `harfbuzz` that calls it.
- HarfBuzz itself is a pinned release (14.6.0, URL and SHA-256 in `libs/harfbuzz/CMakeLists.txt`), downloaded at configure time and compiled from its single-file amalgamation `src/harfbuzz.cc` into the library: statically, with no FreeType, ICU, GLib or platform shaper. The same CMake serves desktop and Android.
- The Haxe API is the minimum to shape a run of text: a face from the bytes of a font file, a font of that face with a scale, a buffer with UTF-16 text, direction, script and language (set, or guessed from the text), shaping with optional OpenType features, and the result read back as glyph id, cluster, advance and offset per glyph.
- `WITH_HARFBUZZ` (default `ON`) builds it, like the other libraries.
- Tests: one Haxe program, run both as bytecode under `hl` and compiled to C, shapes a Latin `"fi"` with a font that has the ligature and an Arabic word with a font that has the script.

## Capabilities

### New Capabilities
- `harfbuzz`: what `harfbuzz.hdll` and the `harfbuzz` Haxe package do: create a face and a font, fill and describe a buffer, shape it, read the glyphs; how HarfBuzz is built in.

### Modified Capabilities

## Impact
- New: `libs/harfbuzz/` (C, CMake, Haxe), `other/tests/HarfbuzzTest.hx` and its two test fonts under `other/tests/fonts/`.
- `CMakeLists.txt`: option `WITH_HARFBUZZ` and the test, bytecode and HL/C. `libs/CMakeLists.txt`: adds the library.
- A CMake build with `WITH_HARFBUZZ=ON` downloads the HarfBuzz release (about 20 MB) at configure time and needs a C++11 compiler. The `Makefile` and the Visual Studio projects do not build the library.
