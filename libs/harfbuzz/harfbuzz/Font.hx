package harfbuzz;

private typedef FontPtr = hl.Abstract<"hb_font">;

/**
	A font: a face at a scale. Advances and offsets of the glyphs it shapes are in units of that scale,
	which is the units per em of the face until `setScale` sets another.
**/
abstract Font(FontPtr) {

	public inline function new( face : Face ) {
		this = font_create(face);
	}

	/**
		Sets the horizontal and vertical scale (for example the pixel size times 64 for 26.6 fixed point).
	**/
	public inline function setScale( x : Int, y : Int ) {
		font_set_scale(this, x, y);
	}

	/**
		Shapes the text of `buffer`, whose direction must be set (see `Buffer.guessSegmentProperties`).
		`features` is null or a comma-separated list in HarfBuzz syntax, for example `"-liga,kern"`.
		The buffer then holds glyphs: read them with `Buffer.glyphs`.
	**/
	public function shape( buffer : Buffer, ?features : String ) {
		font_shape(this, buffer, features == null ? null : @:privateAccess features.toUtf8());
	}

	@:hlNative("harfbuzz", "font_create")
	static function font_create( face : Face ) : FontPtr { return null; }
	@:hlNative("harfbuzz", "font_set_scale")
	static function font_set_scale( f : FontPtr, x : Int, y : Int ) {}
	@:hlNative("harfbuzz", "font_shape")
	static function font_shape( f : FontPtr, b : Buffer, features : hl.Bytes ) {}
}
