# TextServer

Inherits: RefCounted < Object

Inherited By: TextServerExtension

A server interface for font management and text rendering.

## Description

TextServer is the API backend for managing fonts and rendering text.

Note: This is a low-level API, consider using TextLine, TextParagraph, and Font classes instead.

This is an abstract class, so to get the currently active TextServer instance, use the following code:

```
var ts = TextServerManager.get_primary_interface()
```

```
var ts = TextServerManager.GetPrimaryInterface();
```

## Methods

RID | create_font()
RID | create_font_linked_variation(font_rid: RID)
RID | create_shaped_text(direction: Direction = 0, orientation: Orientation = 0)
void | draw_hex_code_box(canvas: RID, size: int, pos: Vector2, index: int, color: Color) const
void | font_clear_glyphs(font_rid: RID, size: Vector2i)
void | font_clear_kerning_map(font_rid: RID, size: int)
void | font_clear_size_cache(font_rid: RID)
void | font_clear_system_fallback_cache()
void | font_clear_textures(font_rid: RID, size: Vector2i)
void | font_draw_glyph(font_rid: RID, canvas: RID, size: int, pos: Vector2, index: int, color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) const
void | font_draw_glyph_outline(font_rid: RID, canvas: RID, size: int, outline_size: int, pos: Vector2, index: int, color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) const
FontAntialiasing | font_get_antialiasing(font_rid: RID) const
float | font_get_ascent(font_rid: RID, size: int) const
float | font_get_baseline_offset(font_rid: RID) const
int | font_get_char_from_glyph_index(font_rid: RID, size: int, glyph_index: int) const
float | font_get_descent(font_rid: RID, size: int) const
bool | font_get_disable_embedded_bitmaps(font_rid: RID) const
float | font_get_embolden(font_rid: RID) const
int | font_get_face_count(font_rid: RID) const
int | font_get_face_index(font_rid: RID) const
int | font_get_fixed_size(font_rid: RID) const
FixedSizeScaleMode | font_get_fixed_size_scale_mode(font_rid: RID) const
bool | font_get_generate_mipmaps(font_rid: RID) const
float | font_get_global_oversampling() const
Vector2 | font_get_glyph_advance(font_rid: RID, size: int, glyph: int) const
Dictionary | font_get_glyph_contours(font: RID, size: int, index: int) const
int | font_get_glyph_index(font_rid: RID, size: int, char: int, variation_selector: int) const
PackedInt32Array | font_get_glyph_list(font_rid: RID, size: Vector2i) const
Vector2 | font_get_glyph_offset(font_rid: RID, size: Vector2i, glyph: int) const
Vector2 | font_get_glyph_size(font_rid: RID, size: Vector2i, glyph: int) const
int | font_get_glyph_texture_idx(font_rid: RID, size: Vector2i, glyph: int) const
RID | font_get_glyph_texture_rid(font_rid: RID, size: Vector2i, glyph: int) const
Vector2 | font_get_glyph_texture_size(font_rid: RID, size: Vector2i, glyph: int) const
Rect2 | font_get_glyph_uv_rect(font_rid: RID, size: Vector2i, glyph: int) const
Hinting | font_get_hinting(font_rid: RID) const
bool | font_get_keep_rounding_remainders(font_rid: RID) const
Vector2 | font_get_kerning(font_rid: RID, size: int, glyph_pair: Vector2i) const
Array[Vector2i] | font_get_kerning_list(font_rid: RID, size: int) const
bool | font_get_language_support_override(font_rid: RID, language: String)
PackedStringArray | font_get_language_support_overrides(font_rid: RID)
int | font_get_msdf_pixel_range(font_rid: RID) const
int | font_get_msdf_size(font_rid: RID) const
String | font_get_name(font_rid: RID) const
Dictionary | font_get_opentype_feature_overrides(font_rid: RID) const
Dictionary | font_get_ot_name_strings(font_rid: RID) const
float | font_get_oversampling(font_rid: RID) const
PackedColorArray | font_get_palette_colors(font_rid: RID, index: int) const
int | font_get_palette_count(font_rid: RID) const
PackedColorArray | font_get_palette_custom_colors(font_rid: RID) const
String | font_get_palette_name(font_rid: RID, index: int) const
float | font_get_scale(font_rid: RID, size: int) const
bool | font_get_script_support_override(font_rid: RID, script: String)
PackedStringArray | font_get_script_support_overrides(font_rid: RID)
Array[Dictionary] | font_get_size_cache_info(font_rid: RID) const
Array[Vector2i] | font_get_size_cache_list(font_rid: RID) const
int | font_get_spacing(font_rid: RID, spacing: SpacingType) const
int | font_get_stretch(font_rid: RID) const
BitField[FontStyle] | font_get_style(font_rid: RID) const
String | font_get_style_name(font_rid: RID) const
SubpixelPositioning | font_get_subpixel_positioning(font_rid: RID) const
String | font_get_supported_chars(font_rid: RID) const
PackedInt32Array | font_get_supported_glyphs(font_rid: RID) const
int | font_get_texture_count(font_rid: RID, size: Vector2i) const
Image | font_get_texture_image(font_rid: RID, size: Vector2i, texture_index: int) const
PackedInt32Array | font_get_texture_offsets(font_rid: RID, size: Vector2i, texture_index: int) const
Transform2D | font_get_transform(font_rid: RID) const
float | font_get_underline_position(font_rid: RID, size: int) const
float | font_get_underline_thickness(font_rid: RID, size: int) const
int | font_get_used_palette(font_rid: RID) const
Dictionary | font_get_variation_coordinates(font_rid: RID) const
int | font_get_weight(font_rid: RID) const
bool | font_has_char(font_rid: RID, char: int) const
bool | font_is_allow_system_fallback(font_rid: RID) const
bool | font_is_force_autohinter(font_rid: RID) const
bool | font_is_language_supported(font_rid: RID, language: String) const
bool | font_is_modulate_color_glyphs(font_rid: RID) const
bool | font_is_multichannel_signed_distance_field(font_rid: RID) const
bool | font_is_script_supported(font_rid: RID, script: String) const
void | font_remove_glyph(font_rid: RID, size: Vector2i, glyph: int)
void | font_remove_kerning(font_rid: RID, size: int, glyph_pair: Vector2i)
void | font_remove_language_support_override(font_rid: RID, language: String)
void | font_remove_script_support_override(font_rid: RID, script: String)
void | font_remove_size_cache(font_rid: RID, size: Vector2i)
void | font_remove_texture(font_rid: RID, size: Vector2i, texture_index: int)
void | font_render_glyph(font_rid: RID, size: Vector2i, index: int)
void | font_render_range(font_rid: RID, size: Vector2i, start: int, end: int)
void | font_set_allow_system_fallback(font_rid: RID, allow_system_fallback: bool)
void | font_set_antialiasing(font_rid: RID, antialiasing: FontAntialiasing)
void | font_set_ascent(font_rid: RID, size: int, ascent: float)
void | font_set_baseline_offset(font_rid: RID, baseline_offset: float)
void | font_set_data(font_rid: RID, data: PackedByteArray)
void | font_set_descent(font_rid: RID, size: int, descent: float)
void | font_set_disable_embedded_bitmaps(font_rid: RID, disable_embedded_bitmaps: bool)
void | font_set_embolden(font_rid: RID, strength: float)
void | font_set_face_index(font_rid: RID, face_index: int)
void | font_set_fixed_size(font_rid: RID, fixed_size: int)
void | font_set_fixed_size_scale_mode(font_rid: RID, fixed_size_scale_mode: FixedSizeScaleMode)
void | font_set_force_autohinter(font_rid: RID, force_autohinter: bool)
void | font_set_generate_mipmaps(font_rid: RID, generate_mipmaps: bool)
void | font_set_global_oversampling(oversampling: float)
void | font_set_glyph_advance(font_rid: RID, size: int, glyph: int, advance: Vector2)
void | font_set_glyph_offset(font_rid: RID, size: Vector2i, glyph: int, offset: Vector2)
void | font_set_glyph_size(font_rid: RID, size: Vector2i, glyph: int, gl_size: Vector2)
void | font_set_glyph_texture_idx(font_rid: RID, size: Vector2i, glyph: int, texture_idx: int)
void | font_set_glyph_uv_rect(font_rid: RID, size: Vector2i, glyph: int, uv_rect: Rect2)
void | font_set_hinting(font_rid: RID, hinting: Hinting)
void | font_set_keep_rounding_remainders(font_rid: RID, keep_rounding_remainders: bool)
void | font_set_kerning(font_rid: RID, size: int, glyph_pair: Vector2i, kerning: Vector2)
void | font_set_language_support_override(font_rid: RID, language: String, supported: bool)
void | font_set_modulate_color_glyphs(font_rid: RID, modulate: bool)
void | font_set_msdf_pixel_range(font_rid: RID, msdf_pixel_range: int)
void | font_set_msdf_size(font_rid: RID, msdf_size: int)
void | font_set_multichannel_signed_distance_field(font_rid: RID, msdf: bool)
void | font_set_name(font_rid: RID, name: String)
void | font_set_opentype_feature_overrides(font_rid: RID, overrides: Dictionary)
void | font_set_oversampling(font_rid: RID, oversampling: float)
void | font_set_palette_custom_colors(font_rid: RID, colors: PackedColorArray)
void | font_set_scale(font_rid: RID, size: int, scale: float)
void | font_set_script_support_override(font_rid: RID, script: String, supported: bool)
void | font_set_spacing(font_rid: RID, spacing: SpacingType, value: int)
void | font_set_stretch(font_rid: RID, weight: int)
void | font_set_style(font_rid: RID, style: BitField[FontStyle])
void | font_set_style_name(font_rid: RID, name: String)
void | font_set_subpixel_positioning(font_rid: RID, subpixel_positioning: SubpixelPositioning)
void | font_set_texture_image(font_rid: RID, size: Vector2i, texture_index: int, image: Image)
void | font_set_texture_offsets(font_rid: RID, size: Vector2i, texture_index: int, offset: PackedInt32Array)
void | font_set_transform(font_rid: RID, transform: Transform2D)
void | font_set_underline_position(font_rid: RID, size: int, underline_position: float)
void | font_set_underline_thickness(font_rid: RID, size: int, underline_thickness: float)
void | font_set_used_palette(font_rid: RID, index: int)
void | font_set_variation_coordinates(font_rid: RID, variation_coordinates: Dictionary)
void | font_set_weight(font_rid: RID, weight: int)
Dictionary | font_supported_feature_list(font_rid: RID) const
Dictionary | font_supported_variation_list(font_rid: RID) const
String | format_number(number: String, language: String = "") const
void | free_rid(rid: RID)
int | get_features() const
Vector2 | get_hex_code_box_size(size: int, index: int) const
String | get_name() const
PackedByteArray | get_support_data() const
String | get_support_data_filename() const
String | get_support_data_info() const
bool | has(rid: RID)
bool | has_feature(feature: Feature) const
int | is_confusable(string: String, dict: PackedStringArray) const
bool | is_locale_right_to_left(locale: String) const
bool | is_locale_using_support_data(locale: String) const
bool | is_valid_identifier(string: String) const
bool | is_valid_letter(unicode: int) const
bool | load_support_data(filename: String)
int | name_to_tag(name: String) const
String | parse_number(number: String, language: String = "") const
Array[Vector3i] | parse_structured_text(parser_type: StructuredTextParser, args: Array, text: String) const
String | percent_sign(language: String = "") const
bool | save_support_data(filename: String) const
int | shaped_get_run_count(shaped: RID) const
Direction | shaped_get_run_direction(shaped: RID, index: int) const
RID | shaped_get_run_font_rid(shaped: RID, index: int) const
int | shaped_get_run_font_size(shaped: RID, index: int) const
Vector2i | shaped_get_run_glyph_range(shaped: RID, index: int) const
String | shaped_get_run_language(shaped: RID, index: int) const
Variant | shaped_get_run_object(shaped: RID, index: int) const
Vector2i | shaped_get_run_range(shaped: RID, index: int) const
String | shaped_get_run_text(shaped: RID, index: int) const
int | shaped_get_span_count(shaped: RID) const
Variant | shaped_get_span_embedded_object(shaped: RID, index: int) const
Variant | shaped_get_span_meta(shaped: RID, index: int) const
Variant | shaped_get_span_object(shaped: RID, index: int) const
String | shaped_get_span_text(shaped: RID, index: int) const
String | shaped_get_text(shaped: RID) const
void | shaped_set_span_update_font(shaped: RID, index: int, fonts: Array[RID], size: int, opentype_features: Dictionary = {})
bool | shaped_text_add_object(shaped: RID, key: Variant, size: Vector2, inline_align: InlineAlignment = 5, length: int = 1, baseline: float = 0.0)
bool | shaped_text_add_string(shaped: RID, text: String, fonts: Array[RID], size: int, opentype_features: Dictionary = {}, language: String = "", meta: Variant = null)
void | shaped_text_clear(rid: RID)
int | shaped_text_closest_character_pos(shaped: RID, pos: int) const
void | shaped_text_draw(shaped: RID, canvas: RID, pos: Vector2, clip_l: float = -1, clip_r: float = -1, color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) const
void | shaped_text_draw_outline(shaped: RID, canvas: RID, pos: Vector2, clip_l: float = -1, clip_r: float = -1, outline_size: int = 1, color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) const
RID | shaped_text_duplicate(rid: RID)
float | shaped_text_fit_to_width(shaped: RID, width: float, justification_flags: BitField[JustificationFlag] = 3)
float | shaped_text_get_ascent(shaped: RID) const
Dictionary | shaped_text_get_carets(shaped: RID, position: int) const
PackedInt32Array | shaped_text_get_character_breaks(shaped: RID) const
int | shaped_text_get_custom_ellipsis(shaped: RID) const
String | shaped_text_get_custom_punctuation(shaped: RID) const
float | shaped_text_get_descent(shaped: RID) const
Direction | shaped_text_get_direction(shaped: RID) const
Direction | shaped_text_get_dominant_direction_in_range(shaped: RID, start: int, end: int) const
int | shaped_text_get_ellipsis_glyph_count(shaped: RID) const
Array[Dictionary] | shaped_text_get_ellipsis_glyphs(shaped: RID) const
int | shaped_text_get_ellipsis_pos(shaped: RID) const
int | shaped_text_get_glyph_count(shaped: RID) const
Array[Dictionary] | shaped_text_get_glyphs(shaped: RID) const
Vector2 | shaped_text_get_grapheme_bounds(shaped: RID, pos: int) const
Direction | shaped_text_get_inferred_direction(shaped: RID) const
PackedInt32Array | shaped_text_get_line_breaks(shaped: RID, width: float, start: int = 0, break_flags: BitField[LineBreakFlag] = 3) const
PackedInt32Array | shaped_text_get_line_breaks_adv(shaped: RID, width: PackedFloat32Array, start: int = 0, once: bool = true, break_flags: BitField[LineBreakFlag] = 3) const
int | shaped_text_get_object_glyph(shaped: RID, key: Variant) const
Vector2i | shaped_text_get_object_range(shaped: RID, key: Variant) const
Rect2 | shaped_text_get_object_rect(shaped: RID, key: Variant) const
Array | shaped_text_get_objects(shaped: RID) const
Orientation | shaped_text_get_orientation(shaped: RID) const
RID | shaped_text_get_parent(shaped: RID) const
bool | shaped_text_get_preserve_control(shaped: RID) const
bool | shaped_text_get_preserve_invalid(shaped: RID) const
Vector2i | shaped_text_get_range(shaped: RID) const
PackedVector2Array | shaped_text_get_selection(shaped: RID, start: int, end: int) const
Vector2 | shaped_text_get_size(shaped: RID) const
int | shaped_text_get_spacing(shaped: RID, spacing: SpacingType) const
int | shaped_text_get_trim_pos(shaped: RID) const
float | shaped_text_get_underline_position(shaped: RID) const
float | shaped_text_get_underline_thickness(shaped: RID) const
float | shaped_text_get_width(shaped: RID) const
PackedInt32Array | shaped_text_get_word_breaks(shaped: RID, grapheme_flags: BitField[GraphemeFlag] = 264, skip_grapheme_flags: BitField[GraphemeFlag] = 4) const
bool | shaped_text_has_object(shaped: RID, key: Variant) const
bool | shaped_text_has_visible_chars(shaped: RID) const
int | shaped_text_hit_test_grapheme(shaped: RID, coords: float) const
int | shaped_text_hit_test_position(shaped: RID, coords: float) const
bool | shaped_text_is_ready(shaped: RID) const
int | shaped_text_next_character_pos(shaped: RID, pos: int) const
int | shaped_text_next_grapheme_pos(shaped: RID, pos: int) const
void | shaped_text_overrun_trim_to_width(shaped: RID, width: float = 0, overrun_trim_flags: BitField[TextOverrunFlag] = 0)
int | shaped_text_prev_character_pos(shaped: RID, pos: int) const
int | shaped_text_prev_grapheme_pos(shaped: RID, pos: int) const
bool | shaped_text_resize_object(shaped: RID, key: Variant, size: Vector2, inline_align: InlineAlignment = 5, baseline: float = 0.0)
void | shaped_text_set_bidi_override(shaped: RID, override: Array)
void | shaped_text_set_custom_ellipsis(shaped: RID, char: int)
void | shaped_text_set_custom_punctuation(shaped: RID, punct: String)
void | shaped_text_set_direction(shaped: RID, direction: Direction = 0)
void | shaped_text_set_orientation(shaped: RID, orientation: Orientation = 0)
void | shaped_text_set_preserve_control(shaped: RID, enabled: bool)
void | shaped_text_set_preserve_invalid(shaped: RID, enabled: bool)
void | shaped_text_set_spacing(shaped: RID, spacing: SpacingType, value: int)
bool | shaped_text_shape(shaped: RID)
Array[Dictionary] | shaped_text_sort_logical(shaped: RID)
RID | shaped_text_substr(shaped: RID, start: int, length: int) const
float | shaped_text_tab_align(shaped: RID, tab_stops: PackedFloat32Array)
bool | spoof_check(string: String) const
PackedInt32Array | string_get_character_breaks(string: String, language: String = "") const
PackedInt32Array | string_get_word_breaks(string: String, language: String = "", chars_per_line: int = 0) const
String | string_to_lower(string: String, language: String = "") const
String | string_to_title(string: String, language: String = "") const
String | string_to_upper(string: String, language: String = "") const
String | strip_diacritics(string: String) const
String | tag_to_name(tag: int) const

---

## Enumerations

enum FontAntialiasing
FontAntialiasing FONT_ANTIALIASING_NONE = 0

Font glyphs are rasterized as 1-bit bitmaps.

FontAntialiasing FONT_ANTIALIASING_GRAY = 1

Font glyphs are rasterized as 8-bit grayscale anti-aliased bitmaps.

FontAntialiasing FONT_ANTIALIASING_LCD = 2

Font glyphs are rasterized for LCD screens.

LCD subpixel layout is determined by the value of the ProjectSettings.gui/theme/lcd_subpixel_layout setting.

LCD subpixel anti-aliasing mode is suitable only for rendering horizontal, unscaled text in 2D.

---

enum FontLCDSubpixelLayout
FontLCDSubpixelLayout FONT_LCD_SUBPIXEL_LAYOUT_NONE = 0

Unknown or unsupported subpixel layout, LCD subpixel antialiasing is disabled.

FontLCDSubpixelLayout FONT_LCD_SUBPIXEL_LAYOUT_HRGB = 1

Horizontal RGB subpixel layout.

FontLCDSubpixelLayout FONT_LCD_SUBPIXEL_LAYOUT_HBGR = 2

Horizontal BGR subpixel layout.

FontLCDSubpixelLayout FONT_LCD_SUBPIXEL_LAYOUT_VRGB = 3

Vertical RGB subpixel layout.

FontLCDSubpixelLayout FONT_LCD_SUBPIXEL_LAYOUT_VBGR = 4

Vertical BGR subpixel layout.

FontLCDSubpixelLayout FONT_LCD_SUBPIXEL_LAYOUT_MAX = 5

Represents the size of the FontLCDSubpixelLayout enum.

---

enum Direction
Direction DIRECTION_AUTO = 0

Text direction is determined based on contents and current locale.

Direction DIRECTION_LTR = 1

Text is written from left to right.

Direction DIRECTION_RTL = 2

Text is written from right to left.

Direction DIRECTION_INHERITED = 3

Text writing direction is the same as base string writing direction. Used for BiDi override only.

---

enum Orientation
Orientation ORIENTATION_HORIZONTAL = 0

Text is written horizontally.

Orientation ORIENTATION_VERTICAL = 1

Left to right text is written vertically from top to bottom.

Right to left text is written vertically from bottom to top.

---

flags JustificationFlag: 

JustificationFlag JUSTIFICATION_NONE = 0

Do not justify text.

JustificationFlag JUSTIFICATION_KASHIDA = 1

Justify text by adding and removing kashidas.

JustificationFlag JUSTIFICATION_WORD_BOUND = 2

Justify text by changing width of the spaces between the words.

JustificationFlag JUSTIFICATION_TRIM_EDGE_SPACES = 4

Remove trailing and leading spaces from the justified text.

JustificationFlag JUSTIFICATION_AFTER_LAST_TAB = 8

Only apply justification to the part of the text after the last tab.

JustificationFlag JUSTIFICATION_CONSTRAIN_ELLIPSIS = 16

Apply justification to the trimmed line with ellipsis.

JustificationFlag JUSTIFICATION_SKIP_LAST_LINE = 32

Do not apply justification to the last line of the paragraph.

JustificationFlag JUSTIFICATION_SKIP_LAST_LINE_WITH_VISIBLE_CHARS = 64

Do not apply justification to the last line of the paragraph with visible characters (takes precedence over JUSTIFICATION_SKIP_LAST_LINE).

JustificationFlag JUSTIFICATION_DO_NOT_SKIP_SINGLE_LINE = 128

Always apply justification to the paragraphs with a single line (JUSTIFICATION_SKIP_LAST_LINE and JUSTIFICATION_SKIP_LAST_LINE_WITH_VISIBLE_CHARS are ignored).

---

enum AutowrapMode
AutowrapMode AUTOWRAP_OFF = 0

Autowrap is disabled.

AutowrapMode AUTOWRAP_ARBITRARY = 1

Wraps the text inside the node's bounding rectangle by allowing to break lines at arbitrary positions, which is useful when very limited space is available.

AutowrapMode AUTOWRAP_WORD = 2

Wraps the text inside the node's bounding rectangle by soft-breaking between words.

AutowrapMode AUTOWRAP_WORD_SMART = 3

Behaves similarly to AUTOWRAP_WORD, but force-breaks a word if that single word does not fit in one line.

---

flags LineBreakFlag: 

LineBreakFlag BREAK_NONE = 0

Do not break the line.

LineBreakFlag BREAK_MANDATORY = 1

Break the line at the line mandatory break characters (e.g. "\n").

LineBreakFlag BREAK_WORD_BOUND = 2

Break the line between the words.

LineBreakFlag BREAK_GRAPHEME_BOUND = 4

Break the line between any unconnected graphemes.

LineBreakFlag BREAK_ADAPTIVE = 8

Should be used only in conjunction with BREAK_WORD_BOUND, break the line between any unconnected graphemes, if it's impossible to break it between the words.

LineBreakFlag BREAK_TRIM_EDGE_SPACES = 16

Deprecated: Use BREAK_TRIM_START_EDGE_SPACES | BREAK_TRIM_END_EDGE_SPACES instead.

Remove edge spaces from the broken line segments.

LineBreakFlag BREAK_TRIM_INDENT = 32

Subtract first line indentation width from all lines after the first one.

LineBreakFlag BREAK_TRIM_START_EDGE_SPACES = 64

Remove spaces and line break characters from the start of broken line segments.

E.g, after line breaking, the second segment of the following text test  \n  next, is next if the flag is set, and ``  next`` if it is not.

LineBreakFlag BREAK_TRIM_END_EDGE_SPACES = 128

Remove spaces and line break characters from the end of broken line segments.

E.g, after line breaking, the first segment of the following text test  \n  next, is test if the flag is set, and test  \n if it is not.

---

enum VisibleCharactersBehavior
VisibleCharactersBehavior VC_CHARS_BEFORE_SHAPING = 0

Trims text before the shaping. e.g, increasing Label.visible_characters or RichTextLabel.visible_characters value is visually identical to typing the text.

Note: In this mode, trimmed text is not processed at all. It is not accounted for in line breaking and size calculations.

VisibleCharactersBehavior VC_CHARS_AFTER_SHAPING = 1

Displays glyphs that are mapped to the first Label.visible_characters or RichTextLabel.visible_characters characters from the beginning of the text.

VisibleCharactersBehavior VC_GLYPHS_AUTO = 2

Displays Label.visible_ratio or RichTextLabel.visible_ratio glyphs, starting from the left or from the right, depending on Control.layout_direction value.

VisibleCharactersBehavior VC_GLYPHS_LTR = 3

Displays Label.visible_ratio or RichTextLabel.visible_ratio glyphs, starting from the left.

VisibleCharactersBehavior VC_GLYPHS_RTL = 4

Displays Label.visible_ratio or RichTextLabel.visible_ratio glyphs, starting from the right.

---

enum OverrunBehavior
OverrunBehavior OVERRUN_NO_TRIMMING = 0

No text trimming is performed.

OverrunBehavior OVERRUN_TRIM_CHAR = 1

Trims the text per character.

OverrunBehavior OVERRUN_TRIM_WORD = 2

Trims the text per word.

OverrunBehavior OVERRUN_TRIM_ELLIPSIS = 3

Trims the text per character and adds an ellipsis to indicate that parts are hidden if trimmed text is 6 characters or longer.

OverrunBehavior OVERRUN_TRIM_WORD_ELLIPSIS = 4

Trims the text per word and adds an ellipsis to indicate that parts are hidden if trimmed text is 6 characters or longer.

OverrunBehavior OVERRUN_TRIM_ELLIPSIS_FORCE = 5

Trims the text per character and adds an ellipsis to indicate that parts are hidden regardless of trimmed text length.

OverrunBehavior OVERRUN_TRIM_WORD_ELLIPSIS_FORCE = 6

Trims the text per word and adds an ellipsis to indicate that parts are hidden regardless of trimmed text length.

---

flags TextOverrunFlag: 

TextOverrunFlag OVERRUN_NO_TRIM = 0

No trimming is performed.

TextOverrunFlag OVERRUN_TRIM = 1

Trims the text when it exceeds the given width.

TextOverrunFlag OVERRUN_TRIM_WORD_ONLY = 2

Trims the text per word instead of per grapheme.

TextOverrunFlag OVERRUN_ADD_ELLIPSIS = 4

Determines whether an ellipsis should be added at the end of the text.

TextOverrunFlag OVERRUN_ENFORCE_ELLIPSIS = 8

Determines whether the ellipsis at the end of the text is enforced and may not be hidden.

TextOverrunFlag OVERRUN_JUSTIFICATION_AWARE = 16

Accounts for the text being justified before attempting to trim it (see JustificationFlag).

TextOverrunFlag OVERRUN_SHORT_STRING_ELLIPSIS = 32

Determines whether the ellipsis should be added regardless of the string length, otherwise it is added only if the string is 6 characters or longer.

---

flags GraphemeFlag: 

GraphemeFlag GRAPHEME_IS_VALID = 1

Grapheme is supported by the font, and can be drawn.

GraphemeFlag GRAPHEME_IS_RTL = 2

Grapheme is part of right-to-left or bottom-to-top run.

GraphemeFlag GRAPHEME_IS_VIRTUAL = 4

Grapheme is not part of source text, it was added by justification process.

GraphemeFlag GRAPHEME_IS_SPACE = 8

Grapheme is whitespace.

GraphemeFlag GRAPHEME_IS_BREAK_HARD = 16

Grapheme is mandatory break point (e.g. "\n").

GraphemeFlag GRAPHEME_IS_BREAK_SOFT = 32

Grapheme is optional break point (e.g. space).

GraphemeFlag GRAPHEME_IS_TAB = 64

Grapheme is the tabulation character.

GraphemeFlag GRAPHEME_IS_ELONGATION = 128

Grapheme is kashida.

GraphemeFlag GRAPHEME_IS_PUNCTUATION = 256

Grapheme is punctuation character.

GraphemeFlag GRAPHEME_IS_UNDERSCORE = 512

Grapheme is underscore character.

GraphemeFlag GRAPHEME_IS_CONNECTED = 1024

Grapheme is connected to the previous grapheme. Breaking line before this grapheme is not safe.

GraphemeFlag GRAPHEME_IS_SAFE_TO_INSERT_TATWEEL = 2048

It is safe to insert a U+0640 before this grapheme for elongation.

GraphemeFlag GRAPHEME_IS_EMBEDDED_OBJECT = 4096

Grapheme is an object replacement character for the embedded object.

GraphemeFlag GRAPHEME_IS_SOFT_HYPHEN = 8192

Grapheme is a soft hyphen.

---

enum Hinting
Hinting HINTING_NONE = 0

Disables font hinting (smoother but less crisp).

Hinting HINTING_LIGHT = 1

Use the light font hinting mode.

Hinting HINTING_NORMAL = 2

Use the default font hinting mode (crisper but less smooth).

Note: This hinting mode changes both horizontal and vertical glyph metrics. If applied to monospace font, some glyphs might have different width.

---

enum SubpixelPositioning
SubpixelPositioning SUBPIXEL_POSITIONING_DISABLED = 0

Glyph horizontal position is rounded to the whole pixel size, each glyph is rasterized once.

SubpixelPositioning SUBPIXEL_POSITIONING_AUTO = 1

Glyph horizontal position is rounded based on font size.

- To one quarter of the pixel size if font size is smaller or equal to SUBPIXEL_POSITIONING_ONE_QUARTER_MAX_SIZE.
- To one half of the pixel size if font size is smaller or equal to SUBPIXEL_POSITIONING_ONE_HALF_MAX_SIZE.
- To the whole pixel size for larger fonts.

SubpixelPositioning SUBPIXEL_POSITIONING_ONE_HALF = 2

Glyph horizontal position is rounded to one half of the pixel size, each glyph is rasterized up to two times.

SubpixelPositioning SUBPIXEL_POSITIONING_ONE_QUARTER = 3

Glyph horizontal position is rounded to one quarter of the pixel size, each glyph is rasterized up to four times.

SubpixelPositioning SUBPIXEL_POSITIONING_ONE_HALF_MAX_SIZE = 20

Maximum font size which will use "one half of the pixel" subpixel positioning in SUBPIXEL_POSITIONING_AUTO mode.

SubpixelPositioning SUBPIXEL_POSITIONING_ONE_QUARTER_MAX_SIZE = 16

Maximum font size which will use "one quarter of the pixel" subpixel positioning in SUBPIXEL_POSITIONING_AUTO mode.

---

enum Feature
Feature FEATURE_SIMPLE_LAYOUT = 1

TextServer supports simple text layouts.

Feature FEATURE_BIDI_LAYOUT = 2

TextServer supports bidirectional text layouts.

Feature FEATURE_VERTICAL_LAYOUT = 4

TextServer supports vertical layouts.

Feature FEATURE_SHAPING = 8

TextServer supports complex text shaping.

Feature FEATURE_KASHIDA_JUSTIFICATION = 16

TextServer supports justification using kashidas.

Feature FEATURE_BREAK_ITERATORS = 32

TextServer supports complex line/word breaking rules (e.g. dictionary based).

Feature FEATURE_FONT_BITMAP = 64

TextServer supports loading bitmap fonts.

Feature FEATURE_FONT_DYNAMIC = 128

TextServer supports loading dynamic (TrueType, OpeType, etc.) fonts.

Feature FEATURE_FONT_MSDF = 256

TextServer supports multichannel signed distance field dynamic font rendering.

Feature FEATURE_FONT_SYSTEM = 512

TextServer supports loading system fonts.

Feature FEATURE_FONT_VARIABLE = 1024

TextServer supports variable fonts.

Feature FEATURE_CONTEXT_SENSITIVE_CASE_CONVERSION = 2048

TextServer supports locale dependent and context sensitive case conversion.

Feature FEATURE_USE_SUPPORT_DATA = 4096

TextServer require external data file for some features, see load_support_data().

Feature FEATURE_UNICODE_IDENTIFIERS = 8192

TextServer supports UAX #31 identifier validation, see is_valid_identifier().

Feature FEATURE_UNICODE_SECURITY = 16384

TextServer supports Unicode Technical Report #36 [https://unicode.org/reports/tr36/] and Unicode Technical Standard #39 [https://unicode.org/reports/tr39/] based spoof detection features.

---

enum ContourPointTag
ContourPointTag CONTOUR_CURVE_TAG_ON = 1

Contour point is on the curve.

ContourPointTag CONTOUR_CURVE_TAG_OFF_CONIC = 0

Contour point isn't on the curve, but serves as a control point for a conic (quadratic) Bézier arc.

ContourPointTag CONTOUR_CURVE_TAG_OFF_CUBIC = 2

Contour point isn't on the curve, but serves as a control point for a cubic Bézier arc.

---

enum SpacingType
SpacingType SPACING_GLYPH = 0

Spacing for each glyph.

SpacingType SPACING_SPACE = 1

Spacing for the space character.

SpacingType SPACING_TOP = 2

Spacing at the top of the line.

SpacingType SPACING_BOTTOM = 3

Spacing at the bottom of the line.

SpacingType SPACING_MAX = 4

Represents the size of the SpacingType enum.

---

flags FontStyle: 

FontStyle FONT_BOLD = 1

Font is bold.

FontStyle FONT_ITALIC = 2

Font is italic or oblique.

FontStyle FONT_FIXED_WIDTH = 4

Font has fixed-width characters (also known as monospace).

---

enum StructuredTextParser
StructuredTextParser STRUCTURED_TEXT_DEFAULT = 0

Use default Unicode BiDi algorithm.

StructuredTextParser STRUCTURED_TEXT_URI = 1

BiDi override for URI.

StructuredTextParser STRUCTURED_TEXT_FILE = 2

BiDi override for file path.

StructuredTextParser STRUCTURED_TEXT_EMAIL = 3

BiDi override for email.

StructuredTextParser STRUCTURED_TEXT_LIST = 4

BiDi override for lists. Structured text options: list separator String.

StructuredTextParser STRUCTURED_TEXT_GDSCRIPT = 5

BiDi override for GDScript.

StructuredTextParser STRUCTURED_TEXT_CUSTOM = 6

User defined structured text BiDi override function.

---

enum FixedSizeScaleMode
FixedSizeScaleMode FIXED_SIZE_SCALE_DISABLE = 0

Bitmap font is not scaled.

FixedSizeScaleMode FIXED_SIZE_SCALE_INTEGER_ONLY = 1

Bitmap font is scaled to the closest integer multiple of the font's fixed size. This is the recommended option for pixel art fonts.

FixedSizeScaleMode FIXED_SIZE_SCALE_ENABLED = 2

Bitmap font is scaled to an arbitrary (fractional) size. This is the recommended option for non-pixel art fonts.

---

## Method Descriptions

RID create_font() 

Creates a new, empty font cache entry resource. To free the resulting resource, use the free_rid() method.

---

RID create_font_linked_variation(font_rid: RID) 

Creates a new variation existing font which is reusing the same glyph cache and font data. To free the resulting resource, use the free_rid() method.

---

RID create_shaped_text(direction: Direction = 0, orientation: Orientation = 0) 

Creates a new buffer for complex text layout, with the given direction and orientation. To free the resulting buffer, use free_rid() method.

Note: Direction is ignored if server does not support FEATURE_BIDI_LAYOUT feature (supported by TextServerAdvanced).

Note: Orientation is ignored if server does not support FEATURE_VERTICAL_LAYOUT feature (supported by TextServerAdvanced).

---

void draw_hex_code_box(canvas: RID, size: int, pos: Vector2, index: int, color: Color) const 

Draws box displaying character hexadecimal code. Used for replacing missing characters.

---

void font_clear_glyphs(font_rid: RID, size: Vector2i) 

Removes all rendered glyph information from the cache entry.

Note: This function will not remove textures associated with the glyphs, use font_remove_texture() to remove them manually.

---

void font_clear_kerning_map(font_rid: RID, size: int) 

Removes all kerning overrides.

---

void font_clear_size_cache(font_rid: RID) 

Removes all font sizes from the cache entry.

---

void font_clear_system_fallback_cache() 

Frees all automatically loaded system fonts.

---

void font_clear_textures(font_rid: RID, size: Vector2i) 

Removes all textures from font cache entry.

Note: This function will not remove glyphs associated with the texture, use font_remove_glyph() to remove them manually.

---

void font_draw_glyph(font_rid: RID, canvas: RID, size: int, pos: Vector2, index: int, color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) const 

Draws single glyph into a canvas item at the position, using font_rid at the size size. If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

Note: Glyph index is specific to the font, use glyphs indices returned by shaped_text_get_glyphs() or font_get_glyph_index().

Note: If there are pending glyphs to render, calling this function might trigger the texture cache update.

---

void font_draw_glyph_outline(font_rid: RID, canvas: RID, size: int, outline_size: int, pos: Vector2, index: int, color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) const 

Draws single glyph outline of size outline_size into a canvas item at the position, using font_rid at the size size. If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

Note: Glyph index is specific to the font, use glyphs indices returned by shaped_text_get_glyphs() or font_get_glyph_index().

Note: If there are pending glyphs to render, calling this function might trigger the texture cache update.

---

FontAntialiasing font_get_antialiasing(font_rid: RID) const 

Returns font anti-aliasing mode.

---

float font_get_ascent(font_rid: RID, size: int) const 

Returns the font ascent (number of pixels above the baseline).

---

float font_get_baseline_offset(font_rid: RID) const 

Returns extra baseline offset (as a fraction of font height).

---

int font_get_char_from_glyph_index(font_rid: RID, size: int, glyph_index: int) const 

Returns character code associated with glyph_index, or 0 if glyph_index is invalid. See font_get_glyph_index().

---

float font_get_descent(font_rid: RID, size: int) const 

Returns the font descent (number of pixels below the baseline).

---

bool font_get_disable_embedded_bitmaps(font_rid: RID) const 

Returns whether the font's embedded bitmap loading is disabled.

---

float font_get_embolden(font_rid: RID) const 

Returns font embolden strength.

---

int font_get_face_count(font_rid: RID) const 

Returns number of faces in the TrueType / OpenType collection.

---

int font_get_face_index(font_rid: RID) const 

Returns an active face index in the TrueType / OpenType collection.

---

int font_get_fixed_size(font_rid: RID) const 

Returns bitmap font fixed size.

---

FixedSizeScaleMode font_get_fixed_size_scale_mode(font_rid: RID) const 

Returns bitmap font scaling mode.

---

bool font_get_generate_mipmaps(font_rid: RID) const 

Returns true if font texture mipmap generation is enabled.

---

float font_get_global_oversampling() const 

Deprecated: Use Viewport oversampling, or the oversampling argument of the draw_* methods instead.

This method does nothing and always returns 1.0.

---

Vector2 font_get_glyph_advance(font_rid: RID, size: int, glyph: int) const 

Returns glyph advance (offset of the next glyph).

Note: Advance for glyphs outlines is the same as the base glyph advance and is not saved.

---

Dictionary font_get_glyph_contours(font: RID, size: int, index: int) const 

Returns outline contours of the glyph as a Dictionary with the following contents:

points         - PackedVector3Array, containing outline points. x and y are point coordinates. z is the type of the point, using the ContourPointTag values.

contours       - PackedInt32Array, containing indices the end points of each contour.

orientation    - bool, contour orientation. If true, clockwise contours must be filled.

- Two successive CONTOUR_CURVE_TAG_ON points indicate a line segment.
- One CONTOUR_CURVE_TAG_OFF_CONIC point between two CONTOUR_CURVE_TAG_ON points indicates a single conic (quadratic) Bézier arc.
- Two CONTOUR_CURVE_TAG_OFF_CUBIC points between two CONTOUR_CURVE_TAG_ON points indicate a single cubic Bézier arc.
- Two successive CONTOUR_CURVE_TAG_OFF_CONIC points indicate two successive conic (quadratic) Bézier arcs with a virtual CONTOUR_CURVE_TAG_ON point at their middle.
- Each contour is closed. The last point of a contour uses the first point of a contour as its next point, and vice versa. The first point can be CONTOUR_CURVE_TAG_OFF_CONIC point.

---

int font_get_glyph_index(font_rid: RID, size: int, char: int, variation_selector: int) const 

Returns the glyph index of a char, optionally modified by the variation_selector. See font_get_char_from_glyph_index().

---

PackedInt32Array font_get_glyph_list(font_rid: RID, size: Vector2i) const 

Returns list of rendered glyphs in the cache entry.

---

Vector2 font_get_glyph_offset(font_rid: RID, size: Vector2i, glyph: int) const 

Returns glyph offset from the baseline.

---

Vector2 font_get_glyph_size(font_rid: RID, size: Vector2i, glyph: int) const 

Returns size of the glyph.

---

int font_get_glyph_texture_idx(font_rid: RID, size: Vector2i, glyph: int) const 

Returns index of the cache texture containing the glyph.

---

RID font_get_glyph_texture_rid(font_rid: RID, size: Vector2i, glyph: int) const 

Returns resource ID of the cache texture containing the glyph.

Note: If there are pending glyphs to render, calling this function might trigger the texture cache update.

---

Vector2 font_get_glyph_texture_size(font_rid: RID, size: Vector2i, glyph: int) const 

Returns size of the cache texture containing the glyph.

Note: If there are pending glyphs to render, calling this function might trigger the texture cache update.

---

Rect2 font_get_glyph_uv_rect(font_rid: RID, size: Vector2i, glyph: int) const 

Returns rectangle in the cache texture containing the glyph.

---

Hinting font_get_hinting(font_rid: RID) const 

Returns the font hinting mode. Used by dynamic fonts only.

---

bool font_get_keep_rounding_remainders(font_rid: RID) const 

Returns glyph position rounding behavior. If set to true, when aligning glyphs to the pixel boundaries rounding remainders are accumulated to ensure more uniform glyph distribution. This setting has no effect if subpixel positioning is enabled.

---

Vector2 font_get_kerning(font_rid: RID, size: int, glyph_pair: Vector2i) const 

Returns kerning for the pair of glyphs.

---

Array[Vector2i] font_get_kerning_list(font_rid: RID, size: int) const 

Returns list of the kerning overrides.

---

bool font_get_language_support_override(font_rid: RID, language: String) 

Returns true if support override is enabled for the language.

---

PackedStringArray font_get_language_support_overrides(font_rid: RID) 

Returns list of language support overrides.

---

int font_get_msdf_pixel_range(font_rid: RID) const 

Returns the width of the range around the shape between the minimum and maximum representable signed distance.

---

int font_get_msdf_size(font_rid: RID) const 

Returns source font size used to generate MSDF textures.

---

String font_get_name(font_rid: RID) const 

Returns font family name.

---

Dictionary font_get_opentype_feature_overrides(font_rid: RID) const 

Returns font OpenType feature set override.

---

Dictionary font_get_ot_name_strings(font_rid: RID) const 

Returns Dictionary with OpenType font name strings (localized font names, version, description, license information, sample text, etc.).

---

float font_get_oversampling(font_rid: RID) const 

Returns oversampling factor override. If set to a positive value, overrides the oversampling factor of the viewport this font is used in. See Viewport.oversampling. This value doesn't override the oversampling parameter of draw_* methods. Used by dynamic fonts only.

---

PackedColorArray font_get_palette_colors(font_rid: RID, index: int) const 

Returns the array in the predefined color palette at index. Palette contains all colors used to render font glyphs. Each palette has the same number of colors. Colors can be overridden using font_set_palette_custom_colors().

---

int font_get_palette_count(font_rid: RID) const 

Returns the number of predefined color palettes. Palette contains all colors used to render font glyphs. Each palette has the same number of colors.

---

PackedColorArray font_get_palette_custom_colors(font_rid: RID) const 

Returns array of custom colors to override predefined palette.

---

String font_get_palette_name(font_rid: RID, index: int) const 

Returns the name of the predefined color palette at index. Palette contains all colors used to render font glyphs. Each palette has the same number of colors.

---

float font_get_scale(font_rid: RID, size: int) const 

Returns scaling factor of the color bitmap font.

---

bool font_get_script_support_override(font_rid: RID, script: String) 

Returns true if support override is enabled for the script.

---

PackedStringArray font_get_script_support_overrides(font_rid: RID) 

Returns list of script support overrides.

---

Array[Dictionary] font_get_size_cache_info(font_rid: RID) const 

Returns font cache information, each entry contains the following fields: Vector2i size_px - font size in pixels, float viewport_oversampling - viewport oversampling factor, int glyphs - number of rendered glyphs, int textures - number of used textures, int textures_size - size of texture data in bytes.

---

Array[Vector2i] font_get_size_cache_list(font_rid: RID) const 

Returns list of the font sizes in the cache. Each size is Vector2i with font size and outline size.

---

int font_get_spacing(font_rid: RID, spacing: SpacingType) const 

Returns the spacing for spacing in pixels (not relative to the font size).

---

int font_get_stretch(font_rid: RID) const 

Returns font stretch amount, compared to a normal width. A percentage value between 50% and 200%.

---

BitField[FontStyle] font_get_style(font_rid: RID) const 

Returns font style flags.

---

String font_get_style_name(font_rid: RID) const 

Returns font style name.

---

SubpixelPositioning font_get_subpixel_positioning(font_rid: RID) const 

Returns font subpixel glyph positioning mode.

---

String font_get_supported_chars(font_rid: RID) const 

Returns a string containing all the characters available in the font.

---

PackedInt32Array font_get_supported_glyphs(font_rid: RID) const 

Returns an array containing all glyph indices in the font.

---

int font_get_texture_count(font_rid: RID, size: Vector2i) const 

Returns number of textures used by font cache entry.

---

Image font_get_texture_image(font_rid: RID, size: Vector2i, texture_index: int) const 

Returns font cache texture image data.

---

PackedInt32Array font_get_texture_offsets(font_rid: RID, size: Vector2i, texture_index: int) const 

Returns array containing glyph packing data.

---

Transform2D font_get_transform(font_rid: RID) const 

Returns 2D transform applied to the font outlines.

---

float font_get_underline_position(font_rid: RID, size: int) const 

Returns pixel offset of the underline below the baseline.

---

float font_get_underline_thickness(font_rid: RID, size: int) const 

Returns thickness of the underline in pixels.

---

int font_get_used_palette(font_rid: RID) const 

Returns used palette index.

---

Dictionary font_get_variation_coordinates(font_rid: RID) const 

Returns variation coordinates for the specified font cache entry. See font_supported_variation_list() for more info.

---

int font_get_weight(font_rid: RID) const 

Returns weight (boldness) of the font. A value in the 100...999 range, normal font weight is 400, bold font weight is 700.

---

bool font_has_char(font_rid: RID, char: int) const 

Returns true if a Unicode char is available in the font.

---

bool font_is_allow_system_fallback(font_rid: RID) const 

Returns true if system fonts can be automatically used as fallbacks.

---

bool font_is_force_autohinter(font_rid: RID) const 

Returns true if auto-hinting is supported and preferred over font built-in hinting. Used by dynamic fonts only.

---

bool font_is_language_supported(font_rid: RID, language: String) const 

Returns true if the font supports the given language (as a ISO 639 [https://en.wikipedia.org/wiki/ISO_639-1] code).

---

bool font_is_modulate_color_glyphs(font_rid: RID) const 

Returns true if color modulation is applied when drawing the font's colored glyphs.

---

bool font_is_multichannel_signed_distance_field(font_rid: RID) const 

Returns true if glyphs of all sizes are rendered using single multichannel signed distance field generated from the dynamic font vector data.

---

bool font_is_script_supported(font_rid: RID, script: String) const 

Returns true if the font supports the given script (as a ISO 15924 [https://en.wikipedia.org/wiki/ISO_15924] code).

---

void font_remove_glyph(font_rid: RID, size: Vector2i, glyph: int) 

Removes specified rendered glyph information from the cache entry.

Note: This function will not remove textures associated with the glyphs, use font_remove_texture() to remove them manually.

---

void font_remove_kerning(font_rid: RID, size: int, glyph_pair: Vector2i) 

Removes kerning override for the pair of glyphs.

---

void font_remove_language_support_override(font_rid: RID, language: String) 

Remove language support override.

---

void font_remove_script_support_override(font_rid: RID, script: String) 

Removes script support override.

---

void font_remove_size_cache(font_rid: RID, size: Vector2i) 

Removes specified font size from the cache entry.

---

void font_remove_texture(font_rid: RID, size: Vector2i, texture_index: int) 

Removes specified texture from the cache entry.

Note: This function will not remove glyphs associated with the texture, remove them manually, using font_remove_glyph().

---

void font_render_glyph(font_rid: RID, size: Vector2i, index: int) 

Renders specified glyph to the font cache texture.

---

void font_render_range(font_rid: RID, size: Vector2i, start: int, end: int) 

Renders the range of characters to the font cache texture.

---

void font_set_allow_system_fallback(font_rid: RID, allow_system_fallback: bool) 

If set to true, system fonts can be automatically used as fallbacks.

---

void font_set_antialiasing(font_rid: RID, antialiasing: FontAntialiasing) 

Sets font anti-aliasing mode.

---

void font_set_ascent(font_rid: RID, size: int, ascent: float) 

Sets the font ascent (number of pixels above the baseline).

---

void font_set_baseline_offset(font_rid: RID, baseline_offset: float) 

Sets extra baseline offset (as a fraction of font height).

---

void font_set_data(font_rid: RID, data: PackedByteArray) 

Sets font source data, e.g contents of the dynamic font source file.

---

void font_set_descent(font_rid: RID, size: int, descent: float) 

Sets the font descent (number of pixels below the baseline).

---

void font_set_disable_embedded_bitmaps(font_rid: RID, disable_embedded_bitmaps: bool) 

If set to true, embedded font bitmap loading is disabled (bitmap-only and color fonts ignore this property).

---

void font_set_embolden(font_rid: RID, strength: float) 

Sets font embolden strength. If strength is not equal to zero, emboldens the font outlines. Negative values reduce the outline thickness.

---

void font_set_face_index(font_rid: RID, face_index: int) 

Sets an active face index in the TrueType / OpenType collection.

---

void font_set_fixed_size(font_rid: RID, fixed_size: int) 

Sets bitmap font fixed size. If set to value greater than zero, same cache entry will be used for all font sizes.

---

void font_set_fixed_size_scale_mode(font_rid: RID, fixed_size_scale_mode: FixedSizeScaleMode) 

Sets bitmap font scaling mode. This property is used only if fixed_size is greater than zero.

---

void font_set_force_autohinter(font_rid: RID, force_autohinter: bool) 

If set to true auto-hinting is preferred over font built-in hinting.

---

void font_set_generate_mipmaps(font_rid: RID, generate_mipmaps: bool) 

If set to true font texture mipmap generation is enabled.

---

void font_set_global_oversampling(oversampling: float) 

Deprecated: Use Viewport oversampling, or the oversampling argument of the draw_* methods instead.

This method does nothing.

---

void font_set_glyph_advance(font_rid: RID, size: int, glyph: int, advance: Vector2) 

Sets glyph advance (offset of the next glyph).

Note: Advance for glyphs outlines is the same as the base glyph advance and is not saved.

---

void font_set_glyph_offset(font_rid: RID, size: Vector2i, glyph: int, offset: Vector2) 

Sets glyph offset from the baseline.

---

void font_set_glyph_size(font_rid: RID, size: Vector2i, glyph: int, gl_size: Vector2) 

Sets size of the glyph.

---

void font_set_glyph_texture_idx(font_rid: RID, size: Vector2i, glyph: int, texture_idx: int) 

Sets index of the cache texture containing the glyph.

---

void font_set_glyph_uv_rect(font_rid: RID, size: Vector2i, glyph: int, uv_rect: Rect2) 

Sets rectangle in the cache texture containing the glyph.

---

void font_set_hinting(font_rid: RID, hinting: Hinting) 

Sets font hinting mode. Used by dynamic fonts only.

---

void font_set_keep_rounding_remainders(font_rid: RID, keep_rounding_remainders: bool) 

Sets glyph position rounding behavior. If set to true, when aligning glyphs to the pixel boundaries rounding remainders are accumulated to ensure more uniform glyph distribution. This setting has no effect if subpixel positioning is enabled.

---

void font_set_kerning(font_rid: RID, size: int, glyph_pair: Vector2i, kerning: Vector2) 

Sets kerning for the pair of glyphs.

---

void font_set_language_support_override(font_rid: RID, language: String, supported: bool) 

Adds override for font_is_language_supported().

---

void font_set_modulate_color_glyphs(font_rid: RID, modulate: bool) 

If set to true, color modulation is applied when drawing colored glyphs, otherwise it's applied to the monochrome glyphs only.

---

void font_set_msdf_pixel_range(font_rid: RID, msdf_pixel_range: int) 

Sets the width of the range around the shape between the minimum and maximum representable signed distance.

---

void font_set_msdf_size(font_rid: RID, msdf_size: int) 

Sets source font size used to generate MSDF textures.

---

void font_set_multichannel_signed_distance_field(font_rid: RID, msdf: bool) 

If set to true, glyphs of all sizes are rendered using single multichannel signed distance field generated from the dynamic font vector data. MSDF rendering allows displaying the font at any scaling factor without blurriness, and without incurring a CPU cost when the font size changes (since the font no longer needs to be rasterized on the CPU). As a downside, font hinting is not available with MSDF. The lack of font hinting may result in less crisp and less readable fonts at small sizes.

Note: MSDF font rendering does not render glyphs with overlapping shapes correctly. Overlapping shapes are not valid per the OpenType standard, but are still commonly found in many font files, especially those converted by Google Fonts. To avoid issues with overlapping glyphs, consider downloading the font file directly from the type foundry instead of relying on Google Fonts.

---

void font_set_name(font_rid: RID, name: String) 

Sets the font family name.

---

void font_set_opentype_feature_overrides(font_rid: RID, overrides: Dictionary) 

Sets font OpenType feature set override.

---

void font_set_oversampling(font_rid: RID, oversampling: float) 

If set to a positive value, overrides the oversampling factor of the viewport this font is used in. See Viewport.oversampling. This value doesn't override the oversampling parameter of draw_* methods. Used by dynamic fonts only.

---

void font_set_palette_custom_colors(font_rid: RID, colors: PackedColorArray) 

Sets array of custom colors to override predefined palette. Set to empty array to reset overrides. Use Color(0, 0, 0, 0), to keep predefined palette color at specific position.

---

void font_set_scale(font_rid: RID, size: int, scale: float) 

Sets scaling factor of the color bitmap font.

---

void font_set_script_support_override(font_rid: RID, script: String, supported: bool) 

Adds override for font_is_script_supported().

---

void font_set_spacing(font_rid: RID, spacing: SpacingType, value: int) 

Sets the spacing for spacing to value in pixels (not relative to the font size).

---

void font_set_stretch(font_rid: RID, weight: int) 

Sets font stretch amount, compared to a normal width. A percentage value between 50% and 200%.

Note: This value is used for font matching only and will not affect font rendering. Use font_set_face_index(), font_set_variation_coordinates(), or font_set_transform() instead.

---

void font_set_style(font_rid: RID, style: BitField[FontStyle]) 

Sets the font style flags.

Note: This value is used for font matching only and will not affect font rendering. Use font_set_face_index(), font_set_variation_coordinates(), font_set_embolden(), or font_set_transform() instead.

---

void font_set_style_name(font_rid: RID, name: String) 

Sets the font style name.

---

void font_set_subpixel_positioning(font_rid: RID, subpixel_positioning: SubpixelPositioning) 

Sets font subpixel glyph positioning mode.

---

void font_set_texture_image(font_rid: RID, size: Vector2i, texture_index: int, image: Image) 

Sets font cache texture image data.

---

void font_set_texture_offsets(font_rid: RID, size: Vector2i, texture_index: int, offset: PackedInt32Array) 

Sets array containing glyph packing data.

---

void font_set_transform(font_rid: RID, transform: Transform2D) 

Sets 2D transform, applied to the font outlines, can be used for slanting, flipping, and rotating glyphs.

For example, to simulate italic typeface by slanting, apply the following transform Transform2D(1.0, slant, 0.0, 1.0, 0.0, 0.0).

---

void font_set_underline_position(font_rid: RID, size: int, underline_position: float) 

Sets pixel offset of the underline below the baseline.

---

void font_set_underline_thickness(font_rid: RID, size: int, underline_thickness: float) 

Sets thickness of the underline in pixels.

---

void font_set_used_palette(font_rid: RID, index: int) 

Sets used palette index.

---

void font_set_variation_coordinates(font_rid: RID, variation_coordinates: Dictionary) 

Sets variation coordinates for the specified font cache entry. See font_supported_variation_list() for more info.

---

void font_set_weight(font_rid: RID, weight: int) 

Sets weight (boldness) of the font. A value in the 100...999 range, normal font weight is 400, bold font weight is 700.

Note: This value is used for font matching only and will not affect font rendering. Use font_set_face_index(), font_set_variation_coordinates(), or font_set_embolden() instead.

---

Dictionary font_supported_feature_list(font_rid: RID) const 

Returns the dictionary of the supported OpenType features.

---

Dictionary font_supported_variation_list(font_rid: RID) const 

Returns the dictionary of the supported OpenType variation coordinates.

---

String format_number(number: String, language: String = "") const 

Deprecated: Use TranslationServer.format_number() instead.

Converts a number from Western Arabic (0..9) to the numeral system used in the given language.

If language is an empty string, the active locale will be used.

---

void free_rid(rid: RID) 

Frees an object created by this TextServer.

---

int get_features() const 

Returns text server features, see Feature.

---

Vector2 get_hex_code_box_size(size: int, index: int) const 

Returns size of the replacement character (box with character hexadecimal code that is drawn in place of invalid characters).

---

String get_name() const 

Returns the name of the server interface.

---

PackedByteArray get_support_data() const 

Returns default TextServer database (e.g. ICU break iterators and dictionaries).

---

String get_support_data_filename() const 

Returns default TextServer database (e.g. ICU break iterators and dictionaries) filename.

---

String get_support_data_info() const 

Returns TextServer database (e.g. ICU break iterators and dictionaries) description.

---

bool has(rid: RID) 

Returns true if rid is valid resource owned by this text server.

---

bool has_feature(feature: Feature) const 

Returns true if the server supports a feature.

---

int is_confusable(string: String, dict: PackedStringArray) const 

Returns index of the first string in dict which is visually confusable with the string, or -1 if none is found.

Note: This method doesn't detect invisible characters, for spoof detection use it in combination with spoof_check().

Note: Always returns -1 if the server does not support the FEATURE_UNICODE_SECURITY feature.

---

bool is_locale_right_to_left(locale: String) const 

Returns true if locale is right-to-left.

---

bool is_locale_using_support_data(locale: String) const 

Returns true if the locale requires text server support data for line/word breaking.

---

bool is_valid_identifier(string: String) const 

Returns true if string is a valid identifier.

If the text server supports the FEATURE_UNICODE_IDENTIFIERS feature, a valid identifier must:

- Conform to normalization form C.
- Begin with a Unicode character of class XID_Start or "_".
- May contain Unicode characters of class XID_Continue in the other positions.
- Use UAX #31 recommended scripts only (mixed scripts are allowed).

If the FEATURE_UNICODE_IDENTIFIERS feature is not supported, a valid identifier must:

- Begin with a Unicode character of class XID_Start or "_".
- May contain Unicode characters of class XID_Continue in the other positions.

---

bool is_valid_letter(unicode: int) const 

Returns true if the given code point is a valid letter, i.e. it belongs to the Unicode category "L".

---

bool load_support_data(filename: String) 

Loads optional TextServer database (e.g. ICU break iterators and dictionaries).

Note: This function should be called before any other TextServer functions used, otherwise it won't have any effect.

---

int name_to_tag(name: String) const 

Converts the given readable name of a feature, variation, script, or language to an OpenType tag.

---

String parse_number(number: String, language: String = "") const 

Deprecated: Use TranslationServer.parse_number() instead.

Converts number from the numeral system used in the given language to Western Arabic (0..9).

If language is an empty string, the active locale will be used.

---

Array[Vector3i] parse_structured_text(parser_type: StructuredTextParser, args: Array, text: String) const 

Default implementation of the BiDi algorithm override function.

---

String percent_sign(language: String = "") const 

Deprecated: Use TranslationServer.get_percent_sign() instead.

Returns the percent sign used in the given language.

If language is an empty string, the active locale will be used.

---

bool save_support_data(filename: String) const 

Saves optional TextServer database (e.g. ICU break iterators and dictionaries) to the file.

Note: This function is used by during project export, to include TextServer database.

---

int shaped_get_run_count(shaped: RID) const 

Returns the number of uniform text runs in the buffer.

---

Direction shaped_get_run_direction(shaped: RID, index: int) const 

Returns the direction of the index text run (in visual order).

---

RID shaped_get_run_font_rid(shaped: RID, index: int) const 

Returns the font RID of the index text run (in visual order).

---

int shaped_get_run_font_size(shaped: RID, index: int) const 

Returns the font size of the index text run (in visual order).

---

Vector2i shaped_get_run_glyph_range(shaped: RID, index: int) const 

Returns the glyph range of the index text run (in visual order).

---

String shaped_get_run_language(shaped: RID, index: int) const 

Returns the language of the index text run (in visual order).

---

Variant shaped_get_run_object(shaped: RID, index: int) const 

Returns the embedded object of the index text run (in visual order).

---

Vector2i shaped_get_run_range(shaped: RID, index: int) const 

Returns the source text range of the index text run (in visual order).

---

String shaped_get_run_text(shaped: RID, index: int) const 

Returns the source text of the index text run (in visual order).

---

int shaped_get_span_count(shaped: RID) const 

Returns number of text spans added using shaped_text_add_string() or shaped_text_add_object().

---

Variant shaped_get_span_embedded_object(shaped: RID, index: int) const 

Returns text embedded object key.

---

Variant shaped_get_span_meta(shaped: RID, index: int) const 

Returns text span metadata.

---

Variant shaped_get_span_object(shaped: RID, index: int) const 

Returns the text span embedded object key.

---

String shaped_get_span_text(shaped: RID, index: int) const 

Returns the text span source text.

---

String shaped_get_text(shaped: RID) const 

Returns the text buffer source text, including object replacement characters.

---

void shaped_set_span_update_font(shaped: RID, index: int, fonts: Array[RID], size: int, opentype_features: Dictionary = {}) 

Changes text span font, font size, and OpenType features, without changing the text.

---

bool shaped_text_add_object(shaped: RID, key: Variant, size: Vector2, inline_align: InlineAlignment = 5, length: int = 1, baseline: float = 0.0) 

Adds inline object to the text buffer, key must be unique. In the text, object is represented as length object replacement characters.

---

bool shaped_text_add_string(shaped: RID, text: String, fonts: Array[RID], size: int, opentype_features: Dictionary = {}, language: String = "", meta: Variant = null) 

Adds text span and font to draw it to the text buffer.

---

void shaped_text_clear(rid: RID) 

Clears text buffer (removes text and inline objects).

---

int shaped_text_closest_character_pos(shaped: RID, pos: int) const 

Returns composite character position closest to the pos.

---

void shaped_text_draw(shaped: RID, canvas: RID, pos: Vector2, clip_l: float = -1, clip_r: float = -1, color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) const 

Draw shaped text into a canvas item at a given position, with color. pos specifies the leftmost point of the baseline (for horizontal layout) or topmost point of the baseline (for vertical layout). If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

clip_l and clip_r are offsets relative to pos, going to the right in horizontal layout and downward in vertical layout. If clip_l is not negative, glyphs starting before the offset are clipped. If clip_r is not negative, glyphs ending after the offset are clipped.

---

void shaped_text_draw_outline(shaped: RID, canvas: RID, pos: Vector2, clip_l: float = -1, clip_r: float = -1, outline_size: int = 1, color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) const 

Draw the outline of the shaped text into a canvas item at a given position, with color. pos specifies the leftmost point of the baseline (for horizontal layout) or topmost point of the baseline (for vertical layout). If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

clip_l and clip_r are offsets relative to pos, going to the right in horizontal layout and downward in vertical layout. If clip_l is not negative, glyphs starting before the offset are clipped. If clip_r is not negative, glyphs ending after the offset are clipped.

---

RID shaped_text_duplicate(rid: RID) 

Duplicates shaped text buffer.

---

float shaped_text_fit_to_width(shaped: RID, width: float, justification_flags: BitField[JustificationFlag] = 3) 

Adjusts text width to fit to specified width, returns new text width.

---

float shaped_text_get_ascent(shaped: RID) const 

Returns the text ascent (number of pixels above the baseline for horizontal layout or to the left of baseline for vertical).

Note: Overall ascent can be higher than font ascent, if some glyphs are displaced from the baseline.

---

Dictionary shaped_text_get_carets(shaped: RID, position: int) const 

Returns shapes of the carets corresponding to the character offset position in the text. Returned caret shape is 1 pixel wide rectangle.

---

PackedInt32Array shaped_text_get_character_breaks(shaped: RID) const 

Returns array of the composite character boundaries.

---

int shaped_text_get_custom_ellipsis(shaped: RID) const 

Returns ellipsis character used for text clipping.

---

String shaped_text_get_custom_punctuation(shaped: RID) const 

Returns custom punctuation character list, used for word breaking. If set to empty string, server defaults are used.

---

float shaped_text_get_descent(shaped: RID) const 

Returns the text descent (number of pixels below the baseline for horizontal layout or to the right of baseline for vertical).

Note: Overall descent can be higher than font descent, if some glyphs are displaced from the baseline.

---

Direction shaped_text_get_direction(shaped: RID) const 

Returns direction of the text.

---

Direction shaped_text_get_dominant_direction_in_range(shaped: RID, start: int, end: int) const 

Returns dominant direction of in the range of text.

---

int shaped_text_get_ellipsis_glyph_count(shaped: RID) const 

Returns number of glyphs in the ellipsis.

---

Array[Dictionary] shaped_text_get_ellipsis_glyphs(shaped: RID) const 

Returns array of the glyphs in the ellipsis.

---

int shaped_text_get_ellipsis_pos(shaped: RID) const 

Returns position of the ellipsis.

---

int shaped_text_get_glyph_count(shaped: RID) const 

Returns number of glyphs in the buffer.

---

Array[Dictionary] shaped_text_get_glyphs(shaped: RID) const 

Returns an array of glyphs in the visual order.

---

Vector2 shaped_text_get_grapheme_bounds(shaped: RID, pos: int) const 

Returns composite character's bounds as offsets from the start of the line.

---

Direction shaped_text_get_inferred_direction(shaped: RID) const 

Returns direction of the text, inferred by the BiDi algorithm.

---

PackedInt32Array shaped_text_get_line_breaks(shaped: RID, width: float, start: int = 0, break_flags: BitField[LineBreakFlag] = 3) const 

Breaks text to the lines and returns character ranges for each line.

---

PackedInt32Array shaped_text_get_line_breaks_adv(shaped: RID, width: PackedFloat32Array, start: int = 0, once: bool = true, break_flags: BitField[LineBreakFlag] = 3) const 

Breaks text to the lines and columns. Returns character ranges for each segment.

---

int shaped_text_get_object_glyph(shaped: RID, key: Variant) const 

Returns the glyph index of the inline object.

---

Vector2i shaped_text_get_object_range(shaped: RID, key: Variant) const 

Returns the character range of the inline object.

---

Rect2 shaped_text_get_object_rect(shaped: RID, key: Variant) const 

Returns bounding rectangle of the inline object.

---

Array shaped_text_get_objects(shaped: RID) const 

Returns array of inline objects.

---

Orientation shaped_text_get_orientation(shaped: RID) const 

Returns text orientation.

---

RID shaped_text_get_parent(shaped: RID) const 

Returns the parent buffer from which the substring originates.

---

bool shaped_text_get_preserve_control(shaped: RID) const 

Returns true if text buffer is configured to display control characters.

---

bool shaped_text_get_preserve_invalid(shaped: RID) const 

Returns true if text buffer is configured to display hexadecimal codes in place of invalid characters.

Note: If set to false, nothing is displayed in place of invalid characters.

---

Vector2i shaped_text_get_range(shaped: RID) const 

Returns substring buffer character range in the parent buffer.

---

PackedVector2Array shaped_text_get_selection(shaped: RID, start: int, end: int) const 

Returns selection rectangles for the specified character range.

---

Vector2 shaped_text_get_size(shaped: RID) const 

Returns size of the text.

---

int shaped_text_get_spacing(shaped: RID, spacing: SpacingType) const 

Returns extra spacing added between glyphs or lines in pixels.

---

int shaped_text_get_trim_pos(shaped: RID) const 

Returns the position of the overrun trim.

---

float shaped_text_get_underline_position(shaped: RID) const 

Returns pixel offset of the underline below the baseline.

---

float shaped_text_get_underline_thickness(shaped: RID) const 

Returns thickness of the underline.

---

float shaped_text_get_width(shaped: RID) const 

Returns width (for horizontal layout) or height (for vertical) of the text.

---

PackedInt32Array shaped_text_get_word_breaks(shaped: RID, grapheme_flags: BitField[GraphemeFlag] = 264, skip_grapheme_flags: BitField[GraphemeFlag] = 4) const 

Breaks text into words and returns array of character ranges. Use grapheme_flags to set what characters are used for breaking.

---

bool shaped_text_has_object(shaped: RID, key: Variant) const 

Returns true if an object with key is embedded in this shaped text buffer.

---

bool shaped_text_has_visible_chars(shaped: RID) const 

Returns true if text buffer contains any visible characters.

---

int shaped_text_hit_test_grapheme(shaped: RID, coords: float) const 

Returns grapheme index at the specified pixel offset at the baseline, or -1 if none is found.

---

int shaped_text_hit_test_position(shaped: RID, coords: float) const 

Returns caret character offset at the specified pixel offset at the baseline. This function always returns a valid position.

---

bool shaped_text_is_ready(shaped: RID) const 

Returns true if buffer is successfully shaped.

---

int shaped_text_next_character_pos(shaped: RID, pos: int) const 

Returns composite character end position closest to the pos.

---

int shaped_text_next_grapheme_pos(shaped: RID, pos: int) const 

Returns grapheme end position closest to the pos.

---

void shaped_text_overrun_trim_to_width(shaped: RID, width: float = 0, overrun_trim_flags: BitField[TextOverrunFlag] = 0) 

Trims text if it exceeds the given width.

---

int shaped_text_prev_character_pos(shaped: RID, pos: int) const 

Returns composite character start position closest to the pos.

---

int shaped_text_prev_grapheme_pos(shaped: RID, pos: int) const 

Returns grapheme start position closest to the pos.

---

bool shaped_text_resize_object(shaped: RID, key: Variant, size: Vector2, inline_align: InlineAlignment = 5, baseline: float = 0.0) 

Sets new size and alignment of embedded object.

---

void shaped_text_set_bidi_override(shaped: RID, override: Array) 

Overrides BiDi for the structured text.

Override ranges should cover full source text without overlaps. BiDi algorithm will be used on each range separately.

---

void shaped_text_set_custom_ellipsis(shaped: RID, char: int) 

Sets ellipsis character used for text clipping.

---

void shaped_text_set_custom_punctuation(shaped: RID, punct: String) 

Sets custom punctuation character list, used for word breaking. If set to empty string, server defaults are used.

---

void shaped_text_set_direction(shaped: RID, direction: Direction = 0) 

Sets desired text direction. If set to DIRECTION_AUTO, direction will be detected based on the buffer contents and current locale.

Note: Direction is ignored if server does not support FEATURE_BIDI_LAYOUT feature (supported by TextServerAdvanced).

---

void shaped_text_set_orientation(shaped: RID, orientation: Orientation = 0) 

Sets desired text orientation.

Note: Orientation is ignored if server does not support FEATURE_VERTICAL_LAYOUT feature (supported by TextServerAdvanced).

---

void shaped_text_set_preserve_control(shaped: RID, enabled: bool) 

If set to true text buffer will display control characters.

---

void shaped_text_set_preserve_invalid(shaped: RID, enabled: bool) 

If set to true text buffer will display invalid characters as hexadecimal codes, otherwise nothing is displayed.

---

void shaped_text_set_spacing(shaped: RID, spacing: SpacingType, value: int) 

Sets extra spacing added between glyphs or lines in pixels.

---

bool shaped_text_shape(shaped: RID) 

Shapes buffer if it's not shaped. Returns true if the string is shaped successfully.

Note: It is not necessary to call this function manually, buffer will be shaped automatically as soon as any of its output data is requested.

---

Array[Dictionary] shaped_text_sort_logical(shaped: RID) 

Returns text glyphs in the logical order.

---

RID shaped_text_substr(shaped: RID, start: int, length: int) const 

Returns text buffer for the substring of the text in the shaped text buffer (including inline objects).

---

float shaped_text_tab_align(shaped: RID, tab_stops: PackedFloat32Array) 

Aligns shaped text to the given tab-stops.

---

bool spoof_check(string: String) const 

Returns true if string is likely to be an attempt at confusing the reader.

Note: Always returns false if the server does not support the FEATURE_UNICODE_SECURITY feature.

---

PackedInt32Array string_get_character_breaks(string: String, language: String = "") const 

Returns array of the composite character boundaries.

```gdscript
var ts = TextServerManager.get_primary_interface()
print(ts.string_get_character_breaks("Test ❤️‍🔥 Test")) # Prints [1, 2, 3, 4, 5, 9, 10, 11, 12, 13, 14]
```

---

PackedInt32Array string_get_word_breaks(string: String, language: String = "", chars_per_line: int = 0) const 

Returns an array of the word break boundaries. Elements in the returned array are the offsets of the start and end of words. Therefore the length of the array is always even.

When chars_per_line is greater than zero, line break boundaries are returned instead.

```gdscript
var ts = TextServerManager.get_primary_interface()
# Corresponds to the substrings "The", "Godot", "Engine", and "4".
print(ts.string_get_word_breaks("The Godot Engine, 4")) # Prints [0, 3, 4, 9, 10, 16, 18, 19]
# Corresponds to the substrings "The", "Godot", "Engin", and "e, 4".
print(ts.string_get_word_breaks("The Godot Engine, 4", "en", 5)) # Prints [0, 3, 4, 9, 10, 15, 15, 19]
# Corresponds to the substrings "The Godot" and "Engine, 4".
print(ts.string_get_word_breaks("The Godot Engine, 4", "en", 10)) # Prints [0, 9, 10, 19]
```

---

String string_to_lower(string: String, language: String = "") const 

Returns the string converted to lowercase.

Note: Casing is locale dependent and context sensitive if server support FEATURE_CONTEXT_SENSITIVE_CASE_CONVERSION feature (supported by TextServerAdvanced).

Note: The result may be longer or shorter than the original.

---

String string_to_title(string: String, language: String = "") const 

Returns the string converted to Title Case.

Note: Casing is locale dependent and context sensitive if server support FEATURE_CONTEXT_SENSITIVE_CASE_CONVERSION feature (supported by TextServerAdvanced).

Note: The result may be longer or shorter than the original.

---

String string_to_upper(string: String, language: String = "") const 

Returns the string converted to UPPERCASE.

Note: Casing is locale dependent and context sensitive if server support FEATURE_CONTEXT_SENSITIVE_CASE_CONVERSION feature (supported by TextServerAdvanced).

Note: The result may be longer or shorter than the original.

---

String strip_diacritics(string: String) const 

Strips diacritics from the string.

Note: The result may be longer or shorter than the original.

---

String tag_to_name(tag: int) const 

Converts the given OpenType tag to the readable name of a feature, variation, script, or language.
