// calls a Dynamic function through a closure typed with Single : the wrapper has to read and return 32 bits floats
class ClosureSingle {

	static function check(name:String, got:Float, expected:Float) {
		if( got != expected ) throw '$name: got $got, expected $expected';
	}

	static function main() {
		var add:Dynamic = function(a:Dynamic, b:Dynamic):Dynamic return (a : Float) + (b : Float);
		var f:Single->Single->Single = add;
		var r:Single = f(1.5, 2.25);
		check("registers", r, 3.75);

		// more float arguments than float registers : the last ones are read from the stack
		var sum:Dynamic = function(a:Dynamic, b:Dynamic, c:Dynamic, d:Dynamic, e:Dynamic, f:Dynamic, g:Dynamic, h:Dynamic, i:Dynamic):Dynamic
			return (a : Float) + (b : Float) + (c : Float) + (d : Float) + (e : Float) + (f : Float) + (g : Float) + (h : Float) + (i : Float);
		var g:Single->Single->Single->Single->Single->Single->Single->Single->Single->Single = sum;
		var r:Single = g(1, 2, 4, 8, 16, 32, 64, 128, 0.5);
		check("stack", r, 255.5);

		var mixed:Dynamic = function(a:Dynamic, b:Dynamic, c:Dynamic):Dynamic return (a : Float) * (b : Int) + (c : Float);
		var h:Single->Int->Float->Single = mixed;
		var r:Single = h(0.5, 3, 0.25);
		check("mixed", r, 1.75);

		var d:Single->Float = function(a:Dynamic):Dynamic return (a : Float) * 2;
		check("double result", d(1.25), 2.5);
		trace("ok");
	}

}
