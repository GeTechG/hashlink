# harfbuzz.hdll

Text shaping with [HarfBuzz](https://harfbuzz.github.io): a run of text in, positioned glyphs out. HarfBuzz is downloaded at configure time (the release pinned in `CMakeLists.txt`) and built into the library; nothing is needed on the system. CMake option: `WITH_HARFBUZZ`.

```haxe
var font = new harfbuzz.Font(harfbuzz.Face.fromBytes(sys.io.File.getBytes("font.ttf")));
font.setScale(size * 64, size * 64);
var buf = new harfbuzz.Buffer();
buf.addString("Hello");
buf.guessSegmentProperties(); // or setDirection / setScript / setLanguage
font.shape(buf);              // optional features: font.shape(buf, "-liga,kern")
var run = buf.glyphs();
for( i in 0...run.length )
	trace(run.glyphId(i), run.cluster(i), run.xAdvance(i), run.xOffset(i), run.yOffset(i));
```

One buffer holds one run: one direction and one script. Splitting a paragraph into runs, bidi reordering, line breaking and drawing the glyphs are the caller's job. Call `buf.clear()` to shape new text with the same buffer.
