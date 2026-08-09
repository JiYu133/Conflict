# GLTFLight

Inherits: Resource < RefCounted < Object

Represents a glTF light.

## Description

Represents a light as defined by the KHR_lights_punctual glTF extension.

## Tutorials

- Runtime file loading and saving
- KHR_lights_punctual glTF extension spec [https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_lights_punctual]

## Properties

Color | color | Color(1, 1, 1, 1)
float | inner_cone_angle | 0.0
float | intensity | 1.0
String | light_type | ""
float | outer_cone_angle | 0.7853982
float | range | inf

## Methods

GLTFLight | from_dictionary(dictionary: Dictionary) static
GLTFLight | from_node(light_node: Light3D) static
Variant | get_additional_data(extension_name: StringName)
void | set_additional_data(extension_name: StringName, additional_data: Variant)
Dictionary | to_dictionary() const
Light3D | to_node() const

---

## Property Descriptions

Color color = Color(1, 1, 1, 1) 

- void set_color(value: Color)
- Color get_color()

The Color of the light in linear space. Defaults to white. A black color causes the light to have no effect.

This value is linear to match glTF, but will be converted to nonlinear sRGB when creating a Godot Light3D node upon import, or converted to linear when exporting a Godot Light3D to glTF.

---

float inner_cone_angle = 0.0 

- void set_inner_cone_angle(value: float)
- float get_inner_cone_angle()

The inner angle of the cone in a spotlight. Must be less than or equal to the outer cone angle.

Within this angle, the light is at full brightness. Between the inner and outer cone angles, there is a transition from full brightness to zero brightness. When creating a Godot SpotLight3D, the ratio between the inner and outer cone angles is used to calculate the attenuation of the light.

---

float intensity = 1.0 

- void set_intensity(value: float)
- float get_intensity()

The intensity of the light. This is expressed in candelas (lumens per steradian) for point and spot lights, and lux (lumens per m²) for directional lights. When creating a Godot light, this value is converted to a unitless multiplier.

---

String light_type = "" 

- void set_light_type(value: String)
- String get_light_type()

The type of the light. The values accepted by Godot are "point", "spot", and "directional", which correspond to Godot's OmniLight3D, SpotLight3D, and DirectionalLight3D respectively.

---

float outer_cone_angle = 0.7853982 

- void set_outer_cone_angle(value: float)
- float get_outer_cone_angle()

The outer angle of the cone in a spotlight. Must be greater than or equal to the inner angle.

At this angle, the light drops off to zero brightness. Between the inner and outer cone angles, there is a transition from full brightness to zero brightness. If this angle is a half turn, then the spotlight emits in all directions. When creating a Godot SpotLight3D, the outer cone angle is used as the angle of the spotlight.

---

float range = inf 

- void set_range(value: float)
- float get_range()

The range of the light, beyond which the light has no effect. glTF lights with no range defined behave like physical lights (which have infinite range). When creating a Godot light, the range is clamped to 4096.0.

---

## Method Descriptions

GLTFLight from_dictionary(dictionary: Dictionary) static 

Creates a new GLTFLight instance by parsing the given Dictionary.

---

GLTFLight from_node(light_node: Light3D) static 

Create a new GLTFLight instance from the given Godot Light3D node.

---

Variant get_additional_data(extension_name: StringName) 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void set_additional_data(extension_name: StringName, additional_data: Variant) 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Dictionary to_dictionary() const 

Serializes this GLTFLight instance into a Dictionary.

---

Light3D to_node() const 

Converts this GLTFLight instance into a Godot Light3D node.
