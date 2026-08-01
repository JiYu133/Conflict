# VisualShaderNodeVarying

Inherits: VisualShaderNode < Resource < RefCounted < Object

Inherited By: VisualShaderNodeVaryingGetter, VisualShaderNodeVaryingSetter

A visual shader node that represents a "varying" shader value.

## Description

Varying values are shader variables that can be passed between shader functions, e.g. from Vertex shader to Fragment shader.

## Properties

String | varying_name | "[None]"
VaryingType | varying_type | 0

---

## Property Descriptions

String varying_name = "[None]" 

- void set_varying_name(value: String)
- String get_varying_name()

Name of the variable. Must be unique.

---

VaryingType varying_type = 0 

- void set_varying_type(value: VaryingType)
- VaryingType get_varying_type()

Type of the variable. Determines where the variable can be accessed.
