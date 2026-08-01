# VisualShaderNodeUIntFunc

Inherits: VisualShaderNode < Resource < RefCounted < Object

An unsigned scalar integer function to be used within the visual shader graph.

## Description

Accept an unsigned integer scalar (x) to the input port and transform it according to function.

## Properties

Function | function | 0

---

## Enumerations

enum Function
Function FUNC_NEGATE = 0

Negates the x using -(x).

Function FUNC_BITWISE_NOT = 1

Returns the result of bitwise NOT operation on the integer. Translates to ~a in the Godot Shader Language.

Function FUNC_MAX = 2

Represents the size of the Function enum.

---

## Property Descriptions

Function function = 0 

- void set_function(value: Function)
- Function get_function()

A function to be applied to the scalar.
