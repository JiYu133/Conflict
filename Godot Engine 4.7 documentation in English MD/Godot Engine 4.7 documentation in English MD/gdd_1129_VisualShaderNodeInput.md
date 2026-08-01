# VisualShaderNodeInput

Inherits: VisualShaderNode < Resource < RefCounted < Object

Represents the input shader parameter within the visual shader graph.

## Description

Gives access to input variables (built-ins) available for the shader. See the shading reference for the list of available built-ins for each shader type (check Tutorials section for link).

## Tutorials

- Shading reference index

## Properties

String | input_name | "[None]"

## Methods

String | get_input_real_name() const

---

## Signals

input_type_changed() 

Emitted when input is changed via input_name.

---

## Property Descriptions

String input_name = "[None]" 

- void set_input_name(value: String)
- String get_input_name()

One of the several input constants in lower-case style like: "vertex" (VERTEX) or "point_size" (POINT_SIZE).

---

## Method Descriptions

String get_input_real_name() const 

Returns a translated name of the current constant in the Godot Shader Language. E.g. "ALBEDO" if the input_name equal to "albedo".
