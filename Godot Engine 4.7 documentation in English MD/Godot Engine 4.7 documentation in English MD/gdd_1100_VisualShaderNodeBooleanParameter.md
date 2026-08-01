# VisualShaderNodeBooleanParameter

Inherits: VisualShaderNodeParameter < VisualShaderNode < Resource < RefCounted < Object

A boolean parameter to be used within the visual shader graph.

## Description

Translated to uniform bool in the shader language.

## Properties

bool | default_value | false
bool | default_value_enabled | false

---

## Property Descriptions

bool default_value = false 

- void set_default_value(value: bool)
- bool get_default_value()

A default value to be assigned within the shader.

---

bool default_value_enabled = false 

- void set_default_value_enabled(value: bool)
- bool is_default_value_enabled()

Enables usage of the default_value.
