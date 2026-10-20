package harfbuzz;

/**
	The glyphs of a shaped buffer, in visual order. Advances and offsets are in units of the scale of the font.
**/
class GlyphRun {

	static inline var STRIDE = 6;

	var data : hl.Bytes;

	/**
		The number of glyphs.
	**/
	public var length(default, null) : Int;

	public function new( data : hl.Bytes, length : Int ) {
		this.data = data;
		this.length = length;
	}

	/**
		The glyph id in the face.
	**/
	public inline function glyphId( i : Int ) : Int return get(i, 0);

	/**
		The index of the first UTF-16 unit of the text this glyph comes from.
	**/
	public inline function cluster( i : Int ) : Int return get(i, 1);

	public inline function xAdvance( i : Int ) : Int return get(i, 2);
	public inline function yAdvance( i : Int ) : Int return get(i, 3);
	public inline function xOffset( i : Int ) : Int return get(i, 4);
	public inline function yOffset( i : Int ) : Int return get(i, 5);

	inline function get( i : Int, field : Int ) : Int {
		if( i < 0 || i >= length ) throw "Glyph index out of range";
		return data.getI32((i * STRIDE + field) << 2);
	}
}
