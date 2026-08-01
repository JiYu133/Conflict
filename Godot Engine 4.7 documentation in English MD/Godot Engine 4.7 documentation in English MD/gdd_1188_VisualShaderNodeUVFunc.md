# VisualShaderNodeUVFunc

Inherits: VisualShaderNode < Resource < RefCounted < Object

Contains functions to modify texture coordinates (uv) to be used within the visual shader graph.

## Description

UV functions are similar to Vector2 functions, but the input port of this node uses the shader's UV value by default.

## Properties

Function | function | 0

---

## Enumerations

enum Function
Function FUNC_PANNING = 0

Translates uv by using scale and offset values using the following formula: uv = uv + offset * scale. uv port is connected to UV built-in by default.

Function FUNC_SCALING = 1

Scales uv by using scale and pivot values using the following formula: uv = (uv - pivot) * scale + pivot. uv port is connected to UV built-in by default.

Function FUNC_MAX = 2

Represents the size of the Function enum.

---

## Property Descriptions

Function function = 0 

- void set_function(value: Function)
- Function get_function()

A function to be applied to the texture coordinates.
