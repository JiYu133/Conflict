# Font

Inherits: Resource < RefCounted < Object

Inherited By: FontFile, FontVariation, SystemFont

Abstract base class for fonts and font variations.

## Description

Abstract base class for different font types. It has methods for drawing text and font character introspection.

## Properties

Array[Font] | fallbacks | []

## Methods

float | draw_char(canvas_item: RID, pos: Vector2, char: int, font_size: int, modulate: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) const
float | draw_char_outline(canvas_item: RID, pos: Vector2, char: int, font_size: int, size: int = -1, modulate: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) const
void | draw_multiline_string(canvas_item: RID, pos: Vector2, text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, max_lines: int = -1, modulate: Color = Color(1, 1, 1, 1), brk_flags: BitField[LineBreakFlag] = 3, justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0, oversampling: float = 0.0) const
void | draw_multiline_string_outline(canvas_item: RID, pos: Vector2, text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, max_lines: int = -1, size: int = 1, modulate: Color = Color(1, 1, 1, 1), brk_flags: BitField[LineBreakFlag] = 3, justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0, oversampling: float = 0.0) const
void | draw_string(canvas_item: RID, pos: Vector2, text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, modulate: Color = Color(1, 1, 1, 1), justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0, oversampling: float = 0.0) const
void | draw_string_outline(canvas_item: RID, pos: Vector2, text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, size: int = 1, modulate: Color = Color(1, 1, 1, 1), justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0, oversampling: float = 0.0) const
RID | find_variation(variation_coordinates: Dictionary, face_index: int = 0, strength: float = 0.0, transform: Transform2D = Transform2D(1, 0, 0, 1, 0, 0), spacing_top: int = 0, spacing_bottom: int = 0, spacing_space: int = 0, spacing_glyph: int = 0, baseline_offset: float = 0.0, palette_index: int = 0, custom_colors: PackedColorArray = PackedColorArray()) const
float | get_ascent(font_size: int = 16) const
Vector2 | get_char_size(char: int, font_size: int) const
float | get_descent(font_size: int = 16) const
int | get_face_count() const
String | get_font_name() const
int | get_font_stretch() const
BitField[FontStyle] | get_font_style() const
String | get_font_style_name() const
int | get_font_weight() const
float | get_height(font_size: int = 16) const
Vector2 | get_multiline_string_size(text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, max_lines: int = -1, brk_flags: BitField[LineBreakFlag] = 3, justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0) const
Dictionary | get_opentype_features() const
Dictionary | get_ot_name_strings() const
PackedColorArray | get_palette_colors(index: int) const
int | get_palette_count() const
String | get_palette_name(index: int) const
Array[RID] | get_rids() const
int | get_spacing(spacing: SpacingType) const
Vector2 | get_string_size(text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0) const
String | get_supported_chars() const
Dictionary | get_supported_feature_list() const
Dictionary | get_supported_variation_list() const
float | get_underline_position(font_size: int = 16) const
float | get_underline_thickness(font_size: int = 16) const
bool | has_char(char: int) const
bool | is_language_supported(language: String) const
bool | is_script_supported(script: String) const
void | set_cache_capacity(single_line: int, multi_line: int)

---

## Property Descriptions

Array[Font] fallbacks = [] 

- void set_fallbacks(value: Array[Font])
- Array[Font] get_fallbacks()

Array of fallback Fonts to use as a substitute if a glyph is not found in this current Font.

If this array is empty in a FontVariation, the FontVariation.base_font's fallbacks are used instead.

---

## Method Descriptions

float draw_char(canvas_item: RID, pos: Vector2, char: int, font_size: int, modulate: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) const 

Draw a single Unicode character char into a canvas item using the font, at a given position, with modulate color. pos specifies the baseline, not the top. To draw from the top, ascent must be added to the Y axis. If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

Note: Do not use this function to draw strings character by character, use draw_string() or TextLine instead.

---

float draw_char_outline(canvas_item: RID, pos: Vector2, char: int, font_size: int, size: int = -1, modulate: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) const 

Draw a single Unicode character char outline into a canvas item using the font, at a given position, with modulate color and size outline size. pos specifies the baseline, not the top. To draw from the top, ascent must be added to the Y axis. If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

Note: Do not use this function to draw strings character by character, use draw_string() or TextLine instead.

---

void draw_multiline_string(canvas_item: RID, pos: Vector2, text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, max_lines: int = -1, modulate: Color = Color(1, 1, 1, 1), brk_flags: BitField[LineBreakFlag] = 3, justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0, oversampling: float = 0.0) const 

Breaks text into lines using rules specified by brk_flags and draws it into a canvas item using the font, at a given position, with modulate color, optionally clipping the width and aligning horizontally. pos specifies the baseline of the first line, not the top. To draw from the top, ascent must be added to the Y axis. If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

See also CanvasItem.draw_multiline_string().

---

void draw_multiline_string_outline(canvas_item: RID, pos: Vector2, text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, max_lines: int = -1, size: int = 1, modulate: Color = Color(1, 1, 1, 1), brk_flags: BitField[LineBreakFlag] = 3, justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0, oversampling: float = 0.0) const 

Breaks text to the lines using rules specified by brk_flags and draws text outline into a canvas item using the font, at a given position, with modulate color and size outline size, optionally clipping the width and aligning horizontally. pos specifies the baseline of the first line, not the top. To draw from the top, ascent must be added to the Y axis. If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

See also CanvasItem.draw_multiline_string_outline().

---

void draw_string(canvas_item: RID, pos: Vector2, text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, modulate: Color = Color(1, 1, 1, 1), justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0, oversampling: float = 0.0) const 

Draw text into a canvas item using the font, at a given position, with modulate color, optionally clipping the width and aligning horizontally. pos specifies the baseline, not the top. To draw from the top, ascent must be added to the Y axis. If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

See also CanvasItem.draw_string().

---

void draw_string_outline(canvas_item: RID, pos: Vector2, text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, size: int = 1, modulate: Color = Color(1, 1, 1, 1), justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0, oversampling: float = 0.0) const 

Draw text outline into a canvas item using the font, at a given position, with modulate color and size outline size, optionally clipping the width and aligning horizontally. pos specifies the baseline, not the top. To draw from the top, ascent must be added to the Y axis. If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

See also CanvasItem.draw_string_outline().

---

RID find_variation(variation_coordinates: Dictionary, face_index: int = 0, strength: float = 0.0, transform: Transform2D = Transform2D(1, 0, 0, 1, 0, 0), spacing_top: int = 0, spacing_bottom: int = 0, spacing_space: int = 0, spacing_glyph: int = 0, baseline_offset: float = 0.0, palette_index: int = 0, custom_colors: PackedColorArray = PackedColorArray()) const 

Returns TextServer RID of the font cache for specific variation.

---

float get_ascent(font_size: int = 16) const 

Returns the maximum font ascent (number of pixels above the baseline) of this font and all fallback fonts.

Note: Real ascent of the string is context-dependent and can be significantly different from the value returned by this function. Use it only as rough estimate (e.g. as the ascent of empty line).

---

Vector2 get_char_size(char: int, font_size: int) const 

Returns the size of a character. Does not take kerning into account.

Note: Do not use this function to calculate width of the string character by character, use get_string_size() or TextLine instead. The height returned is the font height (see also get_height()) and has no relation to the glyph height.

---

float get_descent(font_size: int = 16) const 

Returns the maximum font descent (number of pixels below the baseline) of this font and all fallback fonts.

Note: Real descent of the string is context-dependent and can be significantly different from the value returned by this function. Use it only as rough estimate (e.g. as the descent of empty line).

---

int get_face_count() const 

Returns number of faces in the TrueType / OpenType collection.

---

String get_font_name() const 

Returns font family name.

---

int get_font_stretch() const 

Returns font stretch amount, compared to a normal width. A percentage value between 50% and 200%.

---

BitField[FontStyle] get_font_style() const 

Returns font style flags.

---

String get_font_style_name() const 

Returns font style name.

---

int get_font_weight() const 

Returns weight (boldness) of the font. A value in the 100...999 range, normal font weight is 400, bold font weight is 700.

---

float get_height(font_size: int = 16) const 

Returns the total average font height (ascent plus descent) in pixels.

Note: Real height of the string is context-dependent and can be significantly different from the value returned by this function. Use it only as rough estimate (e.g. as the height of empty line).

---

Vector2 get_multiline_string_size(text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, max_lines: int = -1, brk_flags: BitField[LineBreakFlag] = 3, justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0) const 

Returns the size of a bounding box of a string broken into the lines, taking kerning and advance into account.

See also draw_multiline_string().

---

Dictionary get_opentype_features() const 

Returns a set of OpenType feature tags. More info: OpenType feature tags [https://docs.microsoft.com/en-us/typography/opentype/spec/featuretags].

---

Dictionary get_ot_name_strings() const 

Returns Dictionary with OpenType font name strings (localized font names, version, description, license information, sample text, etc.).

---

PackedColorArray get_palette_colors(index: int) const 

Returns the array in the predefined color palette at index. Palette contains all colors used to render font glyphs. Each palette has the same number of colors. Colors can be overridden using FontVariation.

---

int get_palette_count() const 

Returns the number of predefined color palettes. Palette contains all colors used to render font glyphs. Each palette has the same number of colors.

---

String get_palette_name(index: int) const 

Returns the name of the predefined color palette at index. Palette contains all colors used to render font glyphs. Each palette has the same number of colors.

---

Array[RID] get_rids() const 

Returns Array of valid Font RIDs, which can be passed to the TextServer methods.

---

int get_spacing(spacing: SpacingType) const 

Returns the amount of spacing for the given spacing type.

---

Vector2 get_string_size(text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, justification_flags: BitField[JustificationFlag] = 3, direction: Direction = 0, orientation: Orientation = 0) const 

Returns the size of a bounding box of a single-line string, taking kerning, advance and subpixel positioning into account. See also get_multiline_string_size() and draw_string().

For example, to get the string size as displayed by a single-line Label, use:

```
var string_size = $Label.get_theme_font("font").get_string_size($Label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, $Label.get_theme_font_size("font_size"))
```

```
Label label = GetNode("Label");
Vector2 stringSize = label.GetThemeFont("font").GetStringSize(label.Text, HorizontalAlignment.Left, -1, label.GetThemeFontSize("font_size"));
```

Note: Since kerning, advance and subpixel positioning are taken into account by get_string_size(), using separate get_string_size() calls on substrings of a string then adding the results together will return a different result compared to using a single get_string_size() call on the full string.

Note: Real height of the string is context-dependent and can be significantly different from the value returned by get_height().

---

String get_supported_chars() const 

Returns a string containing all the characters available in the font.

If a given character is included in more than one font data source, it appears only once in the returned string.

---

Dictionary get_supported_feature_list() const 

Returns list of OpenType features supported by font.

---

Dictionary get_supported_variation_list() const 

Returns list of supported variation coordinates [https://docs.microsoft.com/en-us/typography/opentype/spec/dvaraxisreg], each coordinate is returned as tag: Vector3i(min_value,max_value,default_value).

Font variations allow for continuous change of glyph characteristics along some given design axis, such as weight, width or slant.

To print available variation axes of a variable font:

```gdscript
var fv = FontVariation.new()
fv.base_font = load("res://RobotoFlex.ttf")
var variation_list = fv.get_supported_variation_list()
for tag in variation_list:
    var name = TextServerManager.get_primary_interface().tag_to_name(tag)
    var values = variation_list[tag]
    print("variation axis: %s (%d)\n\tmin, max, default: %s" % [name, tag, values])
```

Note: To set and get variation coordinates of a FontVariation, use FontVariation.variation_opentype.

---

float get_underline_position(font_size: int = 16) const 

Returns average pixel offset of the underline below the baseline.

Note: Real underline position of the string is context-dependent and can be significantly different from the value returned by this function. Use it only as rough estimate.

---

float get_underline_thickness(font_size: int = 16) const 

Returns average thickness of the underline.

Note: Real underline thickness of the string is context-dependent and can be significantly different from the value returned by this function. Use it only as rough estimate.

---

bool has_char(char: int) const 

Returns true if a Unicode char is available in the font.

---

bool is_language_supported(language: String) const 

Returns true if the font supports the given language (as a ISO 639 [https://en.wikipedia.org/wiki/ISO_639-1] code).

---

bool is_script_supported(script: String) const 

Returns true if the font supports the given script (as a ISO 15924 [https://en.wikipedia.org/wiki/ISO_15924] code).

---

void set_cache_capacity(single_line: int, multi_line: int) 

Sets LRU cache capacity for draw_* methods.
