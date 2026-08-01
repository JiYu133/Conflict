# StyleBoxLine

Inherits: StyleBox < Resource < RefCounted < Object

A StyleBox that displays a single line of a given color and thickness.

## Description

A StyleBox that displays a single line of a given color and thickness. The line can be either horizontal or vertical. Useful for separators.

## Properties

Color | color | Color(0, 0, 0, 1)
float | grow_begin | 1.0
float | grow_end | 1.0
int | thickness | 1
bool | vertical | false

---

## Property Descriptions

Color color = Color(0, 0, 0, 1) 

- void set_color(value: Color)
- Color get_color()

The line's color.

---

float grow_begin = 1.0 

- void set_grow_begin(value: float)
- float get_grow_begin()

The number of pixels the line will extend before the StyleBoxLine's bounds. If set to a negative value, the line will begin inside the StyleBoxLine's bounds.

---

float grow_end = 1.0 

- void set_grow_end(value: float)
- float get_grow_end()

The number of pixels the line will extend past the StyleBoxLine's bounds. If set to a negative value, the line will end inside the StyleBoxLine's bounds.

---

int thickness = 1 

- void set_thickness(value: int)
- int get_thickness()

The line's thickness in pixels.

---

bool vertical = false 

- void set_vertical(value: bool)
- bool is_vertical()

If true, the line will be vertical. If false, the line will be horizontal.
