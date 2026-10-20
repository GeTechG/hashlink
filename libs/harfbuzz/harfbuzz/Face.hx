package harfbuzz;

private typedef FacePtr = hl.Abstract<"hb_face">;

/**
	A face of a font file. It keeps its own copy of the font data.
**/
abstract Face(FacePtr) {

	/**
		The units per em of the face.
	**/
	public var upem(get, never) : Int;

	/**
		The number of glyphs of the face.
	**/
	public var glyphCount(get, never) : Int;

	/**
		Creates the face `index` of the font file held in `bytes` (a TrueType or OpenType file, or a collection).
		Throws when the bytes hold no font with glyphs.
	**/
	public static function fromBytes( bytes : haxe.io.Bytes, index = 0 ) : Face {
		return face_create(bytes, bytes.length, index);
	}

	inline function get_upem() return face_get_upem(this);
	inline function get_glyphCount() return face_get_glyph_count(this);

	@:hlNative("harfbuzz", "face_create")
	static function face_create( data : hl.Bytes, len : Int, index : Int ) : Face { return null; }
	@:hlNative("harfbuzz", "face_get_upem")
	static function face_get_upem( f : FacePtr ) : Int { return 0; }
	@:hlNative("harfbuzz", "face_get_glyph_count")
	static function face_get_glyph_count( f : FacePtr ) : Int { return 0; }
}
