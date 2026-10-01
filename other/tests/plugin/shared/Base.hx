package shared;

class Base {
	public var seed : Int;
	public function new( seed : Int ) {
		this.seed = seed;
	}
	public function name() : String {
		return "base";
	}
	public function twice( v : Int ) : Int {
		return v * 2 + seed;
	}
}
