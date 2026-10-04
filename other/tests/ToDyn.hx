// conversion to Dynamic : the JIT has to read the current value of a Bool and keep a null pointer null
class ToDyn {

	static function check(name:String, got:Dynamic, expected:Dynamic) {
		if( got != expected ) throw '$name: got $got, expected $expected';
	}

	static function mayThrow() {
		if( Math.random() >= 0 ) throw "x";
	}

	static function boolInCatch():Dynamic {
		var ok = false;
		try {
			ok = true;
			mayThrow();
		} catch( e : Dynamic ) {
			var d:Dynamic = ok;
			return d;
		}
		return null;
	}

	static function boolRef():Dynamic {
		var ok = false;
		var r = hl.Ref.make(ok);
		r.set(true);
		var d:Dynamic = ok;
		return d;
	}

	@:keep static function bytesToDyn(b:hl.Bytes):Dynamic return b;

	static function main() {
		check("bool in catch", boolInCatch(), true);
		check("bool ref", boolRef(), true);
		check("null bytes", bytesToDyn(null) == null, true);
		check("bytes", bytesToDyn(new hl.Bytes(1)) != null, true);
		trace("ok");
	}
}
