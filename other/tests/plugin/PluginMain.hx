import shared.Base;
import shared.Registry;

class Sub extends Base {
	override function name() : String {
		return "sub" + twice(20);
	}
}

/**
	Plugin side of PluginHost : shared.* is excluded, so the constructor and the methods
	of shared.Base called here have to be redirected to the host module.
**/
class PluginMain {
	static function main() {
		Registry.add(new Sub(2));
	}
}
