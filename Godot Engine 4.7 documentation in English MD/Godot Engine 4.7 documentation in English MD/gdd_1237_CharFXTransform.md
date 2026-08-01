# CharFXTransform

Inherits: RefCounted < Object

Controls how an individual character will be displayed in a RichTextEffect.

## Description

By setting various properties on this object, you can control how individual characters will be displayed in a RichTextEffect.

## Tutorials

- BBCode in RichTextLabel

## Properties

Color | color | Color(0, 0, 0, 1)
float | elapsed_time | 0.0
Dictionary | env | {}
RID | font | RID()
int | glyph_count | 0
int | glyph_flags | 0
int | glyph_index | 0
Vector2 | offset | Vector2(0, 0)
bool | outline | false
Vector2i | range | Vector2i(0, 0)
int | relative_index | 0
Transform2D | transform | Transform2D(1, 0, 0, 1, 0, 0)
bool | visible | true

---

## Property Descriptions

Color color = Color(0, 0, 0, 1) 

- void set_color(value: Color)
- Color get_color()

The color the character will be drawn with.

---

float elapsed_time = 0.0 

- void set_elapsed_time(value: float)
- float get_elapsed_time()

The time elapsed since the RichTextLabel was added to the scene tree (in seconds). Time stops when the RichTextLabel is paused (see Node.process_mode). Resets when the text in the RichTextLabel is changed.

Note: Time still passes while the RichTextLabel is hidden.

---

Dictionary env = {} 

- void set_environment(value: Dictionary)
- Dictionary get_environment()

Contains the arguments passed in the opening BBCode tag. By default, arguments are strings; if their contents match a type such as bool, int or float, they will be converted automatically. Color codes in the form #rrggbb or #rgb will be converted to an opaque Color. String arguments may not contain spaces, even if they're quoted. If present, quotes will also be present in the final string.

For example, the opening BBCode tag [example foo=hello bar=true baz=42 color=#ffffff] will map to the following Dictionary:

```gdscript
{"foo": "hello", "bar": true, "baz": 42, "color": Color(1, 1, 1, 1)}
```

---

RID font = RID() 

- void set_font(value: RID)
- RID get_font()

TextServer RID of the font used to render glyph, this value can be used with TextServer.font_* methods to retrieve font information.

Note: Read-only. Setting this property won't affect drawing.

---

int glyph_count = 0 

- void set_glyph_count(value: int)
- int get_glyph_count()

Number of glyphs in the grapheme cluster. This value is set in the first glyph of a cluster.

Note: Read-only. Setting this property won't affect drawing.

---

int glyph_flags = 0 

- void set_glyph_flags(value: int)
- int get_glyph_flags()

Glyph flags. See GraphemeFlag for more info.

Note: Read-only. Setting this property won't affect drawing.

---

int glyph_index = 0 

- void set_glyph_index(value: int)
- int get_glyph_index()

Glyph index specific to the font. If you want to replace this glyph, use TextServer.font_get_glyph_index() with font to get a new glyph index for a single character.

---

Vector2 offset = Vector2(0, 0) 

- void set_offset(value: Vector2)
- Vector2 get_offset()

The position offset the character will be drawn with (in pixels).

---

bool outline = false 

- void set_outline(value: bool)
- bool is_outline()

If true, FX transform is called for outline drawing.

Note: Read-only. Setting this property won't affect drawing.

---

Vector2i range = Vector2i(0, 0) 

- void set_range(value: Vector2i)
- Vector2i get_range()

Absolute character range in the string, corresponding to the glyph.

Note: Read-only. Setting this property won't affect drawing.

---

int relative_index = 0 

- void set_relative_index(value: int)
- int get_relative_index()

The character offset of the glyph, relative to the current RichTextEffect custom block.

Note: Read-only. Setting this property won't affect drawing.

---

Transform2D transform = Transform2D(1, 0, 0, 1, 0, 0) 

- void set_transform(value: Transform2D)
- Transform2D get_transform()

The current transform of the current glyph. It can be overridden (for example, by driving the position and rotation from a curve). You can also alter the existing value to apply transforms on top of other effects.

---

bool visible = true 

- void set_visibility(value: bool)
- bool is_visible()

If true, the character will be drawn. If false, the character will be hidden. Characters around hidden characters will reflow to take the space of hidden characters. If this is not desired, set their color to Color(1, 1, 1, 0) instead.
