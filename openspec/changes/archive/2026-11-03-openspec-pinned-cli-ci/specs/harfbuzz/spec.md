## REMOVED Requirements

### Requirement: A face and a font are created from the bytes of a font file
**Reason**: Split so that each requirement states one behaviour in at most 500 characters.
**Migration**: *A face and a font are created from font data*, *The scale of a font sets the units of positions* state the same behaviour; nothing to migrate.

## ADDED Requirements

### Requirement: A face and a font are created from font data
`harfbuzz.Face.fromBytes(bytes, index)` SHALL create a face from the face `index` of the font file held in `bytes` and SHALL keep its own copy of them; bytes that hold no font with glyphs SHALL raise an exception. `new harfbuzz.Font(face)` SHALL create a font of that face. A face, a font and a buffer SHALL be released when the garbage collector frees the Haxe object.

#### Scenario: Font file
- **WHEN** a program reads a TrueType file into `haxe.io.Bytes` and calls `Face.fromBytes(bytes, 0)`
- **THEN** it gets a face whose `upem` and `glyphCount` are those of the file

#### Scenario: Not a font
- **WHEN** a program calls `Face.fromBytes` with bytes that are not a font file
- **THEN** the call throws

### Requirement: The scale of a font sets the units of positions
The scale of a `harfbuzz.Font` SHALL be the units per em of its face until `setScale(x, y)` sets another, and advances and offsets SHALL be in units of that scale.

#### Scenario: Default scale
- **WHEN** a font is created and `setScale` is not called
- **THEN** the advances of shaped glyphs are in font units, as the face's `upem` counts them

#### Scenario: Scale
- **WHEN** the same text is shaped once with the default scale and once after `setScale(2 * upem, 2 * upem)`
- **THEN** every advance of the second run is twice the advance of the first
