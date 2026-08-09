# Label

Inherits: Control < CanvasItem < Node < Object

A control for displaying plain text.

## Description

A control for displaying plain text. It gives you control over the horizontal and vertical alignment and can wrap the text inside the node's bounding rectangle. It doesn't support bold, italics, or other rich text formatting. For that, use RichTextLabel instead.

Note: A single Label node is not designed to display huge amounts of text. To display large amounts of text in a single node, consider using RichTextLabel instead as it supports features like an integrated scroll bar and threading. RichTextLabel generally performs better when displaying large amounts of text (several pages or more).

## Tutorials

- 2D Dodge The Creeps Demo [https://godotengine.org/asset-library/asset/2712]

## Properties

AutowrapMode | autowrap_mode | 0
BitField[LineBreakFlag] | autowrap_trim_flags | 192
bool | clip_text | false
String | ellipsis_char | "…"
HorizontalAlignment | horizontal_alignment | 0
BitField[JustificationFlag] | justification_flags | 163
LabelSettings | label_settings |
String | language | ""
int | lines_skipped | 0
int | max_lines_visible | -1
MouseFilter | mouse_filter | 2 (overrides Control)
String | paragraph_separator | "\\n"
BitField[SizeFlags] | size_flags_vertical | 4 (overrides Control)
StructuredTextParser | structured_text_bidi_override | 0
Array | structured_text_bidi_override_options | []
PackedFloat32Array | tab_stops | PackedFloat32Array()
String | text | ""
TextDirection | text_direction | 0
OverrunBehavior | text_overrun_behavior | 0
bool | uppercase | false
VerticalAlignment | vertical_alignment | 0
int | visible_characters | -1
VisibleCharactersBehavior | visible_characters_behavior | 0
float | visible_ratio | 1.0

## Methods

Rect2 | get_character_bounds(pos: int) const
int | get_line_count() const
int | get_line_height(line: int = -1) const
int | get_total_character_count() const
int | get_visible_line_count() const

## Theme Properties

Color | font_color | Color(1, 1, 1, 1)
Color | font_outline_color | Color(0, 0, 0, 1)
Color | font_shadow_color | Color(0, 0, 0, 0)
int | line_spacing | 3
int | outline_size | 0
int | paragraph_spacing | 0
int | shadow_offset_x | 1
int | shadow_offset_y | 1
int | shadow_outline_size | 1
Font | font |
int | font_size |
StyleBox | focus |
StyleBox | normal |

---

## Property Descriptions

AutowrapMode autowrap_mode = 0 

- void set_autowrap_mode(value: AutowrapMode)
- AutowrapMode get_autowrap_mode()

If set to something other than TextServer.AUTOWRAP_OFF, the text gets wrapped inside the node's bounding rectangle. If you resize the node, it will change its height automatically to show all the text.

Note: Labels with autowrapping enabled must have a custom maximum width configured to work correctly, either through the Label's own Control.custom_maximum_size or as a result of a propagated maximum size from a parent Control with Control.propagate_maximum_size enabled.

---

BitField[LineBreakFlag] autowrap_trim_flags = 192 

- void set_autowrap_trim_flags(value: BitField[LineBreakFlag])
- BitField[LineBreakFlag] get_autowrap_trim_flags()

Autowrap space trimming flags. See TextServer.BREAK_TRIM_START_EDGE_SPACES and TextServer.BREAK_TRIM_END_EDGE_SPACES for more info.

---

bool clip_text = false 

- void set_clip_text(value: bool)
- bool is_clipping_text()

If true, the Label only shows the text that fits inside its bounding rectangle and will clip text horizontally.

---

String ellipsis_char = "…" 

- void set_ellipsis_char(value: String)
- String get_ellipsis_char()

Ellipsis character used for text clipping.

---

HorizontalAlignment horizontal_alignment = 0 

- void set_horizontal_alignment(value: HorizontalAlignment)
- HorizontalAlignment get_horizontal_alignment()

Controls the text's horizontal alignment. Supports left, center, right, and fill (also known as justify).

---

BitField[JustificationFlag] justification_flags = 163 

- void set_justification_flags(value: BitField[JustificationFlag])
- BitField[JustificationFlag] get_justification_flags()

Line fill alignment rules.

---

LabelSettings label_settings 

- void set_label_settings(value: LabelSettings)
- LabelSettings get_label_settings()

A LabelSettings resource that can be shared between multiple Label nodes. Takes priority over theme properties.

---

String language = "" 

- void set_language(value: String)
- String get_language()

Language code used for line-breaking and text shaping algorithms. If left empty, the current locale is used instead.

---

int lines_skipped = 0 

- void set_lines_skipped(value: int)
- int get_lines_skipped()

The number of the lines ignored and not displayed from the start of the text value.

---

int max_lines_visible = -1 

- void set_max_lines_visible(value: int)
- int get_max_lines_visible()

Limits the lines of text the node shows on screen.

---

String paragraph_separator = "\\n" 

- void set_paragraph_separator(value: String)
- String get_paragraph_separator()

String used as a paragraph separator. Each paragraph is processed independently, in its own BiDi context.

---

StructuredTextParser structured_text_bidi_override = 0 

- void set_structured_text_bidi_override(value: StructuredTextParser)
- StructuredTextParser get_structured_text_bidi_override()

Set BiDi algorithm override for the structured text.

---

Array structured_text_bidi_override_options = [] 

- void set_structured_text_bidi_override_options(value: Array)
- Array get_structured_text_bidi_override_options()

Set additional options for BiDi override.

---

PackedFloat32Array tab_stops = PackedFloat32Array() 

- void set_tab_stops(value: PackedFloat32Array)
- PackedFloat32Array get_tab_stops()

Aligns text to the given tab-stops.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedFloat32Array for more details.

---

String text = "" 

- void set_text(value: String)
- String get_text()

The text to display on screen.

---

TextDirection text_direction = 0 

- void set_text_direction(value: TextDirection)
- TextDirection get_text_direction()

Base text writing direction.

---

OverrunBehavior text_overrun_behavior = 0 

- void set_text_overrun_behavior(value: OverrunBehavior)
- OverrunBehavior get_text_overrun_behavior()

The clipping behavior when the text exceeds the node's bounding rectangle.

---

bool uppercase = false 

- void set_uppercase(value: bool)
- bool is_uppercase()

If true, all the text displays as UPPERCASE.

---

VerticalAlignment vertical_alignment = 0 

- void set_vertical_alignment(value: VerticalAlignment)
- VerticalAlignment get_vertical_alignment()

Controls the text's vertical alignment. Supports top, center, bottom, and fill.

---

int visible_characters = -1 

- void set_visible_characters(value: int)
- int get_visible_characters()

The number of characters to display. If set to -1, all characters are displayed. This can be useful when animating the text appearing in a dialog box.

Note: Setting this property updates visible_ratio accordingly.

Note: Characters are counted as Unicode codepoints. A single visible grapheme may contain multiple codepoints (e.g. certain emoji use three codepoints). A single codepoint may contain two UTF-16 characters, which are used in C# strings.

---

VisibleCharactersBehavior visible_characters_behavior = 0 

- void set_visible_characters_behavior(value: VisibleCharactersBehavior)
- VisibleCharactersBehavior get_visible_characters_behavior()

The clipping behavior when visible_characters or visible_ratio is set.

---

float visible_ratio = 1.0 

- void set_visible_ratio(value: float)
- float get_visible_ratio()

The fraction of characters to display, relative to the total number of characters (see get_total_character_count()). If set to 1.0, all characters are displayed. If set to 0.5, only half of the characters will be displayed. This can be useful when animating the text appearing in a dialog box.

Note: Setting this property updates visible_characters accordingly.

---

## Method Descriptions

Rect2 get_character_bounds(pos: int) const 

Returns the bounding rectangle of the character at position pos in the label's local coordinate system. If the character is a non-visual character or pos is outside the valid range, an empty Rect2 is returned. If the character is a part of a composite grapheme, the bounding rectangle of the whole grapheme is returned.

---

int get_line_count() const 

Returns the number of lines of text the Label has.

---

int get_line_height(line: int = -1) const 

Returns the height of the line line.

If line is set to -1, returns the biggest line height.

If there are no lines, returns font size in pixels.

---

int get_total_character_count() const 

Returns the total number of printable characters in the text (excluding spaces and newlines).

---

int get_visible_line_count() const 

Returns the number of lines shown. Useful if the Label's height cannot currently display all lines.

---

## Theme Property Descriptions

Color font_color = Color(1, 1, 1, 1) 

Default text Color of the Label.

---

Color font_outline_color = Color(0, 0, 0, 1) 

The color of text outline.

---

Color font_shadow_color = Color(0, 0, 0, 0) 

Color of the text's shadow effect.

---

int line_spacing = 3 

Additional vertical spacing between lines (in pixels), spacing is added to line descent. This value can be negative.

---

int outline_size = 0 

Text outline size.

Note: If using a font with FontFile.multichannel_signed_distance_field enabled, its FontFile.msdf_pixel_range must be set to at least twice the value of outline_size for outline rendering to look correct. Otherwise, the outline may appear to be cut off earlier than intended.

Note: Using a value that is larger than half the font size is not recommended, as the font outline may fail to be fully closed in this case.

---

int paragraph_spacing = 0 

Vertical space between paragraphs. Added on top of line_spacing.

---

int shadow_offset_x = 1 

The horizontal offset of the text's shadow.

---

int shadow_offset_y = 1 

The vertical offset of the text's shadow.

---

int shadow_outline_size = 1 

The size of the shadow outline.

---

Font font 

Font used for the Label's text.

---

int font_size 

Font size of the Label's text.

---

StyleBox focus 

StyleBox used when the Label is focused (when used with assistive apps).

---

StyleBox normal 

Background StyleBox for the Label.
