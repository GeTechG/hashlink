import harfbuzz.*;

/**
	Shapes text with harfbuzz.hdll. Argument: the directory of the test fonts (other/tests/fonts).
**/
class HarfbuzzTest {

	static var failed = 0;

	static function check( name : String, ok : Bool, ?detail : String ) {
		Sys.println((ok ? "ok " : "FAILED ") + name + (detail == null ? "" : ": " + detail));
		if( !ok ) failed++;
	}

	static function describe( run : GlyphRun ) {
		return [for( i in 0...run.length ) run.glyphId(i) + "@" + run.cluster(i) + "+" + run.xAdvance(i)].join(" ");
	}

	static function fill( text : String ) {
		var buf = new Buffer();
		buf.addString(text);
		buf.guessSegmentProperties();
		return buf;
	}

	static function shape( font : Font, text : String, ?features : String ) {
		var buf = fill(text);
		font.shape(buf, features);
		return buf;
	}

	static function main() {
		var dir = Sys.args()[0];
		if( dir == null ) dir = "other/tests/fonts";

		var latin = Face.fromBytes(sys.io.File.getBytes(dir + "/NotoSans-fi.ttf"));
		check("face", latin.upem == 1000 && latin.glyphCount > 2, latin.upem + " " + latin.glyphCount);
		var font = new Font(latin);

		var buf = shape(font, "fi");
		var run = buf.glyphs();
		check("direction ltr", buf.getDirection() == LeftToRight);
		check("script latn", buf.getScript() == "Latn", buf.getScript());
		check("fi ligature", run.length == 1 && run.cluster(0) == 0 && run.xAdvance(0) > 0, describe(run));
		var ligature = run.length == 1 ? run.glyphId(0) : -1;
		var ligatureAdvance = run.length == 1 ? run.xAdvance(0) : -1;

		run = shape(font, "fi", "-liga").glyphs();
		check("fi without liga", run.length == 2 && run.cluster(0) == 0 && run.cluster(1) == 1
			&& run.glyphId(0) != ligature && run.glyphId(1) != ligature, describe(run));

		font.setScale(2000, 2000);
		run = shape(font, "fi").glyphs();
		check("scale", run.length == 1 && run.xAdvance(0) == ligatureAdvance * 2, describe(run));

		var arabic = new Font(Face.fromBytes(sys.io.File.getBytes(dir + "/NotoSansArabic-salam.ttf")));
		buf = shape(arabic, "سلام");
		run = buf.glyphs();
		check("direction rtl", buf.getDirection() == RightToLeft);
		check("script arab", buf.getScript() == "Arab", buf.getScript());
		check("arabic glyphs", run.length == 3 && run.cluster(0) > run.cluster(1) && run.cluster(1) > run.cluster(2)
			&& run.cluster(2) == 0, describe(run));

		buf.clear();
		check("clear", buf.length == 0 && buf.getDirection() == Invalid && buf.getScript() == null);
		buf.addString("xسلامx", 1, 4);
		buf.setDirection(RightToLeft);
		buf.setScript("Arab");
		buf.setLanguage("ar");
		check("properties", buf.getDirection() == RightToLeft && buf.getScript() == "Arab" && buf.getLanguage() == "ar",
			buf.getDirection() + " " + buf.getScript() + " " + buf.getLanguage());
		arabic.shape(buf);
		run = buf.glyphs();
		check("range", run.length == 3 && run.cluster(2) == 1, describe(run));

		var unset = new Buffer();
		unset.addString("fi");
		check("no direction throws", throws(() -> font.shape(unset)));
		check("bad features throw", throws(() -> font.shape(fill("fi"), "kern,ligature")));
		check("shaped twice throws", throws(() -> font.shape(shape(font, "fi"))));
		check("not a font throws", throws(() -> Face.fromBytes(haxe.io.Bytes.ofString("not a font"))));

		if( failed > 0 ) {
			Sys.println(failed + " failed");
			Sys.exit(1);
		}
		Sys.println("all ok");
	}

	static function throws( f : () -> Void ) {
		try f() catch( e : Dynamic ) return true;
		return false;
	}
}
