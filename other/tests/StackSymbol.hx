import haxe.NativeStackTrace;

// resolves the symbols of an exception stack in a buffer too small for them
@:access(haxe.NativeStackTrace)
class StackSymbol {

	static inline var SIZE = 16;
	static inline var GUARD = 0x2A2A;

	static function fail() {
		throw "fail";
	}

	static function main() {
		var stack = try {
			fail();
			null;
		} catch( e : Dynamic ) {
			var arr = new hl.NativeArray(NativeStackTrace.exceptionStackRaw(null));
			NativeStackTrace.exceptionStackRaw(arr);
			arr;
		}
		var resolved = 0;
		for( sym in stack ) {
			var buf = new hl.Bytes((SIZE + 8) << 1);
			for( i in 0...SIZE + 8 )
				buf.setUI16(i << 1, GUARD);
			var size = SIZE;
			var str = NativeStackTrace.resolveSymbol(sym, buf, size);
			if( str == null ) continue;
			resolved++;
			if( size != @:privateAccess str.ucs2Length(0) )
				throw "size " + size + " is not the length of " + @:privateAccess String.fromUCS2(str);
			if( buf.getUI16(0) == GUARD ) continue; // the resolver allocated its own
			if( size >= SIZE )
				throw "size " + size + " does not fit";
			for( i in SIZE...SIZE + 8 )
				if( buf.getUI16(i << 1) != GUARD )
					throw "wrote past the buffer at " + i;
		}
		// HL/C on Windows only resolves with debug symbols
		var optional = #if hlc Sys.systemName() == "Windows" #else false #end;
		if( resolved == 0 && !optional )
			throw "no symbol resolved";
		trace("OK " + resolved);
	}

}
