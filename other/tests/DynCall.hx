// dynamic calls and operators : a missing method, a wrong number of arguments or a null operand is an exception
class DynCall {

	static function throws(name:String, f:Void->Void) {
		try f() catch( e : Dynamic ) return;
		throw '$name: no exception';
	}

	@:hlNative("std", "dyn_op") static function dynOp(op:Int, a:Dynamic, b:Dynamic):Dynamic return null;

	static function ten(a:Int, b:Int, c:Int, d:Int, e:Int, f:Int, g:Int, h:Int, i:Int, j:Int) return a + j;

	static function main() {
		var o:Dynamic = {};
		var s:{function foo():Void;} = o;
		throws("missing method", () -> s.foo());

		var o:Dynamic = {foo: function(a:Int) {}};
		var s:{function foo():Void;} = o;
		throws("wrong arity", () -> s.foo());

		var o:Dynamic = {foo: ten};
		var s:{function foo(a:Float, b:Float, c:Float, d:Float, e:Float, f:Float, g:Float, h:Float, i:Float, j:Float):Float;} = o;
		throws("too many arguments", () -> s.foo(1, 2, 3, 4, 5, 6, 7, 8, 9, 10));

		var n:Dynamic = null, str:Dynamic = "a";
		throws("null - string", () -> dynOp(1, n, str));
		throws("string - null", () -> dynOp(1, str, n));
		trace("ok");
	}
}
