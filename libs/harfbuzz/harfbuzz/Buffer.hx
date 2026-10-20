package harfbuzz;

private typedef BufferPtr = hl.Abstract<"hb_buffer">;

/**
	The text to shape and its segment properties; after `Font.shape`, the glyphs.
**/
abstract Buffer(BufferPtr) {

	/**
		The number of characters before shaping, of glyphs after.
	**/
	public var length(get, never) : Int;

	public inline function new() {
		this = buffer_create();
	}

	/**
		Adds `length` UTF-16 units of `text` from `offset` (by default all of it); the rest of the string is the
		context shaping looks at. Clusters are UTF-16 indices into `text`.
	**/
	public function addString( text : String, offset = 0, length = -1 ) {
		buffer_add_utf16(this, text, offset, length < 0 ? text.length - offset : length);
	}

	public inline function setDirection( dir : Direction ) {
		buffer_set_direction(this, dir);
	}

	public inline function getDirection() : Direction {
		return cast buffer_get_direction(this);
	}

	/**
		Sets the script from its ISO 15924 tag, for example `"Latn"` or `"Arab"`.
	**/
	public function setScript( tag : String ) {
		buffer_set_script(this, @:privateAccess tag.toUtf8());
	}

	/**
		The ISO 15924 tag of the script, or null when it is not set.
	**/
	public function getScript() : Null<String> {
		var tag = buffer_get_script(this);
		if( tag == 0 ) return null;
		return String.fromCharCode(tag >>> 24) + String.fromCharCode((tag >> 16) & 0xFF) + String.fromCharCode((tag >> 8) & 0xFF) + String.fromCharCode(tag & 0xFF);
	}

	/**
		Sets the language from its BCP 47 tag, for example `"ar"`.
	**/
	public function setLanguage( lang : String ) {
		buffer_set_language(this, @:privateAccess lang.toUtf8());
	}

	/**
		The BCP 47 tag of the language, or null when it is not set.
	**/
	public function getLanguage() : Null<String> {
		var lang = buffer_get_language(this);
		return lang == null ? null : @:privateAccess String.fromUTF8(lang);
	}

	/**
		Sets the direction, script and language that are not set yet from the text and the locale.
	**/
	public inline function guessSegmentProperties() {
		buffer_guess_segment_properties(this);
	}

	/**
		Empties the buffer and unsets its properties, so that it can take new text.
	**/
	public inline function clear() {
		buffer_clear(this);
	}

	/**
		The glyphs of a shaped buffer, in visual order.
	**/
	public function glyphs() : GlyphRun {
		var len = buffer_get_length(this);
		return new GlyphRun(buffer_get_glyphs(this), len);
	}

	inline function get_length() return buffer_get_length(this);

	@:hlNative("harfbuzz", "buffer_create")
	static function buffer_create() : BufferPtr { return null; }
	@:hlNative("harfbuzz", "buffer_add_utf16")
	static function buffer_add_utf16( b : BufferPtr, text : String, offset : Int, length : Int ) {}
	@:hlNative("harfbuzz", "buffer_set_direction")
	static function buffer_set_direction( b : BufferPtr, dir : Int ) {}
	@:hlNative("harfbuzz", "buffer_get_direction")
	static function buffer_get_direction( b : BufferPtr ) : Int { return 0; }
	@:hlNative("harfbuzz", "buffer_set_script")
	static function buffer_set_script( b : BufferPtr, tag : hl.Bytes ) {}
	@:hlNative("harfbuzz", "buffer_get_script")
	static function buffer_get_script( b : BufferPtr ) : Int { return 0; }
	@:hlNative("harfbuzz", "buffer_set_language")
	static function buffer_set_language( b : BufferPtr, lang : hl.Bytes ) {}
	@:hlNative("harfbuzz", "buffer_get_language")
	static function buffer_get_language( b : BufferPtr ) : hl.Bytes { return null; }
	@:hlNative("harfbuzz", "buffer_guess_segment_properties")
	static function buffer_guess_segment_properties( b : BufferPtr ) {}
	@:hlNative("harfbuzz", "buffer_clear")
	static function buffer_clear( b : BufferPtr ) {}
	@:hlNative("harfbuzz", "buffer_get_length")
	static function buffer_get_length( b : BufferPtr ) : Int { return 0; }
	@:hlNative("harfbuzz", "buffer_get_glyphs")
	static function buffer_get_glyphs( b : BufferPtr ) : hl.Bytes { return null; }
}
