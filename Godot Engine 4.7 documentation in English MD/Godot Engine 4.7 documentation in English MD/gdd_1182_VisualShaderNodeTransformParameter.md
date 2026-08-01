# VisualShaderNodeTransformParameter

Inherits: VisualShaderNodeParameter < VisualShaderNode < Resource < RefCounted < Object

A Transform3D parameter for use within the visual shader graph.

## Description

Translated to uniform mat4 in the shader language.

## Properties

Transform3D | default_value | Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)
bool | default_value_enabled | false

---

## Property Descriptions

Transform3D default_value = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0) 

- void set_default_value(value: Transform3D)
- Transform3D get_default_value()

A default value to be assigned within the shader.

---

bool default_value_enabled = false 

- void set_default_value_enabled(value: bool)
- bool is_default_value_enabled()

Enables usage of the default_value.
