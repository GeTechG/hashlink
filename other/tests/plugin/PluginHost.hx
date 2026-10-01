import shared.Base;
import shared.Registry;

/**
	Loads PluginMain as a plugin sharing the `shared` package with this module:
	load -> call a method of the shared type -> unload -> load again.
**/
class PluginHost {

	@:hlNative("?std", "sys_load_plugin_id") static function loadPluginId( file : hl.Bytes ) : Int { return -1; }
	@:hlNative("?std", "sys_unload_plugin") static function unloadPlugin( id : Int ) : Bool { return false; }

	static function check( file : String ) {
		var id = loadPluginId(@:privateAccess file.bytes);
		if( id < 0 ) throw "plugin did not load";
		var b : Base = Registry.items[0];
		if( Registry.items.length != 1 || b == null ) throw "plugin did not register";
		if( b.name() != "sub42" ) throw "unexpected name " + b.name();
		if( b.twice(1) != 4 ) throw "unexpected twice " + b.twice(1);
		b = null;
		Registry.items = [];
		hl.Gc.major();
		if( !unloadPlugin(id) ) throw "plugin did not unload";
	}

	static function main() {
		var file = Sys.args()[0];
		check(file);
		check(file);
		if( new Base(1).twice(1) != 3 ) throw "host method broken";
		Sys.println("OK");
	}
}
