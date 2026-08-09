# VisualShaderNodeExpression

Inherits: VisualShaderNodeGroupBase < VisualShaderNodeResizableBase < VisualShaderNode < Resource < RefCounted < Object

Inherited By: VisualShaderNodeGlobalExpression

A custom visual shader graph expression written in Godot Shading Language.

## Description

Custom Godot Shading Language expression, with a custom number of input and output ports.

The provided code is directly injected into the graph's matching shader function (vertex, fragment, or light), so it cannot be used to declare functions, varyings, uniforms, or global constants. See VisualShaderNodeGlobalExpression for such global definitions.

## Properties

String | expression | ""

---

## Property Descriptions

String expression = "" 

- void set_expression(value: String)
- String get_expression()

An expression in Godot Shading Language, which will be injected at the start of the graph's matching shader function (vertex, fragment, or light), and thus cannot be used to declare functions, varyings, uniforms, or global constants.
