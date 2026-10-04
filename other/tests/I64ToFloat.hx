// conversion of a 64 bits integer to a float : the JIT has to read the whole source, not its low 32 bits
class I64ToFloat {

	static function check(name:String, got:Float, expected:Float) {
		if( got != expected ) throw '$name: got $got, expected $expected';
	}

	// not inlined, so that the conversion is done on a value the compiler does not know
	@:keep static function toF64(v:hl.I64):Float return cast v;
	@:keep static function toF32(v:hl.I64):Single return cast v;

	static function main() {
		var one:hl.I64 = 1;
		var big = one << 40;
		check("f64", toF64(big), 1099511627776.);
		check("f64 high and low", toF64(big + 5), 1099511627781.);
		check("f64 negative", toF64(-big), -1099511627776.);
		check("f64 small negative", toF64(-one), -1.);
		check("f32", toF32(big), 1099511627776.);
		check("f32 negative", toF32(-big), -1099511627776.);
		trace("ok");
	}
}
