import shared.Base;
import shared.Registry;

class Sub extends Base {
	override function name() : String {
		return "sub" + twice(20);
	}
}

// an exception that cannot be printed
class Unprintable extends haxe.Exception {
	override function toString() : String {
		throw "toString failure";
	}
}

/**
	Plugin side of PluginHost : shared.* is excluded, so the constructor and the methods
	of shared.Base called here have to be redirected to the host module.
**/
class PluginMain {
	static function main() {
		if( Registry.fail ) throw "plugin failure";
		if( Registry.failObject ) throw new Unprintable("unprintable");
		Registry.add(new Sub(2));
	}
}
