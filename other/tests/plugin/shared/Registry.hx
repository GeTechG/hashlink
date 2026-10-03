package shared;

class Registry {
	public static var items : Array<Base> = [];
	public static var fail = false;
	public static var failObject = false;
	public static function add( b : Base ) {
		items.push(b);
	}
}
