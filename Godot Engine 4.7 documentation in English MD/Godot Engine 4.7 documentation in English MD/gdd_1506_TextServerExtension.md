# TextServerExtension

Inherits: TextServer < RefCounted < Object

Inherited By: TextServerAdvanced, TextServerDummy, TextServerFallback

Base class for custom TextServer implementations (plugins).

## Description

External TextServer implementations should inherit from this class.

## Methods

void | _cleanup() virtual
RID | _create_font() virtual required
RID | _create_font_linked_variation(font_rid: RID) virtual
RID | _create_shaped_text(direction: Direction, orientation: Orientation) virtual required
void | _draw_hex_code_box(canvas: RID, size: int, pos: Vector2, index: int, color: Color) virtual const
void | _font_clear_glyphs(font_rid: RID, size: Vector2i) virtual required
void | _font_clear_kerning_map(font_rid: RID, size: int) virtual
void | _font_clear_size_cache(font_rid: RID) virtual required
void | _font_clear_system_fallback_cache() virtual
void | _font_clear_textures(font_rid: RID, size: Vector2i) virtual required
void | _font_draw_glyph(font_rid: RID, canvas: RID, size: int, pos: Vector2, index: int, color: Color, oversampling: float) virtual required const
void | _font_draw_glyph_outline(font_rid: RID, canvas: RID, size: int, outline_size: int, pos: Vector2, index: int, color: Color, oversampling: float) virtual required const
FontAntialiasing | _font_get_antialiasing(font_rid: RID) virtual const
float | _font_get_ascent(font_rid: RID, size: int) virtual required const
float | _font_get_baseline_offset(font_rid: RID) virtual const
int | _font_get_char_from_glyph_index(font_rid: RID, size: int, glyph_index: int) virtual required const
float | _font_get_descent(font_rid: RID, size: int) virtual required const
bool | _font_get_disable_embedded_bitmaps(font_rid: RID) virtual const
float | _font_get_embolden(font_rid: RID) virtual const
int | _font_get_face_count(font_rid: RID) virtual const
int | _font_get_face_index(font_rid: RID) virtual const
int | _font_get_fixed_size(font_rid: RID) virtual required const
FixedSizeScaleMode | _font_get_fixed_size_scale_mode(font_rid: RID) virtual required const
bool | _font_get_generate_mipmaps(font_rid: RID) virtual const
float | _font_get_global_oversampling() virtual const
Vector2 | _font_get_glyph_advance(font_rid: RID, size: int, glyph: int) virtual required const
Dictionary | _font_get_glyph_contours(font_rid: RID, size: int, index: int) virtual const
int | _font_get_glyph_index(font_rid: RID, size: int, char: int, variation_selector: int) virtual required const
PackedInt32Array | _font_get_glyph_list(font_rid: RID, size: Vector2i) virtual required const
Vector2 | _font_get_glyph_offset(font_rid: RID, size: Vector2i, glyph: int) virtual required const
Vector2 | _font_get_glyph_size(font_rid: RID, size: Vector2i, glyph: int) virtual required const
int | _font_get_glyph_texture_idx(font_rid: RID, size: Vector2i, glyph: int) virtual required const
RID | _font_get_glyph_texture_rid(font_rid: RID, size: Vector2i, glyph: int) virtual required const
Vector2 | _font_get_glyph_texture_size(font_rid: RID, size: Vector2i, glyph: int) virtual required const
Rect2 | _font_get_glyph_uv_rect(font_rid: RID, size: Vector2i, glyph: int) virtual required const
Hinting | _font_get_hinting(font_rid: RID) virtual const
bool | _font_get_keep_rounding_remainders(font_rid: RID) virtual const
Vector2 | _font_get_kerning(font_rid: RID, size: int, glyph_pair: Vector2i) virtual const
Array[Vector2i] | _font_get_kerning_list(font_rid: RID, size: int) virtual const
bool | _font_get_language_support_override(font_rid: RID, language: String) virtual
PackedStringArray | _font_get_language_support_overrides(font_rid: RID) virtual
int | _font_get_msdf_pixel_range(font_rid: RID) virtual const
int | _font_get_msdf_size(font_rid: RID) virtual const
String | _font_get_name(font_rid: RID) virtual const
Dictionary | _font_get_opentype_feature_overrides(font_rid: RID) virtual const
Dictionary | _font_get_ot_name_strings(font_rid: RID) virtual const
float | _font_get_oversampling(font_rid: RID) virtual const
PackedColorArray | _font_get_palette_colors(font_rid: RID, index: int) virtual const
int | _font_get_palette_count(font_rid: RID) virtual const
PackedColorArray | _font_get_palette_custom_colors(font_rid: RID) virtual const
String | _font_get_palette_name(font_rid: RID, index: int) virtual const
float | _font_get_scale(font_rid: RID, size: int) virtual required const
bool | _font_get_script_support_override(font_rid: RID, script: String) virtual
PackedStringArray | _font_get_script_support_overrides(font_rid: RID) virtual
Array[Dictionary] | _font_get_size_cache_info(font_rid: RID) virtual const
Array[Vector2i] | _font_get_size_cache_list(font_rid: RID) virtual required const
int | _font_get_spacing(font_rid: RID, spacing: SpacingType) virtual const
int | _font_get_stretch(font_rid: RID) virtual const
BitField[FontStyle] | _font_get_style(font_rid: RID) virtual const
String | _font_get_style_name(font_rid: RID) virtual const
SubpixelPositioning | _font_get_subpixel_positioning(font_rid: RID) virtual const
String | _font_get_supported_chars(font_rid: RID) virtual required const
PackedInt32Array | _font_get_supported_glyphs(font_rid: RID) virtual required const
int | _font_get_texture_count(font_rid: RID, size: Vector2i) virtual required const
Image | _font_get_texture_image(font_rid: RID, size: Vector2i, texture_index: int) virtual required const
PackedInt32Array | _font_get_texture_offsets(font_rid: RID, size: Vector2i, texture_index: int) virtual const
Transform2D | _font_get_transform(font_rid: RID) virtual const
float | _font_get_underline_position(font_rid: RID, size: int) virtual required const
float | _font_get_underline_thickness(font_rid: RID, size: int) virtual required const
int | _font_get_used_palette(font_rid: RID) virtual const
Dictionary | _font_get_variation_coordinates(font_rid: RID) virtual const
int | _font_get_weight(font_rid: RID) virtual const
bool | _font_has_char(font_rid: RID, char: int) virtual required const
bool | _font_is_allow_system_fallback(font_rid: RID) virtual const
bool | _font_is_force_autohinter(font_rid: RID) virtual const
bool | _font_is_language_supported(font_rid: RID, language: String) virtual const
bool | _font_is_modulate_color_glyphs(font_rid: RID) virtual const
bool | _font_is_multichannel_signed_distance_field(font_rid: RID) virtual const
bool | _font_is_script_supported(font_rid: RID, script: String) virtual const
void | _font_remove_glyph(font_rid: RID, size: Vector2i, glyph: int) virtual required
void | _font_remove_kerning(font_rid: RID, size: int, glyph_pair: Vector2i) virtual
void | _font_remove_language_support_override(font_rid: RID, language: String) virtual
void | _font_remove_script_support_override(font_rid: RID, script: String) virtual
void | _font_remove_size_cache(font_rid: RID, size: Vector2i) virtual required
void | _font_remove_texture(font_rid: RID, size: Vector2i, texture_index: int) virtual required
void | _font_render_glyph(font_rid: RID, size: Vector2i, index: int) virtual
void | _font_render_range(font_rid: RID, size: Vector2i, start: int, end: int) virtual
void | _font_set_allow_system_fallback(font_rid: RID, allow_system_fallback: bool) virtual
void | _font_set_antialiasing(font_rid: RID, antialiasing: FontAntialiasing) virtual
void | _font_set_ascent(font_rid: RID, size: int, ascent: float) virtual required
void | _font_set_baseline_offset(font_rid: RID, baseline_offset: float) virtual
void | _font_set_data(font_rid: RID, data: PackedByteArray) virtual
void | _font_set_data_ptr(font_rid: RID, data_ptr: const uint8_t*, data_size: int) virtual
void | _font_set_descent(font_rid: RID, size: int, descent: float) virtual required
void | _font_set_disable_embedded_bitmaps(font_rid: RID, disable_embedded_bitmaps: bool) virtual
void | _font_set_embolden(font_rid: RID, strength: float) virtual
void | _font_set_face_index(font_rid: RID, face_index: int) virtual
void | _font_set_fixed_size(font_rid: RID, fixed_size: int) virtual required
void | _font_set_fixed_size_scale_mode(font_rid: RID, fixed_size_scale_mode: FixedSizeScaleMode) virtual required
void | _font_set_force_autohinter(font_rid: RID, force_autohinter: bool) virtual
void | _font_set_generate_mipmaps(font_rid: RID, generate_mipmaps: bool) virtual
void | _font_set_global_oversampling(oversampling: float) virtual
void | _font_set_glyph_advance(font_rid: RID, size: int, glyph: int, advance: Vector2) virtual required
void | _font_set_glyph_offset(font_rid: RID, size: Vector2i, glyph: int, offset: Vector2) virtual required
void | _font_set_glyph_size(font_rid: RID, size: Vector2i, glyph: int, gl_size: Vector2) virtual required
void | _font_set_glyph_texture_idx(font_rid: RID, size: Vector2i, glyph: int, texture_idx: int) virtual required
void | _font_set_glyph_uv_rect(font_rid: RID, size: Vector2i, glyph: int, uv_rect: Rect2) virtual required
void | _font_set_hinting(font_rid: RID, hinting: Hinting) virtual
void | _font_set_keep_rounding_remainders(font_rid: RID, keep_rounding_remainders: bool) virtual
void | _font_set_kerning(font_rid: RID, size: int, glyph_pair: Vector2i, kerning: Vector2) virtual
void | _font_set_language_support_override(font_rid: RID, language: String, supported: bool) virtual
void | _font_set_modulate_color_glyphs(font_rid: RID, modulate: bool) virtual
void | _font_set_msdf_pixel_range(font_rid: RID, msdf_pixel_range: int) virtual
void | _font_set_msdf_size(font_rid: RID, msdf_size: int) virtual
void | _font_set_multichannel_signed_distance_field(font_rid: RID, msdf: bool) virtual
void | _font_set_name(font_rid: RID, name: String) virtual
void | _font_set_opentype_feature_overrides(font_rid: RID, overrides: Dictionary) virtual
void | _font_set_oversampling(font_rid: RID, oversampling: float) virtual
void | _font_set_palette_custom_colors(font_rid: RID, colors: PackedColorArray) virtual
void | _font_set_scale(font_rid: RID, size: int, scale: float) virtual required
void | _font_set_script_support_override(font_rid: RID, script: String, supported: bool) virtual
void | _font_set_spacing(font_rid: RID, spacing: SpacingType, value: int) virtual
void | _font_set_stretch(font_rid: RID, stretch: int) virtual
void | _font_set_style(font_rid: RID, style: BitField[FontStyle]) virtual
void | _font_set_style_name(font_rid: RID, name_style: String) virtual
void | _font_set_subpixel_positioning(font_rid: RID, subpixel_positioning: SubpixelPositioning) virtual
void | _font_set_texture_image(font_rid: RID, size: Vector2i, texture_index: int, image: Image) virtual required
void | _font_set_texture_offsets(font_rid: RID, size: Vector2i, texture_index: int, offset: PackedInt32Array) virtual
void | _font_set_transform(font_rid: RID, transform: Transform2D) virtual
void | _font_set_underline_position(font_rid: RID, size: int, underline_position: float) virtual required
void | _font_set_underline_thickness(font_rid: RID, size: int, underline_thickness: float) virtual required
void | _font_set_used_palette(font_rid: RID, index: int) virtual
void | _font_set_variation_coordinates(font_rid: RID, variation_coordinates: Dictionary) virtual
void | _font_set_weight(font_rid: RID, weight: int) virtual
Dictionary | _font_supported_feature_list(font_rid: RID) virtual const
Dictionary | _font_supported_variation_list(font_rid: RID) virtual const
String | _format_number(number: String, language: String) virtual const
void | _free_rid(rid: RID) virtual required
int | _get_features() virtual required const
Vector2 | _get_hex_code_box_size(size: int, index: int) virtual const
String | _get_name() virtual required const
PackedByteArray | _get_support_data() virtual const
String | _get_support_data_filename() virtual const
String | _get_support_data_info() virtual const
bool | _has(rid: RID) virtual required
bool | _has_feature(feature: Feature) virtual required const
int | _is_confusable(string: String, dict: PackedStringArray) virtual const
bool | _is_locale_right_to_left(locale: String) virtual const
bool | _is_locale_using_support_data(locale: String) virtual const
bool | _is_valid_identifier(string: String) virtual const
bool | _is_valid_letter(unicode: int) virtual const
bool | _load_support_data(filename: String) virtual
int | _name_to_tag(name: String) virtual const
String | _parse_number(number: String, language: String) virtual const
Array[Vector3i] | _parse_structured_text(parser_type: StructuredTextParser, args: Array, text: String) virtual const
String | _percent_sign(language: String) virtual const
void | _reference_oversampling_level(oversampling: float) virtual
bool | _save_support_data(filename: String) virtual const
int | _shaped_get_run_count(shaped: RID) virtual const
Direction | _shaped_get_run_direction(shaped: RID, index: int) virtual const
RID | _shaped_get_run_font_rid(shaped: RID, index: int) virtual const
int | _shaped_get_run_font_size(shaped: RID, index: int) virtual const
Vector2i | _shaped_get_run_glyph_range(shaped: RID, index: int) virtual const
String | _shaped_get_run_language(shaped: RID, index: int) virtual const
Variant | _shaped_get_run_object(shaped: RID, index: int) virtual const
Vector2i | _shaped_get_run_range(shaped: RID, index: int) virtual const
String | _shaped_get_run_text(shaped: RID, index: int) virtual const
int | _shaped_get_span_count(shaped: RID) virtual required const
Variant | _shaped_get_span_embedded_object(shaped: RID, index: int) virtual required const
Variant | _shaped_get_span_meta(shaped: RID, index: int) virtual required const
Variant | _shaped_get_span_object(shaped: RID, index: int) virtual required const
String | _shaped_get_span_text(shaped: RID, index: int) virtual required const
String | _shaped_get_text(shaped: RID) virtual required const
void | _shaped_set_span_update_font(shaped: RID, index: int, fonts: Array[RID], size: int, opentype_features: Dictionary) virtual required
bool | _shaped_text_add_object(shaped: RID, key: Variant, size: Vector2, inline_align: InlineAlignment, length: int, baseline: float) virtual required
bool | _shaped_text_add_string(shaped: RID, text: String, fonts: Array[RID], size: int, opentype_features: Dictionary, language: String, meta: Variant) virtual required
void | _shaped_text_clear(shaped: RID) virtual required
int | _shaped_text_closest_character_pos(shaped: RID, pos: int) virtual const
void | _shaped_text_draw(shaped: RID, canvas: RID, pos: Vector2, clip_l: float, clip_r: float, color: Color, oversampling: float) virtual const
void | _shaped_text_draw_outline(shaped: RID, canvas: RID, pos: Vector2, clip_l: float, clip_r: float, outline_size: int, color: Color, oversampling: float) virtual const
RID | _shaped_text_duplicate(shaped: RID) virtual required
float | _shaped_text_fit_to_width(shaped: RID, width: float, justification_flags: BitField[JustificationFlag]) virtual
float | _shaped_text_get_ascent(shaped: RID) virtual required const
void | _shaped_text_get_carets(shaped: RID, position: int, r_caret: CaretInfo*) virtual const
PackedInt32Array | _shaped_text_get_character_breaks(shaped: RID) virtual const
int | _shaped_text_get_custom_ellipsis(shaped: RID) virtual const
String | _shaped_text_get_custom_punctuation(shaped: RID) virtual const
float | _shaped_text_get_descent(shaped: RID) virtual required const
Direction | _shaped_text_get_direction(shaped: RID) virtual const
int | _shaped_text_get_dominant_direction_in_range(shaped: RID, start: int, end: int) virtual const
int | _shaped_text_get_ellipsis_glyph_count(shaped: RID) virtual required const
const Glyph* | _shaped_text_get_ellipsis_glyphs(shaped: RID) virtual required const
int | _shaped_text_get_ellipsis_pos(shaped: RID) virtual required const
int | _shaped_text_get_glyph_count(shaped: RID) virtual required const
const Glyph* | _shaped_text_get_glyphs(shaped: RID) virtual required const
Vector2 | _shaped_text_get_grapheme_bounds(shaped: RID, pos: int) virtual const
Direction | _shaped_text_get_inferred_direction(shaped: RID) virtual const
PackedInt32Array | _shaped_text_get_line_breaks(shaped: RID, width: float, start: int, break_flags: BitField[LineBreakFlag]) virtual const
PackedInt32Array | _shaped_text_get_line_breaks_adv(shaped: RID, width: PackedFloat32Array, start: int, once: bool, break_flags: BitField[LineBreakFlag]) virtual const
int | _shaped_text_get_object_glyph(shaped: RID, key: Variant) virtual required const
Vector2i | _shaped_text_get_object_range(shaped: RID, key: Variant) virtual required const
Rect2 | _shaped_text_get_object_rect(shaped: RID, key: Variant) virtual required const
Array | _shaped_text_get_objects(shaped: RID) virtual required const
Orientation | _shaped_text_get_orientation(shaped: RID) virtual const
RID | _shaped_text_get_parent(shaped: RID) virtual required const
bool | _shaped_text_get_preserve_control(shaped: RID) virtual const
bool | _shaped_text_get_preserve_invalid(shaped: RID) virtual const
Vector2i | _shaped_text_get_range(shaped: RID) virtual required const
PackedVector2Array | _shaped_text_get_selection(shaped: RID, start: int, end: int) virtual const
Vector2 | _shaped_text_get_size(shaped: RID) virtual required const
int | _shaped_text_get_spacing(shaped: RID, spacing: SpacingType) virtual const
int | _shaped_text_get_trim_pos(shaped: RID) virtual required const
float | _shaped_text_get_underline_position(shaped: RID) virtual required const
float | _shaped_text_get_underline_thickness(shaped: RID) virtual required const
float | _shaped_text_get_width(shaped: RID) virtual required const
PackedInt32Array | _shaped_text_get_word_breaks(shaped: RID, grapheme_flags: BitField[GraphemeFlag], skip_grapheme_flags: BitField[GraphemeFlag]) virtual const
bool | _shaped_text_has_object(shaped: RID, key: Variant) virtual required const
int | _shaped_text_hit_test_grapheme(shaped: RID, coord: float) virtual const
int | _shaped_text_hit_test_position(shaped: RID, coord: float) virtual const
bool | _shaped_text_is_ready(shaped: RID) virtual required const
int | _shaped_text_next_character_pos(shaped: RID, pos: int) virtual const
int | _shaped_text_next_grapheme_pos(shaped: RID, pos: int) virtual const
void | _shaped_text_overrun_trim_to_width(shaped: RID, width: float, trim_flags: BitField[TextOverrunFlag]) virtual
int | _shaped_text_prev_character_pos(shaped: RID, pos: int) virtual const
int | _shaped_text_prev_grapheme_pos(shaped: RID, pos: int) virtual const
bool | _shaped_text_resize_object(shaped: RID, key: Variant, size: Vector2, inline_align: InlineAlignment, baseline: float) virtual required
void | _shaped_text_set_bidi_override(shaped: RID, override: Array) virtual
void | _shaped_text_set_custom_ellipsis(shaped: RID, char: int) virtual
void | _shaped_text_set_custom_punctuation(shaped: RID, punct: String) virtual
void | _shaped_text_set_direction(shaped: RID, direction: Direction) virtual
void | _shaped_text_set_orientation(shaped: RID, orientation: Orientation) virtual
void | _shaped_text_set_preserve_control(shaped: RID, enabled: bool) virtual
void | _shaped_text_set_preserve_invalid(shaped: RID, enabled: bool) virtual
void | _shaped_text_set_spacing(shaped: RID, spacing: SpacingType, value: int) virtual
bool | _shaped_text_shape(shaped: RID) virtual required
const Glyph* | _shaped_text_sort_logical(shaped: RID) virtual required
RID | _shaped_text_substr(shaped: RID, start: int, length: int) virtual required const
float | _shaped_text_tab_align(shaped: RID, tab_stops: PackedFloat32Array) virtual
bool | _shaped_text_update_breaks(shaped: RID) virtual
bool | _shaped_text_update_justification_ops(shaped: RID) virtual
bool | _spoof_check(string: String) virtual const
PackedInt32Array | _string_get_character_breaks(string: String, language: String) virtual const
PackedInt32Array | _string_get_word_breaks(string: String, language: String, chars_per_line: int) virtual const
String | _string_to_lower(string: String, language: String) virtual const
String | _string_to_title(string: String, language: String) virtual const
String | _string_to_upper(string: String, language: String) virtual const
String | _strip_diacritics(string: String) virtual const
String | _tag_to_name(tag: int) virtual const
void | _unreference_oversampling_level(oversampling: float) virtual

---

## Method Descriptions

void _cleanup() virtual 

This method is called before text server is unregistered.

---

RID _create_font() virtual required 

Creates a new, empty font cache entry resource.

---

RID _create_font_linked_variation(font_rid: RID) virtual 

Optional, implement if font supports extra spacing or baseline offset.

Creates a new variation existing font which is reusing the same glyph cache and font data.

---

RID _create_shaped_text(direction: Direction, orientation: Orientation) virtual required 

Creates a new buffer for complex text layout, with the given direction and orientation.

---

void _draw_hex_code_box(canvas: RID, size: int, pos: Vector2, index: int, color: Color) virtual const 

Draws box displaying character hexadecimal code.

---

void _font_clear_glyphs(font_rid: RID, size: Vector2i) virtual required 

Removes all rendered glyph information from the cache entry.

---

void _font_clear_kerning_map(font_rid: RID, size: int) virtual 

Removes all kerning overrides.

---

void _font_clear_size_cache(font_rid: RID) virtual required 

Removes all font sizes from the cache entry.

---

void _font_clear_system_fallback_cache() virtual 

Frees all automatically loaded system fonts.

---

void _font_clear_textures(font_rid: RID, size: Vector2i) virtual required 

Removes all textures from font cache entry.

---

void _font_draw_glyph(font_rid: RID, canvas: RID, size: int, pos: Vector2, index: int, color: Color, oversampling: float) virtual required const 

Draws single glyph into a canvas item at the position, using font_rid at the size size. If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

---

void _font_draw_glyph_outline(font_rid: RID, canvas: RID, size: int, outline_size: int, pos: Vector2, index: int, color: Color, oversampling: float) virtual required const 

Draws single glyph outline of size outline_size into a canvas item at the position, using font_rid at the size size. If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

---

FontAntialiasing _font_get_antialiasing(font_rid: RID) virtual const 

Returns font anti-aliasing mode.

---

float _font_get_ascent(font_rid: RID, size: int) virtual required const 

Returns the font ascent (number of pixels above the baseline).

---

float _font_get_baseline_offset(font_rid: RID) virtual const 

Returns extra baseline offset (as a fraction of font height).

---

int _font_get_char_from_glyph_index(font_rid: RID, size: int, glyph_index: int) virtual required const 

Returns character code associated with glyph_index, or 0 if glyph_index is invalid.

---

float _font_get_descent(font_rid: RID, size: int) virtual required const 

Returns the font descent (number of pixels below the baseline).

---

bool _font_get_disable_embedded_bitmaps(font_rid: RID) virtual const 

Returns whether the font's embedded bitmap loading is disabled.

---

float _font_get_embolden(font_rid: RID) virtual const 

Returns font embolden strength.

---

int _font_get_face_count(font_rid: RID) virtual const 

Returns number of faces in the TrueType / OpenType collection.

---

int _font_get_face_index(font_rid: RID) virtual const 

Returns an active face index in the TrueType / OpenType collection.

---

int _font_get_fixed_size(font_rid: RID) virtual required const 

Returns bitmap font fixed size.

---

FixedSizeScaleMode _font_get_fixed_size_scale_mode(font_rid: RID) virtual required const 

Returns bitmap font scaling mode.

---

bool _font_get_generate_mipmaps(font_rid: RID) virtual const 

Returns true if font texture mipmap generation is enabled.

---

float _font_get_global_oversampling() virtual const 

Returns the font oversampling factor, shared by all fonts in the TextServer.

---

Vector2 _font_get_glyph_advance(font_rid: RID, size: int, glyph: int) virtual required const 

Returns glyph advance (offset of the next glyph).

---

Dictionary _font_get_glyph_contours(font_rid: RID, size: int, index: int) virtual const 

Returns outline contours of the glyph.

---

int _font_get_glyph_index(font_rid: RID, size: int, char: int, variation_selector: int) virtual required const 

Returns the glyph index of a char, optionally modified by the variation_selector.

---

PackedInt32Array _font_get_glyph_list(font_rid: RID, size: Vector2i) virtual required const 

Returns list of rendered glyphs in the cache entry.

---

Vector2 _font_get_glyph_offset(font_rid: RID, size: Vector2i, glyph: int) virtual required const 

Returns glyph offset from the baseline.

---

Vector2 _font_get_glyph_size(font_rid: RID, size: Vector2i, glyph: int) virtual required const 

Returns size of the glyph.

---

int _font_get_glyph_texture_idx(font_rid: RID, size: Vector2i, glyph: int) virtual required const 

Returns index of the cache texture containing the glyph.

---

RID _font_get_glyph_texture_rid(font_rid: RID, size: Vector2i, glyph: int) virtual required const 

Returns resource ID of the cache texture containing the glyph.

---

Vector2 _font_get_glyph_texture_size(font_rid: RID, size: Vector2i, glyph: int) virtual required const 

Returns size of the cache texture containing the glyph.

---

Rect2 _font_get_glyph_uv_rect(font_rid: RID, size: Vector2i, glyph: int) virtual required const 

Returns rectangle in the cache texture containing the glyph.

---

Hinting _font_get_hinting(font_rid: RID) virtual const 

Returns the font hinting mode. Used by dynamic fonts only.

---

bool _font_get_keep_rounding_remainders(font_rid: RID) virtual const 

Returns glyph position rounding behavior. If set to true, when aligning glyphs to the pixel boundaries rounding remainders are accumulated to ensure more uniform glyph distribution. This setting has no effect if subpixel positioning is enabled.

---

Vector2 _font_get_kerning(font_rid: RID, size: int, glyph_pair: Vector2i) virtual const 

Returns kerning for the pair of glyphs.

---

Array[Vector2i] _font_get_kerning_list(font_rid: RID, size: int) virtual const 

Returns list of the kerning overrides.

---

bool _font_get_language_support_override(font_rid: RID, language: String) virtual 

Returns true if support override is enabled for the language.

---

PackedStringArray _font_get_language_support_overrides(font_rid: RID) virtual 

Returns list of language support overrides.

---

int _font_get_msdf_pixel_range(font_rid: RID) virtual const 

Returns the width of the range around the shape between the minimum and maximum representable signed distance.

---

int _font_get_msdf_size(font_rid: RID) virtual const 

Returns source font size used to generate MSDF textures.

---

String _font_get_name(font_rid: RID) virtual const 

Returns font family name.

---

Dictionary _font_get_opentype_feature_overrides(font_rid: RID) virtual const 

Returns font OpenType feature set override.

---

Dictionary _font_get_ot_name_strings(font_rid: RID) virtual const 

Returns Dictionary with OpenType font name strings (localized font names, version, description, license information, sample text, etc.).

---

float _font_get_oversampling(font_rid: RID) virtual const 

Returns oversampling factor override. If set to a positive value, overrides the oversampling factor of the viewport this font is used in. See Viewport.oversampling. This value doesn't override the oversampling parameter of draw_* methods. Used by dynamic fonts only.

---

PackedColorArray _font_get_palette_colors(font_rid: RID, index: int) virtual const 

Returns the array in the predefined color palette at index. Palette contains all colors used to render font glyphs. Each palette has the same number of colors. Colors can be overridden using _font_set_palette_custom_colors().

---

int _font_get_palette_count(font_rid: RID) virtual const 

Returns the number of predefined color palettes. Palette contains all colors used to render font glyphs. Each palette has the same number of colors.

---

PackedColorArray _font_get_palette_custom_colors(font_rid: RID) virtual const 

Returns array of custom colors to override predefined palette.

---

String _font_get_palette_name(font_rid: RID, index: int) virtual const 

Returns the name of the predefined color palette at index. Palette contains all colors used to render font glyphs. Each palette has the same number of colors.

---

float _font_get_scale(font_rid: RID, size: int) virtual required const 

Returns scaling factor of the color bitmap font.

---

bool _font_get_script_support_override(font_rid: RID, script: String) virtual 

Returns true if support override is enabled for the script.

---

PackedStringArray _font_get_script_support_overrides(font_rid: RID) virtual 

Returns list of script support overrides.

---

Array[Dictionary] _font_get_size_cache_info(font_rid: RID) virtual const 

Returns font cache information, each entry contains the following fields: Vector2i size_px - font size in pixels, float viewport_oversampling - viewport oversampling factor, int glyphs - number of rendered glyphs, int textures - number of used textures, int textures_size - size of texture data in bytes.

---

Array[Vector2i] _font_get_size_cache_list(font_rid: RID) virtual required const 

Returns list of the font sizes in the cache. Each size is Vector2i with font size and outline size.

---

int _font_get_spacing(font_rid: RID, spacing: SpacingType) virtual const 

Returns the spacing for spacing in pixels (not relative to the font size).

---

int _font_get_stretch(font_rid: RID) virtual const 

Returns font stretch amount, compared to a normal width. A percentage value between 50% and 200%.

---

BitField[FontStyle] _font_get_style(font_rid: RID) virtual const 

Returns font style flags.

---

String _font_get_style_name(font_rid: RID) virtual const 

Returns font style name.

---

SubpixelPositioning _font_get_subpixel_positioning(font_rid: RID) virtual const 

Returns font subpixel glyph positioning mode.

---

String _font_get_supported_chars(font_rid: RID) virtual required const 

Returns a string containing all the characters available in the font.

---

PackedInt32Array _font_get_supported_glyphs(font_rid: RID) virtual required const 

Returns an array containing all glyph indices in the font.

---

int _font_get_texture_count(font_rid: RID, size: Vector2i) virtual required const 

Returns number of textures used by font cache entry.

---

Image _font_get_texture_image(font_rid: RID, size: Vector2i, texture_index: int) virtual required const 

Returns font cache texture image data.

---

PackedInt32Array _font_get_texture_offsets(font_rid: RID, size: Vector2i, texture_index: int) virtual const 

Returns array containing glyph packing data.

---

Transform2D _font_get_transform(font_rid: RID) virtual const 

Returns 2D transform applied to the font outlines.

---

float _font_get_underline_position(font_rid: RID, size: int) virtual required const 

Returns pixel offset of the underline below the baseline.

---

float _font_get_underline_thickness(font_rid: RID, size: int) virtual required const 

Returns thickness of the underline in pixels.

---

int _font_get_used_palette(font_rid: RID) virtual const 

Returns used palette index.

---

Dictionary _font_get_variation_coordinates(font_rid: RID) virtual const 

Returns variation coordinates for the specified font cache entry.

---

int _font_get_weight(font_rid: RID) virtual const 

Returns weight (boldness) of the font. A value in the 100...999 range, normal font weight is 400, bold font weight is 700.

---

bool _font_has_char(font_rid: RID, char: int) virtual required const 

Returns true if a Unicode char is available in the font.

---

bool _font_is_allow_system_fallback(font_rid: RID) virtual const 

Returns true if system fonts can be automatically used as fallbacks.

---

bool _font_is_force_autohinter(font_rid: RID) virtual const 

Returns true if auto-hinting is supported and preferred over font built-in hinting.

---

bool _font_is_language_supported(font_rid: RID, language: String) virtual const 

Returns true if the font supports the given language (as a ISO 639 [https://en.wikipedia.org/wiki/ISO_639-1] code).

---

bool _font_is_modulate_color_glyphs(font_rid: RID) virtual const 

Returns true if color modulation is applied when drawing the font's colored glyphs.

---

bool _font_is_multichannel_signed_distance_field(font_rid: RID) virtual const 

Returns true if glyphs of all sizes are rendered using single multichannel signed distance field generated from the dynamic font vector data.

---

bool _font_is_script_supported(font_rid: RID, script: String) virtual const 

Returns true if the font supports the given script (as a ISO 15924 [https://en.wikipedia.org/wiki/ISO_15924] code).

---

void _font_remove_glyph(font_rid: RID, size: Vector2i, glyph: int) virtual required 

Removes specified rendered glyph information from the cache entry.

---

void _font_remove_kerning(font_rid: RID, size: int, glyph_pair: Vector2i) virtual 

Removes kerning override for the pair of glyphs.

---

void _font_remove_language_support_override(font_rid: RID, language: String) virtual 

Remove language support override.

---

void _font_remove_script_support_override(font_rid: RID, script: String) virtual 

Removes script support override.

---

void _font_remove_size_cache(font_rid: RID, size: Vector2i) virtual required 

Removes specified font size from the cache entry.

---

void _font_remove_texture(font_rid: RID, size: Vector2i, texture_index: int) virtual required 

Removes specified texture from the cache entry.

---

void _font_render_glyph(font_rid: RID, size: Vector2i, index: int) virtual 

Renders specified glyph to the font cache texture.

---

void _font_render_range(font_rid: RID, size: Vector2i, start: int, end: int) virtual 

Renders the range of characters to the font cache texture.

---

void _font_set_allow_system_fallback(font_rid: RID, allow_system_fallback: bool) virtual 

If set to true, system fonts can be automatically used as fallbacks.

---

void _font_set_antialiasing(font_rid: RID, antialiasing: FontAntialiasing) virtual 

Sets font anti-aliasing mode.

---

void _font_set_ascent(font_rid: RID, size: int, ascent: float) virtual required 

Sets the font ascent (number of pixels above the baseline).

---

void _font_set_baseline_offset(font_rid: RID, baseline_offset: float) virtual 

Sets extra baseline offset (as a fraction of font height).

---

void _font_set_data(font_rid: RID, data: PackedByteArray) virtual 

Sets font source data, e.g contents of the dynamic font source file.

---

void _font_set_data_ptr(font_rid: RID, data_ptr: const uint8_t*, data_size: int) virtual 

Sets pointer to the font source data, e.g contents of the dynamic font source file.

---

void _font_set_descent(font_rid: RID, size: int, descent: float) virtual required 

Sets the font descent (number of pixels below the baseline).

---

void _font_set_disable_embedded_bitmaps(font_rid: RID, disable_embedded_bitmaps: bool) virtual 

If set to true, embedded font bitmap loading is disabled.

---

void _font_set_embolden(font_rid: RID, strength: float) virtual 

Sets font embolden strength. If strength is not equal to zero, emboldens the font outlines. Negative values reduce the outline thickness.

---

void _font_set_face_index(font_rid: RID, face_index: int) virtual 

Sets an active face index in the TrueType / OpenType collection.

---

void _font_set_fixed_size(font_rid: RID, fixed_size: int) virtual required 

Sets bitmap font fixed size. If set to value greater than zero, same cache entry will be used for all font sizes.

---

void _font_set_fixed_size_scale_mode(font_rid: RID, fixed_size_scale_mode: FixedSizeScaleMode) virtual required 

Sets bitmap font scaling mode. This property is used only if fixed_size is greater than zero.

---

void _font_set_force_autohinter(font_rid: RID, force_autohinter: bool) virtual 

If set to true auto-hinting is preferred over font built-in hinting.

---

void _font_set_generate_mipmaps(font_rid: RID, generate_mipmaps: bool) virtual 

If set to true font texture mipmap generation is enabled.

---

void _font_set_global_oversampling(oversampling: float) virtual 

Sets oversampling factor, shared by all font in the TextServer.

---

void _font_set_glyph_advance(font_rid: RID, size: int, glyph: int, advance: Vector2) virtual required 

Sets glyph advance (offset of the next glyph).

---

void _font_set_glyph_offset(font_rid: RID, size: Vector2i, glyph: int, offset: Vector2) virtual required 

Sets glyph offset from the baseline.

---

void _font_set_glyph_size(font_rid: RID, size: Vector2i, glyph: int, gl_size: Vector2) virtual required 

Sets size of the glyph.

---

void _font_set_glyph_texture_idx(font_rid: RID, size: Vector2i, glyph: int, texture_idx: int) virtual required 

Sets index of the cache texture containing the glyph.

---

void _font_set_glyph_uv_rect(font_rid: RID, size: Vector2i, glyph: int, uv_rect: Rect2) virtual required 

Sets rectangle in the cache texture containing the glyph.

---

void _font_set_hinting(font_rid: RID, hinting: Hinting) virtual 

Sets font hinting mode. Used by dynamic fonts only.

---

void _font_set_keep_rounding_remainders(font_rid: RID, keep_rounding_remainders: bool) virtual 

Sets glyph position rounding behavior. If set to true, when aligning glyphs to the pixel boundaries rounding remainders are accumulated to ensure more uniform glyph distribution. This setting has no effect if subpixel positioning is enabled.

---

void _font_set_kerning(font_rid: RID, size: int, glyph_pair: Vector2i, kerning: Vector2) virtual 

Sets kerning for the pair of glyphs.

---

void _font_set_language_support_override(font_rid: RID, language: String, supported: bool) virtual 

Adds override for _font_is_language_supported().

---

void _font_set_modulate_color_glyphs(font_rid: RID, modulate: bool) virtual 

If set to true, color modulation is applied when drawing colored glyphs, otherwise it's applied to the monochrome glyphs only.

---

void _font_set_msdf_pixel_range(font_rid: RID, msdf_pixel_range: int) virtual 

Sets the width of the range around the shape between the minimum and maximum representable signed distance.

---

void _font_set_msdf_size(font_rid: RID, msdf_size: int) virtual 

Sets source font size used to generate MSDF textures.

---

void _font_set_multichannel_signed_distance_field(font_rid: RID, msdf: bool) virtual 

If set to true, glyphs of all sizes are rendered using single multichannel signed distance field generated from the dynamic font vector data. MSDF rendering allows displaying the font at any scaling factor without blurriness, and without incurring a CPU cost when the font size changes (since the font no longer needs to be rasterized on the CPU). As a downside, font hinting is not available with MSDF. The lack of font hinting may result in less crisp and less readable fonts at small sizes.

---

void _font_set_name(font_rid: RID, name: String) virtual 

Sets the font family name.

---

void _font_set_opentype_feature_overrides(font_rid: RID, overrides: Dictionary) virtual 

Sets font OpenType feature set override.

---

void _font_set_oversampling(font_rid: RID, oversampling: float) virtual 

If set to a positive value, overrides the oversampling factor of the viewport this font is used in. See Viewport.oversampling. This value doesn't override the oversampling parameter of draw_* methods. Used by dynamic fonts only.

---

void _font_set_palette_custom_colors(font_rid: RID, colors: PackedColorArray) virtual 

Sets array of custom colors to override predefined palette. Set to empty array to reset overrides. Use Color(0, 0, 0, 0), to keep predefined palette color at specific position.

---

void _font_set_scale(font_rid: RID, size: int, scale: float) virtual required 

Sets scaling factor of the color bitmap font.

---

void _font_set_script_support_override(font_rid: RID, script: String, supported: bool) virtual 

Adds override for _font_is_script_supported().

---

void _font_set_spacing(font_rid: RID, spacing: SpacingType, value: int) virtual 

Sets the spacing for spacing to value in pixels (not relative to the font size).

---

void _font_set_stretch(font_rid: RID, stretch: int) virtual 

Sets font stretch amount, compared to a normal width. A percentage value between 50% and 200%.

---

void _font_set_style(font_rid: RID, style: BitField[FontStyle]) virtual 

Sets the font style flags.

---

void _font_set_style_name(font_rid: RID, name_style: String) virtual 

Sets the font style name.

---

void _font_set_subpixel_positioning(font_rid: RID, subpixel_positioning: SubpixelPositioning) virtual 

Sets font subpixel glyph positioning mode.

---

void _font_set_texture_image(font_rid: RID, size: Vector2i, texture_index: int, image: Image) virtual required 

Sets font cache texture image data.

---

void _font_set_texture_offsets(font_rid: RID, size: Vector2i, texture_index: int, offset: PackedInt32Array) virtual 

Sets array containing glyph packing data.

---

void _font_set_transform(font_rid: RID, transform: Transform2D) virtual 

Sets 2D transform, applied to the font outlines, can be used for slanting, flipping, and rotating glyphs.

---

void _font_set_underline_position(font_rid: RID, size: int, underline_position: float) virtual required 

Sets pixel offset of the underline below the baseline.

---

void _font_set_underline_thickness(font_rid: RID, size: int, underline_thickness: float) virtual required 

Sets thickness of the underline in pixels.

---

void _font_set_used_palette(font_rid: RID, index: int) virtual 

Sets used palette index.

---

void _font_set_variation_coordinates(font_rid: RID, variation_coordinates: Dictionary) virtual 

Sets variation coordinates for the specified font cache entry.

---

void _font_set_weight(font_rid: RID, weight: int) virtual 

Sets weight (boldness) of the font. A value in the 100...999 range, normal font weight is 400, bold font weight is 700.

---

Dictionary _font_supported_feature_list(font_rid: RID) virtual const 

Returns the dictionary of the supported OpenType features.

---

Dictionary _font_supported_variation_list(font_rid: RID) virtual const 

Returns the dictionary of the supported OpenType variation coordinates.

---

String _format_number(number: String, language: String) virtual const 

Deprecated: Use TranslationServer.format_number() instead.

Converts a number from Western Arabic (0..9) to the numeral system used in the given language.

If language is an empty string, the active locale will be used.

---

void _free_rid(rid: RID) virtual required 

Frees an object created by this TextServer.

---

int _get_features() virtual required const 

Returns text server features, see Feature.

---

Vector2 _get_hex_code_box_size(size: int, index: int) virtual const 

Returns size of the replacement character (box with character hexadecimal code that is drawn in place of invalid characters).

---

String _get_name() virtual required const 

Returns the name of the server interface.

---

PackedByteArray _get_support_data() virtual const 

Returns default TextServer database (e.g. ICU break iterators and dictionaries).

---

String _get_support_data_filename() virtual const 

Returns default TextServer database (e.g. ICU break iterators and dictionaries) filename.

---

String _get_support_data_info() virtual const 

Returns TextServer database (e.g. ICU break iterators and dictionaries) description.

---

bool _has(rid: RID) virtual required 

Returns true if rid is valid resource owned by this text server.

---

bool _has_feature(feature: Feature) virtual required const 

Returns true if the server supports a feature.

---

int _is_confusable(string: String, dict: PackedStringArray) virtual const 

Returns index of the first string in dict which is visually confusable with the string, or -1 if none is found.

---

bool _is_locale_right_to_left(locale: String) virtual const 

Returns true if locale is right-to-left.

---

bool _is_locale_using_support_data(locale: String) virtual const 

Returns true if the locale requires text server support data for line/word breaking.

---

bool _is_valid_identifier(string: String) virtual const 

Returns true if string is a valid identifier.

---

bool _is_valid_letter(unicode: int) virtual const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _load_support_data(filename: String) virtual 

Loads optional TextServer database (e.g. ICU break iterators and dictionaries).

---

int _name_to_tag(name: String) virtual const 

Converts the given readable name of a feature, variation, script, or language to an OpenType tag.

---

String _parse_number(number: String, language: String) virtual const 

Deprecated: Use TranslationServer.parse_number() instead.

Converts number from the numeral system used in the given language to Western Arabic (0..9).

If language is an empty string, the active locale will be used.

---

Array[Vector3i] _parse_structured_text(parser_type: StructuredTextParser, args: Array, text: String) virtual const 

Default implementation of the BiDi algorithm override function.

---

String _percent_sign(language: String) virtual const 

Deprecated: Use TranslationServer.get_percent_sign() instead.

Returns percent sign used in the given language.

---

void _reference_oversampling_level(oversampling: float) virtual 

Increases the reference count of the specified oversampling level. This method is called by Viewport, and should not be used directly.

---

bool _save_support_data(filename: String) virtual const 

Saves optional TextServer database (e.g. ICU break iterators and dictionaries) to the file.

---

int _shaped_get_run_count(shaped: RID) virtual const 

Returns the number of uniform text runs in the buffer.

---

Direction _shaped_get_run_direction(shaped: RID, index: int) virtual const 

Returns the direction of the index text run (in visual order).

---

RID _shaped_get_run_font_rid(shaped: RID, index: int) virtual const 

Returns the font RID of the index text run (in visual order).

---

int _shaped_get_run_font_size(shaped: RID, index: int) virtual const 

Returns the font size of the index text run (in visual order).

---

Vector2i _shaped_get_run_glyph_range(shaped: RID, index: int) virtual const 

Returns the glyph range of the index text run (in visual order).

---

String _shaped_get_run_language(shaped: RID, index: int) virtual const 

Returns the language of the index text run (in visual order).

---

Variant _shaped_get_run_object(shaped: RID, index: int) virtual const 

Returns the embedded object of the index text run (in visual order).

---

Vector2i _shaped_get_run_range(shaped: RID, index: int) virtual const 

Returns the source text range of the index text run (in visual order).

---

String _shaped_get_run_text(shaped: RID, index: int) virtual const 

Returns the source text of the index text run (in visual order).

---

int _shaped_get_span_count(shaped: RID) virtual required const 

Returns number of text spans added using _shaped_text_add_string() or _shaped_text_add_object().

---

Variant _shaped_get_span_embedded_object(shaped: RID, index: int) virtual required const 

Returns text embedded object key.

---

Variant _shaped_get_span_meta(shaped: RID, index: int) virtual required const 

Returns text span metadata.

---

Variant _shaped_get_span_object(shaped: RID, index: int) virtual required const 

Returns the text span embedded object key.

---

String _shaped_get_span_text(shaped: RID, index: int) virtual required const 

Returns the text span source text.

---

String _shaped_get_text(shaped: RID) virtual required const 

Returns the text buffer source text, including object replacement characters.

---

void _shaped_set_span_update_font(shaped: RID, index: int, fonts: Array[RID], size: int, opentype_features: Dictionary) virtual required 

Changes text span font, font size, and OpenType features, without changing the text.

---

bool _shaped_text_add_object(shaped: RID, key: Variant, size: Vector2, inline_align: InlineAlignment, length: int, baseline: float) virtual required 

Adds inline object to the text buffer, key must be unique. In the text, object is represented as length object replacement characters.

---

bool _shaped_text_add_string(shaped: RID, text: String, fonts: Array[RID], size: int, opentype_features: Dictionary, language: String, meta: Variant) virtual required 

Adds text span and font to draw it to the text buffer.

---

void _shaped_text_clear(shaped: RID) virtual required 

Clears text buffer (removes text and inline objects).

---

int _shaped_text_closest_character_pos(shaped: RID, pos: int) virtual const 

Returns composite character position closest to the pos.

---

void _shaped_text_draw(shaped: RID, canvas: RID, pos: Vector2, clip_l: float, clip_r: float, color: Color, oversampling: float) virtual const 

Draw shaped text into a canvas item at a given position, with color. pos specifies the leftmost point of the baseline (for horizontal layout) or topmost point of the baseline (for vertical layout). If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

---

void _shaped_text_draw_outline(shaped: RID, canvas: RID, pos: Vector2, clip_l: float, clip_r: float, outline_size: int, color: Color, oversampling: float) virtual const 

Draw the outline of the shaped text into a canvas item at a given position, with color. pos specifies the leftmost point of the baseline (for horizontal layout) or topmost point of the baseline (for vertical layout). If oversampling is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.

---

RID _shaped_text_duplicate(shaped: RID) virtual required 

Duplicates shaped text buffer.

---

float _shaped_text_fit_to_width(shaped: RID, width: float, justification_flags: BitField[JustificationFlag]) virtual 

Adjusts text width to fit to specified width, returns new text width.

---

float _shaped_text_get_ascent(shaped: RID) virtual required const 

Returns the text ascent (number of pixels above the baseline for horizontal layout or to the left of baseline for vertical).

---

void _shaped_text_get_carets(shaped: RID, position: int, r_caret: CaretInfo*) virtual const 

Returns shapes of the carets corresponding to the character offset position in the text. Returned caret shape is 1 pixel wide rectangle.

---

PackedInt32Array _shaped_text_get_character_breaks(shaped: RID) virtual const 

Returns array of the composite character boundaries.

---

int _shaped_text_get_custom_ellipsis(shaped: RID) virtual const 

Returns ellipsis character used for text clipping.

---

String _shaped_text_get_custom_punctuation(shaped: RID) virtual const 

Returns custom punctuation character list, used for word breaking. If set to empty string, server defaults are used.

---

float _shaped_text_get_descent(shaped: RID) virtual required const 

Returns the text descent (number of pixels below the baseline for horizontal layout or to the right of baseline for vertical).

---

Direction _shaped_text_get_direction(shaped: RID) virtual const 

Returns direction of the text.

---

int _shaped_text_get_dominant_direction_in_range(shaped: RID, start: int, end: int) virtual const 

Returns dominant direction of in the range of text.

---

int _shaped_text_get_ellipsis_glyph_count(shaped: RID) virtual required const 

Returns number of glyphs in the ellipsis.

---

const Glyph* _shaped_text_get_ellipsis_glyphs(shaped: RID) virtual required const 

Returns array of the glyphs in the ellipsis.

---

int _shaped_text_get_ellipsis_pos(shaped: RID) virtual required const 

Returns position of the ellipsis.

---

int _shaped_text_get_glyph_count(shaped: RID) virtual required const 

Returns number of glyphs in the buffer.

---

const Glyph* _shaped_text_get_glyphs(shaped: RID) virtual required const 

Returns an array of glyphs in the visual order.

---

Vector2 _shaped_text_get_grapheme_bounds(shaped: RID, pos: int) virtual const 

Returns composite character's bounds as offsets from the start of the line.

---

Direction _shaped_text_get_inferred_direction(shaped: RID) virtual const 

Returns direction of the text, inferred by the BiDi algorithm.

---

PackedInt32Array _shaped_text_get_line_breaks(shaped: RID, width: float, start: int, break_flags: BitField[LineBreakFlag]) virtual const 

Breaks text to the lines and returns character ranges for each line.

---

PackedInt32Array _shaped_text_get_line_breaks_adv(shaped: RID, width: PackedFloat32Array, start: int, once: bool, break_flags: BitField[LineBreakFlag]) virtual const 

Breaks text to the lines and columns. Returns character ranges for each segment.

---

int _shaped_text_get_object_glyph(shaped: RID, key: Variant) virtual required const 

Returns the glyph index of the inline object.

---

Vector2i _shaped_text_get_object_range(shaped: RID, key: Variant) virtual required const 

Returns the character range of the inline object.

---

Rect2 _shaped_text_get_object_rect(shaped: RID, key: Variant) virtual required const 

Returns bounding rectangle of the inline object.

---

Array _shaped_text_get_objects(shaped: RID) virtual required const 

Returns array of inline objects.

---

Orientation _shaped_text_get_orientation(shaped: RID) virtual const 

Returns text orientation.

---

RID _shaped_text_get_parent(shaped: RID) virtual required const 

Returns the parent buffer from which the substring originates.

---

bool _shaped_text_get_preserve_control(shaped: RID) virtual const 

Returns true if text buffer is configured to display control characters.

---

bool _shaped_text_get_preserve_invalid(shaped: RID) virtual const 

Returns true if text buffer is configured to display hexadecimal codes in place of invalid characters.

---

Vector2i _shaped_text_get_range(shaped: RID) virtual required const 

Returns substring buffer character range in the parent buffer.

---

PackedVector2Array _shaped_text_get_selection(shaped: RID, start: int, end: int) virtual const 

Returns selection rectangles for the specified character range.

---

Vector2 _shaped_text_get_size(shaped: RID) virtual required const 

Returns size of the text.

---

int _shaped_text_get_spacing(shaped: RID, spacing: SpacingType) virtual const 

Returns extra spacing added between glyphs or lines in pixels.

---

int _shaped_text_get_trim_pos(shaped: RID) virtual required const 

Returns the position of the overrun trim.

---

float _shaped_text_get_underline_position(shaped: RID) virtual required const 

Returns pixel offset of the underline below the baseline.

---

float _shaped_text_get_underline_thickness(shaped: RID) virtual required const 

Returns thickness of the underline.

---

float _shaped_text_get_width(shaped: RID) virtual required const 

Returns width (for horizontal layout) or height (for vertical) of the text.

---

PackedInt32Array _shaped_text_get_word_breaks(shaped: RID, grapheme_flags: BitField[GraphemeFlag], skip_grapheme_flags: BitField[GraphemeFlag]) virtual const 

Breaks text into words and returns array of character ranges. Use grapheme_flags to set what characters are used for breaking.

---

bool _shaped_text_has_object(shaped: RID, key: Variant) virtual required const 

Returns true if an object with key is embedded in this shaped text buffer.

---

int _shaped_text_hit_test_grapheme(shaped: RID, coord: float) virtual const 

Returns grapheme index at the specified pixel offset at the baseline, or -1 if none is found.

---

int _shaped_text_hit_test_position(shaped: RID, coord: float) virtual const 

Returns caret character offset at the specified pixel offset at the baseline. This function always returns a valid position.

---

bool _shaped_text_is_ready(shaped: RID) virtual required const 

Returns true if buffer is successfully shaped.

---

int _shaped_text_next_character_pos(shaped: RID, pos: int) virtual const 

Returns composite character end position closest to the pos.

---

int _shaped_text_next_grapheme_pos(shaped: RID, pos: int) virtual const 

Returns grapheme end position closest to the pos.

---

void _shaped_text_overrun_trim_to_width(shaped: RID, width: float, trim_flags: BitField[TextOverrunFlag]) virtual 

Trims text if it exceeds the given width.

---

int _shaped_text_prev_character_pos(shaped: RID, pos: int) virtual const 

Returns composite character start position closest to the pos.

---

int _shaped_text_prev_grapheme_pos(shaped: RID, pos: int) virtual const 

Returns grapheme start position closest to the pos.

---

bool _shaped_text_resize_object(shaped: RID, key: Variant, size: Vector2, inline_align: InlineAlignment, baseline: float) virtual required 

Sets new size and alignment of embedded object.

---

void _shaped_text_set_bidi_override(shaped: RID, override: Array) virtual 

Overrides BiDi for the structured text.

---

void _shaped_text_set_custom_ellipsis(shaped: RID, char: int) virtual 

Sets ellipsis character used for text clipping.

---

void _shaped_text_set_custom_punctuation(shaped: RID, punct: String) virtual 

Sets custom punctuation character list, used for word breaking. If set to empty string, server defaults are used.

---

void _shaped_text_set_direction(shaped: RID, direction: Direction) virtual 

Sets desired text direction. If set to TextServer.DIRECTION_AUTO, direction will be detected based on the buffer contents and current locale.

---

void _shaped_text_set_orientation(shaped: RID, orientation: Orientation) virtual 

Sets desired text orientation.

---

void _shaped_text_set_preserve_control(shaped: RID, enabled: bool) virtual 

If set to true text buffer will display control characters.

---

void _shaped_text_set_preserve_invalid(shaped: RID, enabled: bool) virtual 

If set to true text buffer will display invalid characters as hexadecimal codes, otherwise nothing is displayed.

---

void _shaped_text_set_spacing(shaped: RID, spacing: SpacingType, value: int) virtual 

Sets extra spacing added between glyphs or lines in pixels.

---

bool _shaped_text_shape(shaped: RID) virtual required 

Shapes buffer if it's not shaped. Returns true if the string is shaped successfully.

---

const Glyph* _shaped_text_sort_logical(shaped: RID) virtual required 

Returns text glyphs in the logical order.

---

RID _shaped_text_substr(shaped: RID, start: int, length: int) virtual required const 

Returns text buffer for the substring of the text in the shaped text buffer (including inline objects).

---

float _shaped_text_tab_align(shaped: RID, tab_stops: PackedFloat32Array) virtual 

Aligns shaped text to the given tab-stops.

---

bool _shaped_text_update_breaks(shaped: RID) virtual 

Updates break points in the shaped text. This method is called by default implementation of text breaking functions.

---

bool _shaped_text_update_justification_ops(shaped: RID) virtual 

Updates justification points in the shaped text. This method is called by default implementation of text justification functions.

---

bool _spoof_check(string: String) virtual const 

Returns true if string is likely to be an attempt at confusing the reader.

---

PackedInt32Array _string_get_character_breaks(string: String, language: String) virtual const 

Returns array of the composite character boundaries.

---

PackedInt32Array _string_get_word_breaks(string: String, language: String, chars_per_line: int) virtual const 

Returns an array of the word break boundaries. Elements in the returned array are the offsets of the start and end of words. Therefore the length of the array is always even.

---

String _string_to_lower(string: String, language: String) virtual const 

Returns the string converted to lowercase.

---

String _string_to_title(string: String, language: String) virtual const 

Returns the string converted to Title Case.

---

String _string_to_upper(string: String, language: String) virtual const 

Returns the string converted to UPPERCASE.

---

String _strip_diacritics(string: String) virtual const 

Strips diacritics from the string.

---

String _tag_to_name(tag: int) virtual const 

Converts the given OpenType tag to the readable name of a feature, variation, script, or language.

---

void _unreference_oversampling_level(oversampling: float) virtual 

Decreases the reference count of the specified oversampling level, and frees the font cache for oversampling level when the reference count reaches zero. This method is called by Viewport, and should not be used directly.
