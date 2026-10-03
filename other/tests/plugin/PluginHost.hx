import shared.Base;
import shared.Registry;

/**
	Loads PluginMain as a plugin sharing the `shared` package with this module:
	load -> call a method of the shared type -> unload -> load again,
	with a load whose entry point throws in between.
	An optional second plugin (PluginDeep) is one the JIT refuses to compile.
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
		return id;
	}

	// the entry point throws : the plugin must not stay loaded, nor keep its id
	static function checkFailure( file : String ) {
		Registry.fail = true;
		var err : Dynamic = null;
		try loadPluginId(@:privateAccess file.bytes) catch( e : Dynamic ) err = e;
		Registry.fail = false;
		if( err == null ) throw "plugin failure was not propagated";
		if( Std.string(err).indexOf("plugin failure") < 0 ) throw "unexpected error " + err;
		if( Registry.items.length != 0 ) throw "failed plugin did register";
		hl.Gc.major();
	}

	// the JIT refuses the plugin : the load fails, the host keeps running and can load other plugins
	static function checkRefused( file : String ) {
		if( loadPluginId(@:privateAccess file.bytes) >= 0 ) throw "refused plugin did load";
		if( loadPluginId(@:privateAccess file.bytes) >= 0 ) throw "refused plugin did load";
	}

	static function main() {
		var file = Sys.args()[0];
		var refused = Sys.args()[1];
		var id = check(file);
		checkFailure(file);
		checkFailure(file);
		if( refused != null ) checkRefused(refused);
		if( check(file) != id ) throw "failed plugin kept its id";
		if( new Base(1).twice(1) != 3 ) throw "host method broken";
		Sys.println("OK");
	}
}
