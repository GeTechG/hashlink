// hot reload (hl --hot-reload + sys_check_reload) : the module is patched with the same program built with -D v2
// value() is recompiled and has to call base()/Counter that stay in the first module, through calls and closures
class Counter {
	public var n : Int;
	public function new( n : Int ) {
		this.n = n;
	}
	public function get() : Int {
		return n;
	}
}

class Reload {

	static var counter = new Counter(100);

	static function base() : Int {
		return 40;
	}

	static function call( f : Void -> Int ) : Int {
		return f();
	}

	static function value() : Int {
		return base() + call(base) + call(counter.get) + #if v2 2 #else 1 #end;
	}

	@:hlNative("std","sys_check_reload") static function checkReload( ?alt : hl.Bytes ) : Bool {
		return false;
	}

	static function main() {
		var before = value();
		// the file time has a one second precision and has to differ from the running file one
		Sys.sleep(1.1);
		var tmp = Sys.programPath() + ".reload";
		sys.io.File.copy(Sys.args()[0], tmp);
		var r = checkReload(Sys.systemName() == "Windows" ? @:privateAccess tmp.bytes : @:privateAccess tmp.toUtf8());
		sys.FileSystem.deleteFile(tmp);
		Sys.println("before=" + before + " reloaded=" + r + " value=" + value());
	}

}
