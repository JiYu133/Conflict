# VisualShaderNodeIntFunc

Inherits: VisualShaderNode < Resource < RefCounted < Object

A scalar integer function to be used within the visual shader graph.

## Description

Accept an integer scalar (x) to the input port and transform it according to function.

## Properties

Function | function | 2

---

## Enumerations

enum Function
Function FUNC_ABS = 0

Returns the absolute value of the parameter. Translates to abs(x) in the Godot Shader Language.

Function FUNC_NEGATE = 1

Negates the x using -(x).

Function FUNC_SIGN = 2

Extracts the sign of the parameter. Translates to sign(x) in the Godot Shader Language.

Function FUNC_BITWISE_NOT = 3

Returns the result of bitwise NOT operation on the integer. Translates to ~a in the Godot Shader Language.

Function FUNC_MAX = 4

Represents the size of the Function enum.

---

## Property Descriptions

Function function = 2 

- void set_function(value: Function)
- Function get_function()

A function to be applied to the scalar.
