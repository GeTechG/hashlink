typedef OpusFile = hl.Abstract<"fmt_opus">;

/**
	Decodes Ogg Opus with fmt.hdll. Argument: the directory of the test clips (other/tests/opus).
	Each clip `<name>.opus` has its reference PCM in `<name>.s16`: `opusdec --no-dither`, raw signed 16-bit.
**/
class OpusTest {

	static inline var I16 = 2;
	static inline var F32 = 3;
	static inline var SAMPLES = 12000;
	// op_read dithers its 16-bit output, opusdec --no-dither does not
	static inline var TOLERANCE_I16 = 16;
	static inline var TOLERANCE_F32 = 1.5 / 32768;
	// after a seek the decoder state converges during the pre-roll, it is not bit-exact
	static inline var TOLERANCE_SEEK_RMS = 64. / 32768;

	@:hlNative("fmt", "opus_open") static function open( bytes : hl.Bytes, size : Int ) : OpusFile { return null; }
	@:hlNative("fmt", "opus_info") static function info( o : OpusFile, bitrate : hl.Ref<Int>, freq : hl.Ref<Int>, samples : hl.Ref<Int>, channels : hl.Ref<Int> ) : Void {}
	@:hlNative("fmt", "opus_tell") static function tell( o : OpusFile ) : Int { return 0; }
	@:hlNative("fmt", "opus_seek") static function seek( o : OpusFile, sample : Int ) : Bool { return false; }
	@:hlNative("fmt", "opus_read") static function read( o : OpusFile, out : hl.Bytes, size : Int, format : Int ) : Int { return 0; }

	static var failed = 0;

	static function check( name : String, ok : Bool, ?detail : String ) {
		Sys.println((ok ? "ok " : "FAILED ") + name + (detail == null ? "" : ": " + detail));
		if( !ok ) failed++;
	}

	static function openBytes( b : haxe.io.Bytes ) {
		return open(b, b.length);
	}

	/** Reads to the end in chunks; `null` if a chunk is not whole frames. Stops on 100 errors in a row. **/
	static function readAll( o : OpusFile, format : Int, frame : Int ) {
		var out = new haxe.io.BytesBuffer();
		var chunk = haxe.io.Bytes.alloc(4000);
		var errors = 0;
		while( errors < 100 ) {
			var n = read(o, chunk, chunk.length, format);
			if( n == 0 ) break;
			if( n < 0 ) {
				errors++;
				continue;
			}
			errors = 0;
			if( n > chunk.length || n % frame != 0 ) return null;
			out.addBytes(chunk, 0, n);
		}
		return out.getBytes();
	}

	static function refSample( ref : haxe.io.Bytes, i : Int ) {
		var v = ref.getUInt16(i << 1);
		return v >= 0x8000 ? v - 0x10000 : v;
	}

	/** Largest difference to the reference from value `start` on, as a fraction of full scale. **/
	static function maxDiff( pcm : haxe.io.Bytes, format : Int, ref : haxe.io.Bytes, start : Int ) {
		var diff = 0.;
		var count = format == I16 ? pcm.length >> 1 : pcm.length >> 2;
		for( i in 0...count ) {
			var r = refSample(ref, start + i) / 32768;
			var v = if( format == I16 ) {
				var s = pcm.getUInt16(i << 1);
				(s >= 0x8000 ? s - 0x10000 : s) / 32768;
			} else pcm.getFloat(i << 2);
			var d = Math.abs(v - r);
			if( d > diff ) diff = d;
		}
		return diff;
	}

	/** RMS difference of float PCM to the reference shifted by `shift` frames, from frame `start` on. **/
	static function rmsDiff( pcm : haxe.io.Bytes, ref : haxe.io.Bytes, channels : Int, start : Int, shift : Int ) {
		var sum = 0., count = 0;
		var frames = Std.int((pcm.length >> 2) / channels);
		for( f in 2...frames - 2 )
			for( c in 0...channels ) {
				var d = pcm.getFloat((f * channels + c) << 2) - refSample(ref, (start + f + shift) * channels + c) / 32768;
				sum += d * d;
				count++;
			}
		return Math.sqrt(sum / count);
	}

	static function testClip( dir : String, name : String, channels : Int ) {
		var data = sys.io.File.getBytes(dir + "/" + name + ".opus");
		var ref = sys.io.File.getBytes(dir + "/" + name + ".s16");
		var o = openBytes(data);
		check(name + " open", o != null);
		if( o == null ) return;

		var bitrate = 0, freq = 0, samples = 0, chans = 0;
		info(o, bitrate, freq, samples, chans);
		check(name + " info", freq == 48000 && samples == SAMPLES && chans == channels && bitrate > 0,
			'$freq Hz, $samples samples, $chans channels, $bitrate bit/s');

		var pcm = readAll(o, I16, channels * 2);
		check(name + " s16 length", pcm != null && pcm.length == SAMPLES * channels * 2, pcm == null ? "partial frame" : "" + pcm.length);
		check(name + " s16 end", tell(o) == SAMPLES, "" + tell(o));
		if( pcm != null && pcm.length == ref.length ) {
			var d = maxDiff(pcm, I16, ref, 0);
			check(name + " s16 matches opusdec", d <= TOLERANCE_I16 / 32768, "" + Math.round(d * 32768) + " LSB");
		}

		check(name + " seek 0", seek(o, 0) && tell(o) == 0);
		pcm = readAll(o, F32, channels * 4);
		check(name + " f32 length", pcm != null && pcm.length == SAMPLES * channels * 4, pcm == null ? "partial frame" : "" + pcm.length);
		if( pcm != null && pcm.length == ref.length * 2 ) {
			var d = maxDiff(pcm, F32, ref, 0);
			check(name + " f32 matches opusdec", d <= TOLERANCE_F32, "" + (d * 32768) + " LSB");
		}

		check(name + " seek 6000", seek(o, 6000) && tell(o) == 6000, "" + tell(o));
		pcm = readAll(o, F32, channels * 4);
		check(name + " seek length", pcm != null && pcm.length == (SAMPLES - 6000) * channels * 4, pcm == null ? "partial frame" : "" + pcm.length);
		if( pcm != null && pcm.length == (SAMPLES - 6000) * channels * 4 ) {
			// a seek one sample off would match the reference shifted by one better
			var d = rmsDiff(pcm, ref, channels, 6000, 0);
			var early = rmsDiff(pcm, ref, channels, 6000, -1), late = rmsDiff(pcm, ref, channels, 6000, 1);
			check(name + " seek matches opusdec", d <= TOLERANCE_SEEK_RMS && d * 4 < early && d * 4 < late,
				"rms " + (d * 32768) + " LSB, shifted " + (early * 32768) + " / " + (late * 32768));
		}

		check(name + " bad format", read(o, haxe.io.Bytes.alloc(64), 64, 1) == -1);
	}

	static function main() {
		var dir = Sys.args()[0];
		if( dir == null ) dir = "other/tests/opus";

		testClip(dir, "mono", 1);
		testClip(dir, "stereo", 2);

		var data = sys.io.File.getBytes(dir + "/stereo.opus");

		var garbage = haxe.io.Bytes.alloc(4096);
		for( i in 0...garbage.length ) garbage.set(i, (i * 7919) & 0xFF);
		check("garbage refused", openBytes(garbage) == null);
		check("empty refused", openBytes(haxe.io.Bytes.alloc(0)) == null);
		check("headers cut refused", openBytes(data.sub(0, 40)) == null);

		// cut after the headers, in the middle of the audio pages (the clips have a page every 40 ms)
		var o = openBytes(data.sub(0, data.length >> 1));
		var pcm = o == null ? null : readAll(o, F32, 8);
		check("cut stream decodes", pcm != null && pcm.length > 0 && pcm.length < SAMPLES * 8, pcm == null ? "null" : "" + pcm.length);

		// bytes overwritten in the middle of the audio
		var damaged = data.sub(0, data.length);
		for( i in (data.length >> 1)...(data.length >> 1) + 200 ) damaged.set(i, 0x55);
		o = openBytes(damaged);
		pcm = o == null ? null : readAll(o, I16, 4);
		check("damaged stream decodes", pcm != null && pcm.length > 0 && pcm.length <= SAMPLES * 4, pcm == null ? "null" : "" + pcm.length);

		// the stream keeps its own copy of the bytes
		var copy = data.sub(0, data.length);
		o = openBytes(copy);
		copy.fill(0, copy.length, 0);
		pcm = o == null ? null : readAll(o, I16, 4);
		check("bytes copied", pcm != null && pcm.length == SAMPLES * 4, pcm == null ? "null" : "" + pcm.length);

		if( failed > 0 ) {
			Sys.println(failed + " failed");
			Sys.exit(1);
		}
		Sys.println("all ok");
	}
}
