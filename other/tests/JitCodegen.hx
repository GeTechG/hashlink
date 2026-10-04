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

	// a negative index : in registers, with the result in the register of the base, and as a constant
	@:keep static function offsetBack(r:hl.Ref<Int>, i:Int):Int return r.offset(i).get();
	@:keep static function offsetBackKeep(r:hl.Ref<Int>, i:Int):Float {
		var p = r.offset(i);
		nop();
		// the unsigned conversion reads the whole register of `i`
		var u:UInt = i;
		var f:Float = u;
		return f + p.get() + r.get();
	}
	@:keep static function offsetBackConst(r:hl.Ref<Int>):Int return r.offset(-1).get();
	@:keep static function getMemBack(b:hl.Bytes, i:Int):Int return b.getI32(i) + b.getUI8(i) + b.getUI16(i);
	@:keep static function setMemBack(b:hl.Bytes, i:Int, v:Int) {
		b.setI32(i, v);
		b.setUI8(i + 4, v);
		b.setUI16(i + 6, v);
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

		var r = arr.getRef().offset(4);
		check("offset forward", offsetBack(r, 1), 105);
		check("offset back", offsetBack(r, -1), 103);
		check("offset back, on stack", offsetOnStack(1, 2, 3, 4, 5, 6, r, -3), 101 + 21 - 3 + 104);
		if( offsetBackKeep(r, -2) != 102 + 104 + 4294967294. ) throw "offset back, index kept";
		check("offset back, constant", offsetBackConst(r), 103);

		var b = new hl.Bytes(16);
		for( i in 0...16 ) b[i] = i;
		var mid = b.offset(8);
		check("get mem back", getMemBack(mid, -4), 0x07060504 + 4 + 0x0504);
		setMemBack(mid, -8, 0x11223344);
		check("set mem back", b.getI32(0) + b[4] + b.getUI16(6), 0x11223344 + 0x44 + 0x3344);

		check("throw only", catchThrow(10), 10 + 11 + 12);
		trace("ok");
	}
}
