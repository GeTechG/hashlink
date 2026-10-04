// UTF-16 to UTF-8 : a surrogate that is not part of a pair is encoded as a single unit and does not eat what follows
class Surrogate {

	static function check(name:String, s:String, expected:String) {
		var hex = haxe.io.Bytes.ofString(s).toHex();
		if( hex != expected ) throw '$name: $hex should be $expected';
	}

	static function main() {
		var pair = "a😀";
		check("pair", pair, "61f09f9880");
		check("lone high at the end", pair.substr(0, 2), "61eda0bd");
		check("lone low", pair.substr(2, 1) + "b", "edb88062");
		check("high not followed by a low", pair.substr(1, 1) + "b", "eda0bd62");
		check("high followed by a pair", pair.substr(1, 1) + pair.substr(1, 2), "eda0bdf09f9880");
		if( StringTools.urlEncode("\u{1FFFF}") != "%F0%9F%BF%BF" ) throw "urlEncode: " + StringTools.urlEncode("\u{1FFFF}");
		trace("ok");
	}
}
