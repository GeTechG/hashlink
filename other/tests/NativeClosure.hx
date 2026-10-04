// calls a native function returning a Bool through a closure : C only sets the low byte of the result
class NativeClosure {

	static function main() {
		var fn = Math.isNaN;
		var n = 0;
		for( i in 0...1000 )
			if( fn(i * 1.5) ) n++;
		if( n != 0 || !fn(Math.NaN) )
			throw "native closure Bool result is wrong : " + n + " " + fn(Math.NaN);
		trace("ok");
	}

}
