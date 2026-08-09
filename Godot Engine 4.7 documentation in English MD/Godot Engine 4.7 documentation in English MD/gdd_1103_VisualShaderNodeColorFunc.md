# VisualShaderNodeColorFunc

Inherits: VisualShaderNode < Resource < RefCounted < Object

A Color function to be used within the visual shader graph.

## Description

Accept a Color to the input port and transform it according to function.

## Properties

Function | function | 0

---

## Enumerations

enum Function
Function FUNC_GRAYSCALE = 0

Converts the color to grayscale using the following formula:

```gdscript
vec3 c = input;
float max1 = max(c.r, c.g);
float max2 = max(max1, c.b);
float max3 = max(max1, max2);
return vec3(max3, max3, max3);
```

Function FUNC_HSV2RGB = 1

Converts HSV vector to RGB equivalent.

Function FUNC_RGB2HSV = 2

Converts RGB vector to HSV equivalent.

Function FUNC_SEPIA = 3

Applies sepia tone effect using the following formula:

```gdscript
vec3 c = input;
float r = (c.r * 0.393) + (c.g * 0.769) + (c.b * 0.189);
float g = (c.r * 0.349) + (c.g * 0.686) + (c.b * 0.168);
float b = (c.r * 0.272) + (c.g * 0.534) + (c.b * 0.131);
return vec3(r, g, b);
```

Function FUNC_LINEAR_TO_SRGB = 4

Converts color from linear encoding to nonlinear sRGB encoding using the following formula:

```gdscript
const vec3 a = vec3(0.055f);
return mix((vec3(1.0f) + a) * pow(c.rgb, vec3(1.0f / 2.4f)) - a, 12.92f * c.rgb, lessThan(c.rgb, vec3(0.0031308f)));
```

The Compatibility renderer uses a simpler formula that may produce undefined behavior with negative input values:

```gdscript
vec3 c = input;
return max(vec3(1.055) * pow(c, vec3(0.416666667)) - vec3(0.055), vec3(0.0));
```

Function FUNC_SRGB_TO_LINEAR = 5

Converts color from nonlinear sRGB encoding to linear encoding using the following formula:

```gdscript
vec3 c = input;
return mix(pow((c.rgb + vec3(0.055)) * (1.0 / (1.0 + 0.055)), vec3(2.4)), c.rgb * (1.0 / 12.92), lessThan(c.rgb, vec3(0.04045)));
```

The Compatibility renderer uses a simpler formula that behaves poorly with negative input values:

```gdscript
vec3 c = input;
return c * (c * (c * 0.305306011 + 0.682171111) + 0.012522878);
```

Function FUNC_MAX = 6

Represents the size of the Function enum.

---

## Property Descriptions

Function function = 0 

- void set_function(value: Function)
- Function get_function()

A function to be applied to the input color.
