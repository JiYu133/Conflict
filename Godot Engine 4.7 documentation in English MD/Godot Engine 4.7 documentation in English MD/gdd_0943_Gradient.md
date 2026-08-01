# Gradient

Inherits: Resource < RefCounted < Object

A color transition.

## Description

This resource describes a color transition by defining a set of colored points and how to interpolate between them.

See also Curve which supports more complex easing methods, but does not support colors.

## Properties

PackedColorArray | colors | PackedColorArray(0, 0, 0, 1, 1, 1, 1, 1)
ColorSpace | interpolation_color_space | 0
InterpolationMode | interpolation_mode | 0
PackedFloat32Array | offsets | PackedFloat32Array(0, 1)

## Methods

void | add_point(offset: float, color: Color)
Color | get_color(point: int)
float | get_offset(point: int)
int | get_point_count() const
void | remove_point(point: int)
void | reverse()
Color | sample(offset: float)
void | set_color(point: int, color: Color)
void | set_offset(point: int, offset: float)

---

## Enumerations

enum InterpolationMode
InterpolationMode GRADIENT_INTERPOLATE_LINEAR = 0

Linear interpolation.

InterpolationMode GRADIENT_INTERPOLATE_CONSTANT = 1

Constant interpolation, color changes abruptly at each point and stays uniform between. This might cause visible aliasing when used for a gradient texture in some cases.

InterpolationMode GRADIENT_INTERPOLATE_CUBIC = 2

Cubic interpolation.

---

enum ColorSpace
ColorSpace GRADIENT_COLOR_SPACE_SRGB = 0

sRGB color space.

ColorSpace GRADIENT_COLOR_SPACE_LINEAR_SRGB = 1

Linear sRGB color space.

ColorSpace GRADIENT_COLOR_SPACE_OKLAB = 2

Oklab [https://bottosson.github.io/posts/oklab/] color space. This color space provides a smooth and uniform-looking transition between colors.

---

## Property Descriptions

PackedColorArray colors = PackedColorArray(0, 0, 0, 1, 1, 1, 1, 1) 

- void set_colors(value: PackedColorArray)
- PackedColorArray get_colors()

Gradient's colors as a PackedColorArray.

Note: Setting this property updates all colors at once. To update any color individually use set_color().

Note: The returned array is copied and any changes to it will not update the original property value. See PackedColorArray for more details.

---

ColorSpace interpolation_color_space = 0 

- void set_interpolation_color_space(value: ColorSpace)
- ColorSpace get_interpolation_color_space()

The color space used to interpolate between points of the gradient. It does not affect the returned colors, which will always use nonlinear sRGB encoding.

Note: This setting has no effect when interpolation_mode is set to GRADIENT_INTERPOLATE_CONSTANT.

---

InterpolationMode interpolation_mode = 0 

- void set_interpolation_mode(value: InterpolationMode)
- InterpolationMode get_interpolation_mode()

The algorithm used to interpolate between points of the gradient.

---

PackedFloat32Array offsets = PackedFloat32Array(0, 1) 

- void set_offsets(value: PackedFloat32Array)
- PackedFloat32Array get_offsets()

Gradient's offsets as a PackedFloat32Array.

Note: Setting this property updates all offsets at once. To update any offset individually use set_offset().

Note: The returned array is copied and any changes to it will not update the original property value. See PackedFloat32Array for more details.

---

## Method Descriptions

void add_point(offset: float, color: Color) 

Adds the specified color to the gradient, with the specified offset.

---

Color get_color(point: int) 

Returns the color of the gradient color at index point.

---

float get_offset(point: int) 

Returns the offset of the gradient color at index point.

---

int get_point_count() const 

Returns the number of colors in the gradient.

---

void remove_point(point: int) 

Removes the color at index point.

---

void reverse() 

Reverses/mirrors the gradient.

Note: This method mirrors all points around the middle of the gradient, which may produce unexpected results when interpolation_mode is set to GRADIENT_INTERPOLATE_CONSTANT.

---

Color sample(offset: float) 

Returns the interpolated color specified by offset. offset should be between 0.0 and 1.0 (inclusive). Using a value lower than 0.0 will return the same color as 0.0, and using a value higher than 1.0 will return the same color as 1.0. If your input value is not within this range, consider using @GlobalScope.remap() on the input value with output values set to 0.0 and 1.0.

---

void set_color(point: int, color: Color) 

Sets the color of the gradient color at index point.

---

void set_offset(point: int, offset: float) 

Sets the offset for the gradient color at index point.
