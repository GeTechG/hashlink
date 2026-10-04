// hl_from_utf8 returns the number of units it wrote, also when a surrogate pair does not fit at the end of the buffer
#include <hl.h>
#include <stdio.h>

static int check( const char *name, const char *str, int outLen, int expected ) {
	uchar out[8];
	int i, n;
	for(i=0;i<8;i++) out[i] = 0xFFFF;
	n = hl_from_utf8(out,outLen,str);
	if( n == expected && out[n] == 0 && (int)ustrlen(out) == n ) return 0;
	printf("%s: returned %d, should be %d (terminator at %d)\n",name,n,expected,(int)ustrlen(out));
	return 1;
}

int main() {
	const char *s = "a\xF0\x9F\x98\x80" "b"; // a, U+1F600, b : 4 units
	int err = 0;
	err += check("whole string",s,4,4);
	err += check("larger buffer",s,7,4);
	err += check("cut after the pair",s,3,3);
	err += check("pair on the boundary",s,2,1);
	err += check("cut before the pair",s,1,1);
	err += check("empty buffer",s,0,0);
	if( err ) return 1;
	printf("ok\n");
	return 0;
}
