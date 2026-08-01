# TextMesh

Inherits: PrimitiveMesh < Mesh < Resource < RefCounted < Object

Generate a PrimitiveMesh from the text.

## Description

Generate a PrimitiveMesh from the text.

TextMesh can be generated only when using dynamic fonts with vector glyph contours. Bitmap fonts (including bitmap data in the TrueType/OpenType containers, like color emoji fonts) are not supported.

The UV layout is arranged in 4 horizontal strips, top to bottom: 40% of the height for the front face, 40% for the back face, 10% for the outer edges and 10% for the inner edges.

## Tutorials

- 3D text

## Properties

AutowrapMode | autowrap_mode | 0
float | curve_step | 0.5
float | depth | 0.05
Font | font |
int | font_size | 16
HorizontalAlignment | horizontal_alignment | 1
BitField[JustificationFlag] | justification_flags | 163
String | language | ""
float | line_spacing | 0.0
Vector2 | offset | Vector2(0, 0)
float | pixel_size | 0.01
StructuredTextParser | structured_text_bidi_override | 0
Array | structured_text_bidi_override_options | []
String | text | ""
Direction | text_direction | 0
bool | uppercase | false
VerticalAlignment | vertical_alignment | 1
float | width | 500.0

---

## Property Descriptions

AutowrapMode autowrap_mode = 0 

- void set_autowrap_mode(value: AutowrapMode)
- AutowrapMode get_autowrap_mode()

If set to something other than TextServer.AUTOWRAP_OFF, the text gets wrapped inside the node's bounding rectangle. If you resize the node, it will change its height automatically to show all the text.

---

float curve_step = 0.5 

- void set_curve_step(value: float)
- float get_curve_step()

Step (in pixels) used to approximate Bézier curves. Lower values result in smoother curves, but is slower to generate and render. Consider adjusting this according to the font size and the typical viewing distance.

Note: Changing this property will regenerate the mesh, which is a slow operation, especially with large font sizes and long texts.

---

float depth = 0.05 

- void set_depth(value: float)
- float get_depth()

Depths of the mesh, if set to 0.0 only front surface, is generated, and UV layout is changed to use full texture for the front face only.

---

Font font 

- void set_font(value: Font)
- Font get_font()

Font configuration used to display text.

---

int font_size = 16 

- void set_font_size(value: int)
- int get_font_size()

Font size of the TextMesh's text. This property works in tandem with pixel_size. Higher values will result in a more detailed font, regardless of curve_step and pixel_size. Consider keeping this value below 63 (inclusive) for good performance, and adjust pixel_size as needed to enlarge text.

Note: Changing this property will regenerate the mesh, which is a slow operation, especially with large font sizes and long texts. To change the text's size in real-time efficiently, change the node's Node3D.scale instead.

---

HorizontalAlignment horizontal_alignment = 1 

- void set_horizontal_alignment(value: HorizontalAlignment)
- HorizontalAlignment get_horizontal_alignment()

Controls the text's horizontal alignment. Supports left, center, right, and fill (also known as justify).

---

BitField[JustificationFlag] justification_flags = 163 

- void set_justification_flags(value: BitField[JustificationFlag])
- BitField[JustificationFlag] get_justification_flags()

Line fill alignment rules.

---

String language = "" 

- void set_language(value: String)
- String get_language()

Language code used for line-breaking and text shaping algorithms. If left empty, the current locale is used instead.

---

float line_spacing = 0.0 

- void set_line_spacing(value: float)
- float get_line_spacing()

Additional vertical spacing between lines (in pixels), spacing is added to line descent. This value can be negative.

---

Vector2 offset = Vector2(0, 0) 

- void set_offset(value: Vector2)
- Vector2 get_offset()

The text drawing offset (in pixels).

Note: Changing this property will regenerate the mesh, which is a slow operation. To change the text's position in real-time efficiently, change the node's Node3D.position instead.

---

float pixel_size = 0.01 

- void set_pixel_size(value: float)
- float get_pixel_size()

The size of one pixel's width on the text to scale it in 3D. This property works in tandem with font_size.

Note: Changing this property will regenerate the mesh, which is a slow operation, especially with large font sizes and long texts. To change the text's size in real-time efficiently, change the node's Node3D.scale instead.

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

String text = "" 

- void set_text(value: String)
- String get_text()

The text to generate mesh from.

Note: Due to being a Resource, it doesn't follow the rules of Node.auto_translate_mode. If disabling translation is desired, it should be done manually with Object.set_message_translation().

---

Direction text_direction = 0 

- void set_text_direction(value: Direction)
- Direction get_text_direction()

Base text writing direction.

---

bool uppercase = false 

- void set_uppercase(value: bool)
- bool is_uppercase()

If true, all the text displays as UPPERCASE.

---

VerticalAlignment vertical_alignment = 1 

- void set_vertical_alignment(value: VerticalAlignment)
- VerticalAlignment get_vertical_alignment()

Controls the text's vertical alignment. Supports top, center, and bottom.

---

float width = 500.0 

- void set_width(value: float)
- float get_width()

Text width (in pixels), used for fill alignment.
