#define HL_NAME(n) harfbuzz_##n

#include <hl.h>
#include <stdlib.h>
#include <string.h>
#include <hb.h>

typedef struct _hbface hbface;
typedef struct _hbfont hbfont;
typedef struct _hbbuffer hbbuffer;

struct _hbface {
	void (*finalize)( hbface * );
	hb_face_t *face;
};

struct _hbfont {
	void (*finalize)( hbfont * );
	hb_font_t *font;
};

struct _hbbuffer {
	void (*finalize)( hbbuffer * );
	hb_buffer_t *buf;
};

// int32 values per glyph returned by buffer_get_glyphs
#define GLYPH_STRIDE 6

static void face_finalize( hbface *f ) {
	hb_face_destroy(f->face);
	f->face = NULL;
}

static void font_finalize( hbfont *f ) {
	hb_font_destroy(f->font);
	f->font = NULL;
}

static void buffer_finalize( hbbuffer *b ) {
	hb_buffer_destroy(b->buf);
	b->buf = NULL;
}

HL_PRIM hbface *HL_NAME(face_create)( vbyte *data, int len, int index ) {
	hb_blob_t *blob;
	hb_face_t *face;
	hbface *f;
	if( len < 0 || index < 0 )
		hl_error("Invalid font data");
	blob = hb_blob_create((const char*)data, (unsigned int)len, HB_MEMORY_MODE_DUPLICATE, NULL, NULL);
	face = hb_face_create(blob, (unsigned int)index);
	hb_blob_destroy(blob);
	if( hb_face_get_glyph_count(face) == 0 ) {
		hb_face_destroy(face);
		hl_error("Not a font file");
	}
	f = (hbface*)hl_gc_alloc_finalizer(sizeof(hbface));
	f->finalize = face_finalize;
	f->face = face;
	return f;
}

HL_PRIM int HL_NAME(face_get_upem)( hbface *f ) {
	return (int)hb_face_get_upem(f->face);
}

HL_PRIM int HL_NAME(face_get_glyph_count)( hbface *f ) {
	return (int)hb_face_get_glyph_count(f->face);
}

HL_PRIM hbfont *HL_NAME(font_create)( hbface *face ) {
	hbfont *f = (hbfont*)hl_gc_alloc_finalizer(sizeof(hbfont));
	f->finalize = font_finalize;
	f->font = hb_font_create(face->face);
	return f;
}

HL_PRIM void HL_NAME(font_set_scale)( hbfont *f, int x, int y ) {
	hb_font_set_scale(f->font, x, y);
}

HL_PRIM void HL_NAME(font_shape)( hbfont *f, hbbuffer *b, vbyte *features ) {
	hb_feature_t *feats = NULL;
	unsigned int count = 0;
	hb_buffer_content_type_t type = hb_buffer_get_content_type(b->buf);
	if( type == HB_BUFFER_CONTENT_TYPE_GLYPHS )
		hl_error("Buffer is already shaped");
	if( type == HB_BUFFER_CONTENT_TYPE_UNICODE && !HB_DIRECTION_IS_VALID(hb_buffer_get_direction(b->buf)) )
		hl_error("Buffer direction is not set");
	if( features && *features ) {
		const char *s = (const char*)features;
		const char *p;
		unsigned int max = 1;
		for( p = s; *p; p++ )
			if( *p == ',' ) max++;
		feats = (hb_feature_t*)malloc(sizeof(hb_feature_t) * max);
		while( true ) {
			const char *end = strchr(s, ',');
			int len = end ? (int)(end - s) : (int)strlen(s);
			if( !hb_feature_from_string(s, len, &feats[count]) ) {
				free(feats);
				hl_error("Invalid feature list");
			}
			count++;
			if( !end ) break;
			s = end + 1;
		}
	}
	hb_shape(f->font, b->buf, feats, count);
	free(feats);
}

HL_PRIM hbbuffer *HL_NAME(buffer_create)() {
	hbbuffer *b = (hbbuffer*)hl_gc_alloc_finalizer(sizeof(hbbuffer));
	b->finalize = buffer_finalize;
	b->buf = hb_buffer_create();
	return b;
}

HL_PRIM void HL_NAME(buffer_add_utf16)( hbbuffer *b, vstring *text, int offset, int length ) {
	if( offset < 0 || length < 0 || offset > text->length - length )
		hl_error("Invalid text range");
	if( hb_buffer_get_content_type(b->buf) == HB_BUFFER_CONTENT_TYPE_GLYPHS )
		hl_error("Buffer is already shaped");
	hb_buffer_add_utf16(b->buf, (const uint16_t*)text->bytes, text->length, (unsigned int)offset, length);
}

HL_PRIM void HL_NAME(buffer_set_direction)( hbbuffer *b, int dir ) {
	hb_buffer_set_direction(b->buf, (hb_direction_t)dir);
}

HL_PRIM int HL_NAME(buffer_get_direction)( hbbuffer *b ) {
	return (int)hb_buffer_get_direction(b->buf);
}

HL_PRIM void HL_NAME(buffer_set_script)( hbbuffer *b, vbyte *tag ) {
	hb_buffer_set_script(b->buf, hb_script_from_string((const char*)tag, -1));
}

HL_PRIM int HL_NAME(buffer_get_script)( hbbuffer *b ) {
	return (int)hb_buffer_get_script(b->buf);
}

HL_PRIM void HL_NAME(buffer_set_language)( hbbuffer *b, vbyte *lang ) {
	hb_buffer_set_language(b->buf, hb_language_from_string((const char*)lang, -1));
}

HL_PRIM vbyte *HL_NAME(buffer_get_language)( hbbuffer *b ) {
	return (vbyte*)hb_language_to_string(hb_buffer_get_language(b->buf));
}

HL_PRIM void HL_NAME(buffer_guess_segment_properties)( hbbuffer *b ) {
	hb_buffer_guess_segment_properties(b->buf);
}

HL_PRIM void HL_NAME(buffer_clear)( hbbuffer *b ) {
	hb_buffer_clear_contents(b->buf);
}

HL_PRIM int HL_NAME(buffer_get_length)( hbbuffer *b ) {
	return (int)hb_buffer_get_length(b->buf);
}

HL_PRIM vbyte *HL_NAME(buffer_get_glyphs)( hbbuffer *b ) {
	unsigned int i, len = hb_buffer_get_length(b->buf);
	hb_glyph_info_t *info;
	hb_glyph_position_t *pos;
	int *out;
	if( len == 0 )
		return NULL;
	if( hb_buffer_get_content_type(b->buf) != HB_BUFFER_CONTENT_TYPE_GLYPHS )
		hl_error("Buffer is not shaped");
	info = hb_buffer_get_glyph_infos(b->buf, NULL);
	pos = hb_buffer_get_glyph_positions(b->buf, NULL);
	out = (int*)hl_alloc_bytes((int)(len * GLYPH_STRIDE * sizeof(int)));
	for( i = 0; i < len; i++ ) {
		int *g = out + i * GLYPH_STRIDE;
		g[0] = (int)info[i].codepoint;
		g[1] = (int)info[i].cluster;
		g[2] = pos[i].x_advance;
		g[3] = pos[i].y_advance;
		g[4] = pos[i].x_offset;
		g[5] = pos[i].y_offset;
	}
	return (vbyte*)out;
}

#define _FACE _ABSTRACT(hb_face)
#define _FONT _ABSTRACT(hb_font)
#define _BUFFER _ABSTRACT(hb_buffer)

DEFINE_PRIM(_FACE, face_create, _BYTES _I32 _I32);
DEFINE_PRIM(_I32, face_get_upem, _FACE);
DEFINE_PRIM(_I32, face_get_glyph_count, _FACE);
DEFINE_PRIM(_FONT, font_create, _FACE);
DEFINE_PRIM(_VOID, font_set_scale, _FONT _I32 _I32);
DEFINE_PRIM(_VOID, font_shape, _FONT _BUFFER _BYTES);
DEFINE_PRIM(_BUFFER, buffer_create, _NO_ARG);
DEFINE_PRIM(_VOID, buffer_add_utf16, _BUFFER _STRING _I32 _I32);
DEFINE_PRIM(_VOID, buffer_set_direction, _BUFFER _I32);
DEFINE_PRIM(_I32, buffer_get_direction, _BUFFER);
DEFINE_PRIM(_VOID, buffer_set_script, _BUFFER _BYTES);
DEFINE_PRIM(_I32, buffer_get_script, _BUFFER);
DEFINE_PRIM(_VOID, buffer_set_language, _BUFFER _BYTES);
DEFINE_PRIM(_BYTES, buffer_get_language, _BUFFER);
DEFINE_PRIM(_VOID, buffer_guess_segment_properties, _BUFFER);
DEFINE_PRIM(_VOID, buffer_clear, _BUFFER);
DEFINE_PRIM(_I32, buffer_get_length, _BUFFER);
DEFINE_PRIM(_BYTES, buffer_get_glyphs, _BUFFER);
