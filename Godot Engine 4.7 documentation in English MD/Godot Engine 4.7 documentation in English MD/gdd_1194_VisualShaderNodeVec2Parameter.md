# VisualShaderNodeVec2Parameter

Inherits: VisualShaderNodeParameter < VisualShaderNode < Resource < RefCounted < Object

A Vector2 parameter to be used within the visual shader graph.

## Description

Translated to uniform vec2 in the shader language.

## Properties

Vector2 | default_value | Vector2(0, 0)
bool | default_value_enabled | false

---

## Property Descriptions

Vector2 default_value = Vector2(0, 0) 

- void set_default_value(value: Vector2)
- Vector2 get_default_value()

A default value to be assigned within the shader.

---

bool default_value_enabled = false 

- void set_default_value_enabled(value: bool)
- bool is_default_value_enabled()

Enables usage of the default_value.
