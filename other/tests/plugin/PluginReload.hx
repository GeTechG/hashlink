import shared.Registry;

/**
	Hot reload (hl --hot-reload) while a plugin (PluginMain) is loaded : the patch is this program built with -D v2,
	which only changes value(), so it has no entry point of its own. The entry point that is called again
	has to be the one of the program, not the one of the plugin, which would allocate its core types again.
**/
class PluginReload {

	@:hlNative("?std", "sys_load_plugin_id") static function loadPluginId( file : hl.Bytes ) : Int { return -1; }
	@:hlNative("std", "sys_check_reload") static function checkReload( ?alt : hl.Bytes ) : Bool { return false; }

	static function value() : Int {
		return #if v2 2 #else 1 #end;
	}

	static function main() {
		var args = Sys.args();
		if( loadPluginId(@:privateAccess args[0].bytes) < 0 ) throw "plugin did not load";
		var b = Registry.items[0];
		if( Registry.items.length != 1 || b.name() != "sub42" ) throw "plugin did not register";
		var before = value();
		// the file time has a one second precision and has to differ from the one of the program
		Sys.sleep(1.1);
		var tmp = Sys.programPath() + ".reload";
		sys.io.File.copy(args[1], tmp);
		var r = checkReload(Sys.systemName() == "Windows" ? @:privateAccess tmp.bytes : @:privateAccess tmp.toUtf8());
		sys.FileSystem.deleteFile(tmp);
		if( !r || before != 1 || value() != 2 ) throw "patch was not applied";
		if( Registry.items.length != 1 || b.name() != "sub42" ) throw "plugin entry point was called again : " + b.name();
		Sys.println("OK");
	}
}
