// calls with more than 32 arguments (JIT MAX_TMP_ARGS / stack args), see HaxeFoundation/hashlink#983
// each argument is weighted by its position so a lost, swapped or corrupted one changes the sum
class ManyArgs {

	static function f33(
		a0:Null<Float>, a1:Null<Bool>, a2:Null<Int>, a3:String, a4:Int, a5:Float, a6:Null<Float>, a7:Null<Bool>,
		a8:Null<Int>, a9:String, a10:Int, a11:Float, a12:Null<Float>, a13:Null<Bool>, a14:Null<Int>, a15:String,
		a16:Int, a17:Float, a18:Null<Float>, a19:Null<Bool>, a20:Null<Int>, a21:String, a22:Int, a23:Float,
		a24:Null<Float>, a25:Null<Bool>, a26:Null<Int>, a27:String, a28:Int, a29:Float, a30:Null<Float>, a31:Null<Bool>,
		a32:Null<Int>
	):Float {
		return (a0 == null ? 0 : a0 * 1) + (a1 == null ? 0 : a1 ? 2 : 4) + (a2 == null ? 0 : a2 * 3) + a3.length * 4 +
			a4 * 5 + a5 * 6 + (a6 == null ? 0 : a6 * 7) + (a7 == null ? 0 : a7 ? 8 : 16) +
			(a8 == null ? 0 : a8 * 9) + a9.length * 10 + a10 * 11 + a11 * 12 +
			(a12 == null ? 0 : a12 * 13) + (a13 == null ? 0 : a13 ? 14 : 28) + (a14 == null ? 0 : a14 * 15) + a15.length * 16 +
			a16 * 17 + a17 * 18 + (a18 == null ? 0 : a18 * 19) + (a19 == null ? 0 : a19 ? 20 : 40) +
			(a20 == null ? 0 : a20 * 21) + a21.length * 22 + a22 * 23 + a23 * 24 +
			(a24 == null ? 0 : a24 * 25) + (a25 == null ? 0 : a25 ? 26 : 52) + (a26 == null ? 0 : a26 * 27) + a27.length * 28 +
			a28 * 29 + a29 * 30 + (a30 == null ? 0 : a30 * 31) + (a31 == null ? 0 : a31 ? 32 : 64) +
			(a32 == null ? 0 : a32 * 33);
	}

	static function f64(
		a0:Null<Float>, a1:Null<Bool>, a2:Null<Int>, a3:String, a4:Int, a5:Float, a6:Null<Float>, a7:Null<Bool>,
		a8:Null<Int>, a9:String, a10:Int, a11:Float, a12:Null<Float>, a13:Null<Bool>, a14:Null<Int>, a15:String,
		a16:Int, a17:Float, a18:Null<Float>, a19:Null<Bool>, a20:Null<Int>, a21:String, a22:Int, a23:Float,
		a24:Null<Float>, a25:Null<Bool>, a26:Null<Int>, a27:String, a28:Int, a29:Float, a30:Null<Float>, a31:Null<Bool>,
		a32:Null<Int>, a33:String, a34:Int, a35:Float, a36:Null<Float>, a37:Null<Bool>, a38:Null<Int>, a39:String,
		a40:Int, a41:Float, a42:Null<Float>, a43:Null<Bool>, a44:Null<Int>, a45:String, a46:Int, a47:Float,
		a48:Null<Float>, a49:Null<Bool>, a50:Null<Int>, a51:String, a52:Int, a53:Float, a54:Null<Float>, a55:Null<Bool>,
		a56:Null<Int>, a57:String, a58:Int, a59:Float, a60:Null<Float>, a61:Null<Bool>, a62:Null<Int>, a63:String
	):Float {
		return (a0 == null ? 0 : a0 * 1) + (a1 == null ? 0 : a1 ? 2 : 4) + (a2 == null ? 0 : a2 * 3) + a3.length * 4 +
			a4 * 5 + a5 * 6 + (a6 == null ? 0 : a6 * 7) + (a7 == null ? 0 : a7 ? 8 : 16) +
			(a8 == null ? 0 : a8 * 9) + a9.length * 10 + a10 * 11 + a11 * 12 +
			(a12 == null ? 0 : a12 * 13) + (a13 == null ? 0 : a13 ? 14 : 28) + (a14 == null ? 0 : a14 * 15) + a15.length * 16 +
			a16 * 17 + a17 * 18 + (a18 == null ? 0 : a18 * 19) + (a19 == null ? 0 : a19 ? 20 : 40) +
			(a20 == null ? 0 : a20 * 21) + a21.length * 22 + a22 * 23 + a23 * 24 +
			(a24 == null ? 0 : a24 * 25) + (a25 == null ? 0 : a25 ? 26 : 52) + (a26 == null ? 0 : a26 * 27) + a27.length * 28 +
			a28 * 29 + a29 * 30 + (a30 == null ? 0 : a30 * 31) + (a31 == null ? 0 : a31 ? 32 : 64) +
			(a32 == null ? 0 : a32 * 33) + a33.length * 34 + a34 * 35 + a35 * 36 +
			(a36 == null ? 0 : a36 * 37) + (a37 == null ? 0 : a37 ? 38 : 76) + (a38 == null ? 0 : a38 * 39) + a39.length * 40 +
			a40 * 41 + a41 * 42 + (a42 == null ? 0 : a42 * 43) + (a43 == null ? 0 : a43 ? 44 : 88) +
			(a44 == null ? 0 : a44 * 45) + a45.length * 46 + a46 * 47 + a47 * 48 +
			(a48 == null ? 0 : a48 * 49) + (a49 == null ? 0 : a49 ? 50 : 100) + (a50 == null ? 0 : a50 * 51) + a51.length * 52 +
			a52 * 53 + a53 * 54 + (a54 == null ? 0 : a54 * 55) + (a55 == null ? 0 : a55 ? 56 : 112) +
			(a56 == null ? 0 : a56 * 57) + a57.length * 58 + a58 * 59 + a59 * 60 +
			(a60 == null ? 0 : a60 * 61) + (a61 == null ? 0 : a61 ? 62 : 124) + (a62 == null ? 0 : a62 * 63) + a63.length * 64;
	}

	static function f113(
		a0:Null<Float>, a1:Null<Bool>, a2:Null<Int>, a3:String, a4:Int, a5:Float, a6:Null<Float>, a7:Null<Bool>,
		a8:Null<Int>, a9:String, a10:Int, a11:Float, a12:Null<Float>, a13:Null<Bool>, a14:Null<Int>, a15:String,
		a16:Int, a17:Float, a18:Null<Float>, a19:Null<Bool>, a20:Null<Int>, a21:String, a22:Int, a23:Float,
		a24:Null<Float>, a25:Null<Bool>, a26:Null<Int>, a27:String, a28:Int, a29:Float, a30:Null<Float>, a31:Null<Bool>,
		a32:Null<Int>, a33:String, a34:Int, a35:Float, a36:Null<Float>, a37:Null<Bool>, a38:Null<Int>, a39:String,
		a40:Int, a41:Float, a42:Null<Float>, a43:Null<Bool>, a44:Null<Int>, a45:String, a46:Int, a47:Float,
		a48:Null<Float>, a49:Null<Bool>, a50:Null<Int>, a51:String, a52:Int, a53:Float, a54:Null<Float>, a55:Null<Bool>,
		a56:Null<Int>, a57:String, a58:Int, a59:Float, a60:Null<Float>, a61:Null<Bool>, a62:Null<Int>, a63:String,
		a64:Int, a65:Float, a66:Null<Float>, a67:Null<Bool>, a68:Null<Int>, a69:String, a70:Int, a71:Float,
		a72:Null<Float>, a73:Null<Bool>, a74:Null<Int>, a75:String, a76:Int, a77:Float, a78:Null<Float>, a79:Null<Bool>,
		a80:Null<Int>, a81:String, a82:Int, a83:Float, a84:Null<Float>, a85:Null<Bool>, a86:Null<Int>, a87:String,
		a88:Int, a89:Float, a90:Null<Float>, a91:Null<Bool>, a92:Null<Int>, a93:String, a94:Int, a95:Float,
		a96:Null<Float>, a97:Null<Bool>, a98:Null<Int>, a99:String, a100:Int, a101:Float, a102:Null<Float>, a103:Null<Bool>,
		a104:Null<Int>, a105:String, a106:Int, a107:Float, a108:Null<Float>, a109:Null<Bool>, a110:Null<Int>, a111:String,
		a112:Int
	):Float {
		return (a0 == null ? 0 : a0 * 1) + (a1 == null ? 0 : a1 ? 2 : 4) + (a2 == null ? 0 : a2 * 3) + a3.length * 4 +
			a4 * 5 + a5 * 6 + (a6 == null ? 0 : a6 * 7) + (a7 == null ? 0 : a7 ? 8 : 16) +
			(a8 == null ? 0 : a8 * 9) + a9.length * 10 + a10 * 11 + a11 * 12 +
			(a12 == null ? 0 : a12 * 13) + (a13 == null ? 0 : a13 ? 14 : 28) + (a14 == null ? 0 : a14 * 15) + a15.length * 16 +
			a16 * 17 + a17 * 18 + (a18 == null ? 0 : a18 * 19) + (a19 == null ? 0 : a19 ? 20 : 40) +
			(a20 == null ? 0 : a20 * 21) + a21.length * 22 + a22 * 23 + a23 * 24 +
			(a24 == null ? 0 : a24 * 25) + (a25 == null ? 0 : a25 ? 26 : 52) + (a26 == null ? 0 : a26 * 27) + a27.length * 28 +
			a28 * 29 + a29 * 30 + (a30 == null ? 0 : a30 * 31) + (a31 == null ? 0 : a31 ? 32 : 64) +
			(a32 == null ? 0 : a32 * 33) + a33.length * 34 + a34 * 35 + a35 * 36 +
			(a36 == null ? 0 : a36 * 37) + (a37 == null ? 0 : a37 ? 38 : 76) + (a38 == null ? 0 : a38 * 39) + a39.length * 40 +
			a40 * 41 + a41 * 42 + (a42 == null ? 0 : a42 * 43) + (a43 == null ? 0 : a43 ? 44 : 88) +
			(a44 == null ? 0 : a44 * 45) + a45.length * 46 + a46 * 47 + a47 * 48 +
			(a48 == null ? 0 : a48 * 49) + (a49 == null ? 0 : a49 ? 50 : 100) + (a50 == null ? 0 : a50 * 51) + a51.length * 52 +
			a52 * 53 + a53 * 54 + (a54 == null ? 0 : a54 * 55) + (a55 == null ? 0 : a55 ? 56 : 112) +
			(a56 == null ? 0 : a56 * 57) + a57.length * 58 + a58 * 59 + a59 * 60 +
			(a60 == null ? 0 : a60 * 61) + (a61 == null ? 0 : a61 ? 62 : 124) + (a62 == null ? 0 : a62 * 63) + a63.length * 64 +
			a64 * 65 + a65 * 66 + (a66 == null ? 0 : a66 * 67) + (a67 == null ? 0 : a67 ? 68 : 136) +
			(a68 == null ? 0 : a68 * 69) + a69.length * 70 + a70 * 71 + a71 * 72 +
			(a72 == null ? 0 : a72 * 73) + (a73 == null ? 0 : a73 ? 74 : 148) + (a74 == null ? 0 : a74 * 75) + a75.length * 76 +
			a76 * 77 + a77 * 78 + (a78 == null ? 0 : a78 * 79) + (a79 == null ? 0 : a79 ? 80 : 160) +
			(a80 == null ? 0 : a80 * 81) + a81.length * 82 + a82 * 83 + a83 * 84 +
			(a84 == null ? 0 : a84 * 85) + (a85 == null ? 0 : a85 ? 86 : 172) + (a86 == null ? 0 : a86 * 87) + a87.length * 88 +
			a88 * 89 + a89 * 90 + (a90 == null ? 0 : a90 * 91) + (a91 == null ? 0 : a91 ? 92 : 184) +
			(a92 == null ? 0 : a92 * 93) + a93.length * 94 + a94 * 95 + a95 * 96 +
			(a96 == null ? 0 : a96 * 97) + (a97 == null ? 0 : a97 ? 98 : 196) + (a98 == null ? 0 : a98 * 99) + a99.length * 100 +
			a100 * 101 + a101 * 102 + (a102 == null ? 0 : a102 * 103) + (a103 == null ? 0 : a103 ? 104 : 208) +
			(a104 == null ? 0 : a104 * 105) + a105.length * 106 + a106 * 107 + a107 * 108 +
			(a108 == null ? 0 : a108 * 109) + (a109 == null ? 0 : a109 ? 110 : 220) + (a110 == null ? 0 : a110 * 111) + a111.length * 112 +
			a112 * 113;
	}

	var sum:Float;

	function new(
		a0:Null<Float>, a1:Null<Bool>, a2:Null<Int>, a3:String, a4:Int, a5:Float, a6:Null<Float>, a7:Null<Bool>,
		a8:Null<Int>, a9:String, a10:Int, a11:Float, a12:Null<Float>, a13:Null<Bool>, a14:Null<Int>, a15:String,
		a16:Int, a17:Float, a18:Null<Float>, a19:Null<Bool>, a20:Null<Int>, a21:String, a22:Int, a23:Float,
		a24:Null<Float>, a25:Null<Bool>, a26:Null<Int>, a27:String, a28:Int, a29:Float, a30:Null<Float>, a31:Null<Bool>,
		a32:Null<Int>, a33:String, a34:Int, a35:Float, a36:Null<Float>, a37:Null<Bool>, a38:Null<Int>, a39:String,
		a40:Int, a41:Float, a42:Null<Float>, a43:Null<Bool>, a44:Null<Int>, a45:String, a46:Int, a47:Float,
		a48:Null<Float>, a49:Null<Bool>, a50:Null<Int>, a51:String, a52:Int, a53:Float, a54:Null<Float>, a55:Null<Bool>,
		a56:Null<Int>, a57:String, a58:Int, a59:Float, a60:Null<Float>, a61:Null<Bool>, a62:Null<Int>, a63:String,
		a64:Int, a65:Float, a66:Null<Float>, a67:Null<Bool>, a68:Null<Int>, a69:String, a70:Int, a71:Float,
		a72:Null<Float>, a73:Null<Bool>, a74:Null<Int>, a75:String, a76:Int, a77:Float, a78:Null<Float>, a79:Null<Bool>,
		a80:Null<Int>, a81:String, a82:Int, a83:Float, a84:Null<Float>, a85:Null<Bool>, a86:Null<Int>, a87:String,
		a88:Int, a89:Float, a90:Null<Float>, a91:Null<Bool>, a92:Null<Int>, a93:String, a94:Int, a95:Float,
		a96:Null<Float>, a97:Null<Bool>, a98:Null<Int>, a99:String, a100:Int, a101:Float, a102:Null<Float>, a103:Null<Bool>,
		a104:Null<Int>, a105:String, a106:Int, a107:Float, a108:Null<Float>, a109:Null<Bool>, a110:Null<Int>, a111:String,
		a112:Int
	) {
		sum = (a0 == null ? 0 : a0 * 1) + (a1 == null ? 0 : a1 ? 2 : 4) + (a2 == null ? 0 : a2 * 3) + a3.length * 4 +
			a4 * 5 + a5 * 6 + (a6 == null ? 0 : a6 * 7) + (a7 == null ? 0 : a7 ? 8 : 16) +
			(a8 == null ? 0 : a8 * 9) + a9.length * 10 + a10 * 11 + a11 * 12 +
			(a12 == null ? 0 : a12 * 13) + (a13 == null ? 0 : a13 ? 14 : 28) + (a14 == null ? 0 : a14 * 15) + a15.length * 16 +
			a16 * 17 + a17 * 18 + (a18 == null ? 0 : a18 * 19) + (a19 == null ? 0 : a19 ? 20 : 40) +
			(a20 == null ? 0 : a20 * 21) + a21.length * 22 + a22 * 23 + a23 * 24 +
			(a24 == null ? 0 : a24 * 25) + (a25 == null ? 0 : a25 ? 26 : 52) + (a26 == null ? 0 : a26 * 27) + a27.length * 28 +
			a28 * 29 + a29 * 30 + (a30 == null ? 0 : a30 * 31) + (a31 == null ? 0 : a31 ? 32 : 64) +
			(a32 == null ? 0 : a32 * 33) + a33.length * 34 + a34 * 35 + a35 * 36 +
			(a36 == null ? 0 : a36 * 37) + (a37 == null ? 0 : a37 ? 38 : 76) + (a38 == null ? 0 : a38 * 39) + a39.length * 40 +
			a40 * 41 + a41 * 42 + (a42 == null ? 0 : a42 * 43) + (a43 == null ? 0 : a43 ? 44 : 88) +
			(a44 == null ? 0 : a44 * 45) + a45.length * 46 + a46 * 47 + a47 * 48 +
			(a48 == null ? 0 : a48 * 49) + (a49 == null ? 0 : a49 ? 50 : 100) + (a50 == null ? 0 : a50 * 51) + a51.length * 52 +
			a52 * 53 + a53 * 54 + (a54 == null ? 0 : a54 * 55) + (a55 == null ? 0 : a55 ? 56 : 112) +
			(a56 == null ? 0 : a56 * 57) + a57.length * 58 + a58 * 59 + a59 * 60 +
			(a60 == null ? 0 : a60 * 61) + (a61 == null ? 0 : a61 ? 62 : 124) + (a62 == null ? 0 : a62 * 63) + a63.length * 64 +
			a64 * 65 + a65 * 66 + (a66 == null ? 0 : a66 * 67) + (a67 == null ? 0 : a67 ? 68 : 136) +
			(a68 == null ? 0 : a68 * 69) + a69.length * 70 + a70 * 71 + a71 * 72 +
			(a72 == null ? 0 : a72 * 73) + (a73 == null ? 0 : a73 ? 74 : 148) + (a74 == null ? 0 : a74 * 75) + a75.length * 76 +
			a76 * 77 + a77 * 78 + (a78 == null ? 0 : a78 * 79) + (a79 == null ? 0 : a79 ? 80 : 160) +
			(a80 == null ? 0 : a80 * 81) + a81.length * 82 + a82 * 83 + a83 * 84 +
			(a84 == null ? 0 : a84 * 85) + (a85 == null ? 0 : a85 ? 86 : 172) + (a86 == null ? 0 : a86 * 87) + a87.length * 88 +
			a88 * 89 + a89 * 90 + (a90 == null ? 0 : a90 * 91) + (a91 == null ? 0 : a91 ? 92 : 184) +
			(a92 == null ? 0 : a92 * 93) + a93.length * 94 + a94 * 95 + a95 * 96 +
			(a96 == null ? 0 : a96 * 97) + (a97 == null ? 0 : a97 ? 98 : 196) + (a98 == null ? 0 : a98 * 99) + a99.length * 100 +
			a100 * 101 + a101 * 102 + (a102 == null ? 0 : a102 * 103) + (a103 == null ? 0 : a103 ? 104 : 208) +
			(a104 == null ? 0 : a104 * 105) + a105.length * 106 + a106 * 107 + a107 * 108 +
			(a108 == null ? 0 : a108 * 109) + (a109 == null ? 0 : a109 ? 110 : 220) + (a110 == null ? 0 : a110 * 111) + a111.length * 112 +
			a112 * 113;
	}

	static function f130(
		a0:Null<Float>, a1:Null<Bool>, a2:Null<Int>, a3:String, a4:Int, a5:Float, a6:Null<Float>, a7:Null<Bool>,
		a8:Null<Int>, a9:String, a10:Int, a11:Float, a12:Null<Float>, a13:Null<Bool>, a14:Null<Int>, a15:String,
		a16:Int, a17:Float, a18:Null<Float>, a19:Null<Bool>, a20:Null<Int>, a21:String, a22:Int, a23:Float,
		a24:Null<Float>, a25:Null<Bool>, a26:Null<Int>, a27:String, a28:Int, a29:Float, a30:Null<Float>, a31:Null<Bool>,
		a32:Null<Int>, a33:String, a34:Int, a35:Float, a36:Null<Float>, a37:Null<Bool>, a38:Null<Int>, a39:String,
		a40:Int, a41:Float, a42:Null<Float>, a43:Null<Bool>, a44:Null<Int>, a45:String, a46:Int, a47:Float,
		a48:Null<Float>, a49:Null<Bool>, a50:Null<Int>, a51:String, a52:Int, a53:Float, a54:Null<Float>, a55:Null<Bool>,
		a56:Null<Int>, a57:String, a58:Int, a59:Float, a60:Null<Float>, a61:Null<Bool>, a62:Null<Int>, a63:String,
		a64:Int, a65:Float, a66:Null<Float>, a67:Null<Bool>, a68:Null<Int>, a69:String, a70:Int, a71:Float,
		a72:Null<Float>, a73:Null<Bool>, a74:Null<Int>, a75:String, a76:Int, a77:Float, a78:Null<Float>, a79:Null<Bool>,
		a80:Null<Int>, a81:String, a82:Int, a83:Float, a84:Null<Float>, a85:Null<Bool>, a86:Null<Int>, a87:String,
		a88:Int, a89:Float, a90:Null<Float>, a91:Null<Bool>, a92:Null<Int>, a93:String, a94:Int, a95:Float,
		a96:Null<Float>, a97:Null<Bool>, a98:Null<Int>, a99:String, a100:Int, a101:Float, a102:Null<Float>, a103:Null<Bool>,
		a104:Null<Int>, a105:String, a106:Int, a107:Float, a108:Null<Float>, a109:Null<Bool>, a110:Null<Int>, a111:String,
		a112:Int, a113:Float, a114:Null<Float>, a115:Null<Bool>, a116:Null<Int>, a117:String, a118:Int, a119:Float,
		a120:Null<Float>, a121:Null<Bool>, a122:Null<Int>, a123:String, a124:Int, a125:Float, a126:Null<Float>, a127:Null<Bool>,
		a128:Null<Int>, a129:String
	):Float {
		return (a0 == null ? 0 : a0 * 1) + (a1 == null ? 0 : a1 ? 2 : 4) + (a2 == null ? 0 : a2 * 3) + a3.length * 4 +
			a4 * 5 + a5 * 6 + (a6 == null ? 0 : a6 * 7) + (a7 == null ? 0 : a7 ? 8 : 16) +
			(a8 == null ? 0 : a8 * 9) + a9.length * 10 + a10 * 11 + a11 * 12 +
			(a12 == null ? 0 : a12 * 13) + (a13 == null ? 0 : a13 ? 14 : 28) + (a14 == null ? 0 : a14 * 15) + a15.length * 16 +
			a16 * 17 + a17 * 18 + (a18 == null ? 0 : a18 * 19) + (a19 == null ? 0 : a19 ? 20 : 40) +
			(a20 == null ? 0 : a20 * 21) + a21.length * 22 + a22 * 23 + a23 * 24 +
			(a24 == null ? 0 : a24 * 25) + (a25 == null ? 0 : a25 ? 26 : 52) + (a26 == null ? 0 : a26 * 27) + a27.length * 28 +
			a28 * 29 + a29 * 30 + (a30 == null ? 0 : a30 * 31) + (a31 == null ? 0 : a31 ? 32 : 64) +
			(a32 == null ? 0 : a32 * 33) + a33.length * 34 + a34 * 35 + a35 * 36 +
			(a36 == null ? 0 : a36 * 37) + (a37 == null ? 0 : a37 ? 38 : 76) + (a38 == null ? 0 : a38 * 39) + a39.length * 40 +
			a40 * 41 + a41 * 42 + (a42 == null ? 0 : a42 * 43) + (a43 == null ? 0 : a43 ? 44 : 88) +
			(a44 == null ? 0 : a44 * 45) + a45.length * 46 + a46 * 47 + a47 * 48 +
			(a48 == null ? 0 : a48 * 49) + (a49 == null ? 0 : a49 ? 50 : 100) + (a50 == null ? 0 : a50 * 51) + a51.length * 52 +
			a52 * 53 + a53 * 54 + (a54 == null ? 0 : a54 * 55) + (a55 == null ? 0 : a55 ? 56 : 112) +
			(a56 == null ? 0 : a56 * 57) + a57.length * 58 + a58 * 59 + a59 * 60 +
			(a60 == null ? 0 : a60 * 61) + (a61 == null ? 0 : a61 ? 62 : 124) + (a62 == null ? 0 : a62 * 63) + a63.length * 64 +
			a64 * 65 + a65 * 66 + (a66 == null ? 0 : a66 * 67) + (a67 == null ? 0 : a67 ? 68 : 136) +
			(a68 == null ? 0 : a68 * 69) + a69.length * 70 + a70 * 71 + a71 * 72 +
			(a72 == null ? 0 : a72 * 73) + (a73 == null ? 0 : a73 ? 74 : 148) + (a74 == null ? 0 : a74 * 75) + a75.length * 76 +
			a76 * 77 + a77 * 78 + (a78 == null ? 0 : a78 * 79) + (a79 == null ? 0 : a79 ? 80 : 160) +
			(a80 == null ? 0 : a80 * 81) + a81.length * 82 + a82 * 83 + a83 * 84 +
			(a84 == null ? 0 : a84 * 85) + (a85 == null ? 0 : a85 ? 86 : 172) + (a86 == null ? 0 : a86 * 87) + a87.length * 88 +
			a88 * 89 + a89 * 90 + (a90 == null ? 0 : a90 * 91) + (a91 == null ? 0 : a91 ? 92 : 184) +
			(a92 == null ? 0 : a92 * 93) + a93.length * 94 + a94 * 95 + a95 * 96 +
			(a96 == null ? 0 : a96 * 97) + (a97 == null ? 0 : a97 ? 98 : 196) + (a98 == null ? 0 : a98 * 99) + a99.length * 100 +
			a100 * 101 + a101 * 102 + (a102 == null ? 0 : a102 * 103) + (a103 == null ? 0 : a103 ? 104 : 208) +
			(a104 == null ? 0 : a104 * 105) + a105.length * 106 + a106 * 107 + a107 * 108 +
			(a108 == null ? 0 : a108 * 109) + (a109 == null ? 0 : a109 ? 110 : 220) + (a110 == null ? 0 : a110 * 111) + a111.length * 112 +
			a112 * 113 + a113 * 114 + (a114 == null ? 0 : a114 * 115) + (a115 == null ? 0 : a115 ? 116 : 232) +
			(a116 == null ? 0 : a116 * 117) + a117.length * 118 + a118 * 119 + a119 * 120 +
			(a120 == null ? 0 : a120 * 121) + (a121 == null ? 0 : a121 ? 122 : 244) + (a122 == null ? 0 : a122 * 123) + a123.length * 124 +
			a124 * 125 + a125 * 126 + (a126 == null ? 0 : a126 * 127) + (a127 == null ? 0 : a127 ? 128 : 256) +
			(a128 == null ? 0 : a128 * 129) + a129.length * 130;
	}

	static function check(n:Int, got:Float, expected:Float) {
		if( got != expected ) throw 'f$n: got $got, expected $expected';
	}

	static function main() {
		check(33, f33(
			0.5, true, 6, "s3", 4, 5.25, 6.5, false,
			24, "s9", 10, 11.25, 12.5, true, 42, "s15",
			16, 17.25, 18.5, false, 60, "s21", 22, 23.25,
			null, true, 78, "s27", 28, 29.25, 30.5, null,
			96
		), 12860.0);
		check(64, f64(
			0.5, true, 6, "s3", 4, 5.25, 6.5, false,
			24, "s9", 10, 11.25, 12.5, true, 42, "s15",
			16, 17.25, 18.5, false, 60, "s21", 22, 23.25,
			null, true, 78, "s27", 28, 29.25, 30.5, null,
			96, "s33", 34, 35.25, 36.5, true, null, "s39",
			40, 41.25, 42.5, false, 132, "s45", 46, 47.25,
			48.5, true, 150, "s51", 52, 53.25, 54.5, false,
			168, "s57", 58, 59.25, 60.5, true, 186, "s63"
		), 84088.5);
		check(113, f113(
			0.5, true, 6, "s3", 4, 5.25, 6.5, false,
			24, "s9", 10, 11.25, 12.5, true, 42, "s15",
			16, 17.25, 18.5, false, 60, "s21", 22, 23.25,
			null, true, 78, "s27", 28, 29.25, 30.5, null,
			96, "s33", 34, 35.25, 36.5, true, null, "s39",
			40, 41.25, 42.5, false, 132, "s45", 46, 47.25,
			48.5, true, 150, "s51", 52, 53.25, 54.5, false,
			168, "s57", 58, 59.25, 60.5, true, 186, "s63",
			64, 65.25, null, false, 204, "s69", 70, 71.25,
			72.5, null, 222, "s75", 76, 77.25, 78.5, false,
			null, "s81", 82, 83.25, 84.5, true, 258, "s87",
			88, 89.25, 90.5, false, 276, "s93", 94, 95.25,
			96.5, true, 294, "s99", 100, 101.25, 102.5, false,
			312, "s105", 106, 107.25, null, true, 330, "s111",
			112
		), 445828.5);
		check(113, new ManyArgs(
			0.5, true, 6, "s3", 4, 5.25, 6.5, false,
			24, "s9", 10, 11.25, 12.5, true, 42, "s15",
			16, 17.25, 18.5, false, 60, "s21", 22, 23.25,
			null, true, 78, "s27", 28, 29.25, 30.5, null,
			96, "s33", 34, 35.25, 36.5, true, null, "s39",
			40, 41.25, 42.5, false, 132, "s45", 46, 47.25,
			48.5, true, 150, "s51", 52, 53.25, 54.5, false,
			168, "s57", 58, 59.25, 60.5, true, 186, "s63",
			64, 65.25, null, false, 204, "s69", 70, 71.25,
			72.5, null, 222, "s75", 76, 77.25, 78.5, false,
			null, "s81", 82, 83.25, 84.5, true, 258, "s87",
			88, 89.25, 90.5, false, 276, "s93", 94, 95.25,
			96.5, true, 294, "s99", 100, 101.25, 102.5, false,
			312, "s105", 106, 107.25, null, true, 330, "s111",
			112
		).sum, 445828.5);
		check(130, f130(
			0.5, true, 6, "s3", 4, 5.25, 6.5, false,
			24, "s9", 10, 11.25, 12.5, true, 42, "s15",
			16, 17.25, 18.5, false, 60, "s21", 22, 23.25,
			null, true, 78, "s27", 28, 29.25, 30.5, null,
			96, "s33", 34, 35.25, 36.5, true, null, "s39",
			40, 41.25, 42.5, false, 132, "s45", 46, 47.25,
			48.5, true, 150, "s51", 52, 53.25, 54.5, false,
			168, "s57", 58, 59.25, 60.5, true, 186, "s63",
			64, 65.25, null, false, 204, "s69", 70, 71.25,
			72.5, null, 222, "s75", 76, 77.25, 78.5, false,
			null, "s81", 82, 83.25, 84.5, true, 258, "s87",
			88, 89.25, 90.5, false, 276, "s93", 94, 95.25,
			96.5, true, 294, "s99", 100, 101.25, 102.5, false,
			312, "s105", 106, 107.25, null, true, 330, "s111",
			112, 113.25, 114.5, null, 348, "s117", 118, 119.25,
			120.5, true, null, "s123", 124, 125.25, 126.5, false,
			384, "s129"
		), 654304.0);
		trace("ok");
	}
}
