# VisualShaderNodeTransformFunc

Inherits: VisualShaderNode < Resource < RefCounted < Object

Computes a Transform3D function within the visual shader graph.

## Description

Computes an inverse or transpose function on the provided Transform3D.

## Properties

Function | function | 0

---

## Enumerations

enum Function
Function FUNC_INVERSE = 0

Perform the inverse operation on the Transform3D matrix.

Function FUNC_TRANSPOSE = 1

Perform the transpose operation on the Transform3D matrix.

Function FUNC_MAX = 2

Represents the size of the Function enum.

---

## Property Descriptions

Function function = 0 

- void set_function(value: Function)
- Function get_function()

The function to be computed.
