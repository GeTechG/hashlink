// hot reload (hl --hot-reload + sys_check_reload) : the module is patched with the same program built with -D v2
// value() is recompiled and has to call base()/Counter that stay in the first module, through calls and closures
// an optional second file built with -D v2 -D bad is tried first : it has the same value() but is refused,
// which should leave nothing behind (v2 still applies, no GC root is kept)
// optional third and fourth files built with -D v3 and -D v4 are applied after v2 : each of them replaces a string
// constant, so adds a global, and the one of v4 should not take the place of the one of v3
// an optional fifth file built with -D v4 -D many adds more globals than a module can take and should be refused
// an optional sixth file built with -D v4 -D v5 adds a string constant : the globals that follow are moved,
// which should not change the entry point nor float() (a single change is reported), and the core types (Float)
// are found in the globals they had, with the value they had before the first patch
// an optional seventh file built with -D v4 -D v5 -D v6 adds a class : the entry point is recompiled,
// it should only register the new class and not run main() again
// an optional eighth file built with -D v4 -D v5 -D v6 -D some adds most of the globals a module can take :
// the seventh file applied again adds none, so it should not be refused for the globals it does not have
class Strings {
	public static macro function many( n : Int ) {
		return haxe.macro.Context.parse("[" + [for( i in 0...n ) '"s$i"'].join(",") + "]", haxe.macro.Context.currentPos());
	}
}

#if !macro
class Counter {
	public var n : Int;
	public function new( n : Int ) {
		this.n = n;
	}
	public function get() : Int {
		return n;
	}
}

#if bad
class Extra {
	public static var counter = new Counter(1);
}
#end

#if v6
class Added {
	public var n = 5;
	public function new() {
	}
}
#end

class Reload {

	static var counter = new Counter(100);

	static function base() : Int {
		return 40;
	}

	static function call( f : Void -> Int ) : Int {
		return f();
	}

	static function value() : Int {
		return base() + call(base) + call(counter.get) + #if (v2 || v3 || v4) 2 #else 1 #end;
	}

	static function many() : Int {
		#if many
		return Strings.many(5000).length;
		#elseif some
		return Strings.many(3000).length;
		#else
		return 0;
		#end
	}

	static function added4() : String {
		return #if v4 "new4" #else "old4" #end;
	}

	// the global of Float comes after the ones of the strings
	static function added5( float : Dynamic ) : String {
		return #if v5 "new5" + Std.string("!") #else "old5" #end + (float == Float);
	}

	static function float() : Dynamic {
		return Float;
	}

	static function added6() : String {
		return #if v6 "new6" + new Added().n #else "old6" #end + (Type.resolveClass("Added") != null);
	}

	// when it applies the next patch, it keeps running its current code and constant
	static function added3( ?next : String ) : String {
		if( next != null ) reload(next);
		return #if (v3 || v4) "new3" #else "old3" #end;
	}

	static function refused() : Int {
		#if bad
		// the inner closure can't be resolved by the patch
		var k = Extra.counter.n;
		var f = function() { var g = function() return k; return call(g); };
		return call(f);
		#else
		return 0;
		#end
	}

	@:hlNative("std","sys_check_reload") static function checkReload( ?alt : hl.Bytes ) : Bool {
		return false;
	}

	static function reload( file : String ) : Bool {
		// the file time has a one second precision and has to differ from the previous one
		Sys.sleep(1.1);
		var tmp = Sys.programPath() + ".reload";
		sys.io.File.copy(file, tmp);
		var r = checkReload(Sys.systemName() == "Windows" ? @:privateAccess tmp.bytes : @:privateAccess tmp.toUtf8());
		sys.FileSystem.deleteFile(tmp);
		return r;
	}

	// number of GC roots, read from a memory dump (see hl_gc_dump_memory)
	static function roots() : Int {
		var tmp = Sys.programPath() + ".dump";
		hl.Gc.dumpMemory(tmp);
		var f = sys.io.File.read(tmp);
		f.seek(4, SeekBegin);
		var ptr = f.readInt32() & 1 != 0 ? 8 : 4;
		f.seek(8, SeekCur); // private data, mark stack
		for( i in 0...f.readInt32() ) {
			f.seek(ptr, SeekCur);
			var noptr = f.readInt32() & 2 != 0;
			var size = f.readInt32();
			f.seek(4, SeekCur);
			while( f.readInt32() | (ptr == 8 ? f.readInt32() : 0) != 0 ) {
				var bsize = f.readInt32();
				if( noptr && bsize >= ptr ) f.seek(ptr, SeekCur);
			}
			if( !noptr ) f.seek(size, SeekCur);
		}
		var n = f.readInt32();
		f.close();
		sys.FileSystem.deleteFile(tmp);
		return n;
	}

	static function main() {
		var before = value();
		var float = float();
		var args = Sys.args();
		if( args.length > 1 ) {
			var r0 = roots();
			var r = reload(Sys.programPath()) || reload(Sys.programPath()) || reload(args[1]) || reload(args[1]);
			Sys.println("refused=" + !r + " value=" + value() + " roots=" + (roots() - r0));
		}
		Sys.println("before=" + before + " reloaded=" + reload(args[0]) + " value=" + value() + " refused=" + refused());
		if( args.length > 3 )
			Sys.println("added=" + added3() + added4() + " reloaded=" + reload(args[2]) + " added=" + added3(args[3]) + added4());
		if( args.length > 4 )
			Sys.println("many=" + reload(args[4]) + " " + many() + " added=" + added3() + added4());
		if( args.length > 5 )
			Sys.println("string=" + reload(args[5]) + " added=" + added5(float));
		if( args.length > 6 )
			Sys.println("class=" + reload(args[6]) + " added=" + added6() + " value=" + value());
		if( args.length > 7 )
			Sys.println("some=" + reload(args[7]) + " " + many() + " again=" + reload(args[6]) + " " + many());
	}

}
#end
