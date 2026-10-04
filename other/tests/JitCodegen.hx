// code generation cases of the JIT that need a specific shape of bytecode or of register allocation
class JitCodegen {

	static var count = 0;

	static function check(name:String, got:Int, expected:Int) {
		if( got != expected ) throw '$name: got $got, expected $expected';
	}

	@:keep static function odd():Bool return (count++ & 1) != 0;
	@:keep static function nop() count++;

	// the body of the inner `if` is dead and removed, which leaves a conditional jump to the next opcode :
	// both of its edges have to carry `x` to the `return`
	@:keep static function jumpToNext(a:Bool):Int {
		var x = 0;
		if( a ) {
			x = 1;
			if( odd() ) {
				var y = x;
				y = x;
			}
		}
		return x;
	}

	// `r` and `i` are stack arguments and the six others take every register kept across a call,
	// so the base, the index and the result of the offset are all in memory
	@:keep static function offsetOnStack(a:Int, b:Int, c:Int, d:Int, e:Int, f:Int, r:hl.Ref<Int>, i:Int):Int {
		nop();
		var p = r.offset(i);
		nop();
		return p.get() + a + b + c + d + e + f + i + r.get();
	}

	// the only call of the function does not return
	@:keep static function throwOnly(e:Dynamic) {
		throw e;
	}

	@:keep static function catchThrow(v:Int):Int {
		var a = v + 1, b = v + 2;
		try throwOnly(v) catch( e:Dynamic ) return (e : Int) + a + b;
		return -1;
	}

	static function main() {
		check("jump to next, not taken", jumpToNext(true), 1);
		check("jump to next, taken", jumpToNext(true), 1);
		check("jump to next, skipped", jumpToNext(false), 0);

		var arr = new hl.NativeArray<Int>(8);
		for( i in 0...8 ) arr[i] = 100 + i;
		check("offset on stack", offsetOnStack(1, 2, 3, 4, 5, 6, arr.getRef(), 3), 103 + 21 + 3 + 100);

		check("throw only", catchThrow(10), 10 + 11 + 12);
		trace("ok");
	}
}
