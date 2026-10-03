/**
	A plugin the JIT refuses : one function nests more try/catch than it supports.
	PluginHost checks that such a load is refused instead of ending the process.
**/
class PluginDeep {

	static var count = 0;

	static function step() {
		count++;
	}

	static macro function nested( depth : Int ) {
		var e = macro step();
		for( i in 0...depth )
			e = macro try $e catch( e : Dynamic ) step();
		return e;
	}

	static function main() {
		nested(33);
	}
}
