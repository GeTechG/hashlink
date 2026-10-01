package shared;

class Registry {
	public static var items : Array<Base> = [];
	public static function add( b : Base ) {
		items.push(b);
	}
}
