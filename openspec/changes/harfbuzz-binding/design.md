## Context
HarfBuzz is C++ with a C API. Its own CMake build has options for FreeType, ICU, GLib, CoreText, subsetting, raster, vector and GPU libraries; a release also ships `src/harfbuzz.cc`, one file that includes the whole shaping library. The other libraries of this repo download their dependencies with `FetchContent`/`ExternalProject` only under `DOWNLOAD_DEPENDENCIES` (Android) and use the system packages otherwise.

## Goals / Non-Goals
- Goals: shape a run of text from Haxe on HL bytecode and HL/C, desktop and Android, with one build description; the same glyphs on every target.
- Non-Goals: rasterising glyphs, font fallback, line breaking or bidi reordering of a paragraph (the caller splits text into runs of one direction and script), the Visual Studio projects and the `Makefile`.

## Decisions
- **Amalgamated source, always downloaded.** `libs/harfbuzz/CMakeLists.txt` fetches the release tarball (URL and SHA-256 pinned) with `FetchContent` on every target, with `SOURCE_SUBDIR` pointing at a directory without `CMakeLists.txt`, so HarfBuzz's own build is never configured, and compiles `src/harfbuzz.cc` into `harfbuzz.hdll`. No system HarfBuzz is used even on desktop: the glyphs then do not depend on the distribution's version, and a shaper is the kind of library whose output changes between versions. An offline build sets `FETCHCONTENT_SOURCE_DIR_HARFBUZZ-PROJECT` to an extracted release.
- **Compile flags of HarfBuzz's own build**: `-fno-exceptions -fno-rtti` (MSVC: `/bigobj`), `HAVE_PTHREAD` outside Windows so that its objects are thread-safe (Windows uses critical sections by default). The result does not depend on `libstdc++` (`ldd`: `libhl`, `libm`, `libgcc_s`, `libc`).
- **`WITH_HARFBUZZ` is declared in the root `CMakeLists.txt`**: the tests are declared there before `libs/` is added and must know whether the library exists. It defaults to `ON` only with CMake 3.18 or later (`FetchContent_MakeAvailable` with `SOURCE_SUBDIR`), so a build with an older CMake, which the repo still allows (3.13), is unchanged; turning it on there stops with a message.
- **Buffer text is the UTF-16 of the Haxe string**, passed without conversion (`hb_buffer_add_utf16`), so clusters are indices into the string the caller holds.
- **Glyphs are read with one native call**: `buffer_get_glyphs` copies id, cluster, advances and offsets (6 × int32 per glyph) into GC bytes that `GlyphRun` reads; no call per glyph.
- **Misuse throws instead of reaching a HarfBuzz assertion**: shaping without a direction, shaping or adding text to a shaped buffer, reading glyphs of a buffer that is not shaped, a bad text range or feature list.
- **Face data is copied** (`HB_MEMORY_MODE_DUPLICATE`): the Haxe bytes may be freed after `fromBytes`. A large font file is briefly held twice.
- **Test fonts are subsets** of Noto Sans and Noto Sans Arabic (OFL 1.1, no reserved font name), 3 KB and 6 KB, with the `liga` and Arabic features kept.

## Size budget
Measured on HarfBuzz 14.6.0, binding included, stripped:

| Target | Build | Without | With HarfBuzz | Cost |
|---|---|---|---|---|
| Linux x86_64, `harfbuzz.hdll` | RelWithDebInfo (`-O2`) | — | 1.38 MB | 1.38 MB |
| Android arm64-v8a, HL/C `.so` (NDK 27, API 24) | Release | 0.60 MB | 2.20 MB | +1.60 MB (+0.62 MB gzip) |
| Android x86_64, HL/C `.so` | Release | 0.59 MB | 2.22 MB | +1.62 MB (+0.64 MB gzip) |

"Without" is the HL/C `HelloWorld` linked statically with `libhl`; "with" is the HarfBuzz test linked with `libhl` and `harfbuzz.hdll`. The gzip column approximates the cost in a compressed APK. HarfBuzz's configuration macros (`HB_LEAN`, `HB_MINI`, `HB_NO_*`) can cut this further; they are not used, as they also turn off parts of shaping a game may need.

## Risks / Trade-offs
- Configure time downloads about 20 MB on every CMake build with the library on, desktop included → `WITH_HARFBUZZ=OFF` or a local source directory.
- The upstream `Build` workflow now builds and runs the library on every CMake platform; a compiler it has not met fails there first.
