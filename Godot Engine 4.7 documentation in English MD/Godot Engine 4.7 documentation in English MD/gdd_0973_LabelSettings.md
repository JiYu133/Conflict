# LabelSettings

Inherits: Resource < RefCounted < Object

Provides common settings to customize the text in a Label.

## Description

LabelSettings is a resource that provides common settings to customize the text in a Label. It will take priority over the properties defined in Control.theme. The resource can be shared between multiple labels and changed on the fly, so it's convenient and flexible way to setup text style.

## Properties

Font | font |
Color | font_color | Color(1, 1, 1, 1)
int | font_size | 16
float | line_spacing | 3.0
Color | outline_color | Color(1, 1, 1, 1)
int | outline_size | 0
float | paragraph_spacing | 0.0
Color | shadow_color | Color(0, 0, 0, 0)
Vector2 | shadow_offset | Vector2(1, 1)
int | shadow_size | 1
int | stacked_outline_count | 0
Color | stacked_outline_{index}/color | Color(0, 0, 0, 1)
int | stacked_outline_{index}/size | 0
int | stacked_shadow_count | 0
Color | stacked_shadow_{index}/color | Color(0, 0, 0, 1)
Vector2 | stacked_shadow_{index}/offset | Vector2(1, 1)
int | stacked_shadow_{index}/outline_size | 0

## Methods

void | add_stacked_outline(index: int = -1)
void | add_stacked_shadow(index: int = -1)
Color | get_stacked_outline_color(index: int) const
int | get_stacked_outline_size(index: int) const
Color | get_stacked_shadow_color(index: int) const
Vector2 | get_stacked_shadow_offset(index: int) const
int | get_stacked_shadow_outline_size(index: int) const
void | move_stacked_outline(from_index: int, to_position: int)
void | move_stacked_shadow(from_index: int, to_position: int)
void | remove_stacked_outline(index: int)
void | remove_stacked_shadow(index: int)
void | set_stacked_outline_color(index: int, color: Color)
void | set_stacked_outline_size(index: int, size: int)
void | set_stacked_shadow_color(index: int, color: Color)
void | set_stacked_shadow_offset(index: int, offset: Vector2)
void | set_stacked_shadow_outline_size(index: int, size: int)

---

## Property Descriptions

Font font 

- void set_font(value: Font)
- Font get_font()

Font used for the text.

---

Color font_color = Color(1, 1, 1, 1) 

- void set_font_color(value: Color)
- Color get_font_color()

Color of the text.

---

int font_size = 16 

- void set_font_size(value: int)
- int get_font_size()

Size of the text.

---

float line_spacing = 3.0 

- void set_line_spacing(value: float)
- float get_line_spacing()

Additional vertical spacing between lines (in pixels), spacing is added to line descent. This value can be negative.

---

Color outline_color = Color(1, 1, 1, 1) 

- void set_outline_color(value: Color)
- Color get_outline_color()

The color of the outline.

---

int outline_size = 0 

- void set_outline_size(value: int)
- int get_outline_size()

Text outline size.

---

float paragraph_spacing = 0.0 

- void set_paragraph_spacing(value: float)
- float get_paragraph_spacing()

Vertical space between paragraphs. Added on top of line_spacing.

---

Color shadow_color = Color(0, 0, 0, 0) 

- void set_shadow_color(value: Color)
- Color get_shadow_color()

Color of the shadow effect. If alpha is 0, no shadow will be drawn.

---

Vector2 shadow_offset = Vector2(1, 1) 

- void set_shadow_offset(value: Vector2)
- Vector2 get_shadow_offset()

Offset of the shadow effect, in pixels.

---

int shadow_size = 1 

- void set_shadow_size(value: int)
- int get_shadow_size()

Size of the shadow effect.

---

int stacked_outline_count = 0 

- void set_stacked_outline_count(value: int)
- int get_stacked_outline_count()

The number of stacked outlines.

---

Color stacked_outline_{index}/color = Color(0, 0, 0, 1) 

The color of the outline at index.

Note: index is a value in the 0 .. stacked_outline_count - 1 range.

---

int stacked_outline_{index}/size = 0 

The size of the outline at index.

Note: index is a value in the 0 .. stacked_outline_count - 1 range.

---

int stacked_shadow_count = 0 

- void set_stacked_shadow_count(value: int)
- int get_stacked_shadow_count()

The number of stacked shadows.

---

Color stacked_shadow_{index}/color = Color(0, 0, 0, 1) 

The color of the shadow at index.

Note: index is a value in the 0 .. stacked_shadow_count - 1 range.

---

Vector2 stacked_shadow_{index}/offset = Vector2(1, 1) 

The offset of the shadow at index.

Note: index is a value in the 0 .. stacked_shadow_count - 1 range.

---

int stacked_shadow_{index}/outline_size = 0 

The size of the shadow outline at index.

Note: index is a value in the 0 .. stacked_shadow_count - 1 range.

---

## Method Descriptions

void add_stacked_outline(index: int = -1) 

Adds a new stacked outline to the label at the given index. If index is -1, the new stacked outline will be added at the end of the list.

---

void add_stacked_shadow(index: int = -1) 

Adds a new stacked shadow to the label at the given index. If index is -1, the new stacked shadow will be added at the end of the list.

---

Color get_stacked_outline_color(index: int) const 

Returns the color of the stacked outline at index.

---

int get_stacked_outline_size(index: int) const 

Returns the size of the stacked outline at index.

---

Color get_stacked_shadow_color(index: int) const 

Returns the color of the stacked shadow at index.

---

Vector2 get_stacked_shadow_offset(index: int) const 

Returns the offset of the stacked shadow at index.

---

int get_stacked_shadow_outline_size(index: int) const 

Returns the outline size of the stacked shadow at index.

---

void move_stacked_outline(from_index: int, to_position: int) 

Moves the stacked outline at index from_index to the given position to_position in the array.

---

void move_stacked_shadow(from_index: int, to_position: int) 

Moves the stacked shadow at index from_index to the given position to_position in the array.

---

void remove_stacked_outline(index: int) 

Removes the stacked outline at index index.

---

void remove_stacked_shadow(index: int) 

Removes the stacked shadow at index index.

---

void set_stacked_outline_color(index: int, color: Color) 

Sets the color of the stacked outline identified by the given index to color.

---

void set_stacked_outline_size(index: int, size: int) 

Sets the size of the stacked outline identified by the given index to size.

---

void set_stacked_shadow_color(index: int, color: Color) 

Sets the color of the stacked shadow identified by the given index to color.

---

void set_stacked_shadow_offset(index: int, offset: Vector2) 

Sets the offset of the stacked shadow identified by the given index to offset.

---

void set_stacked_shadow_outline_size(index: int, size: int) 

Sets the outline size of the stacked shadow identified by the given index to size.
