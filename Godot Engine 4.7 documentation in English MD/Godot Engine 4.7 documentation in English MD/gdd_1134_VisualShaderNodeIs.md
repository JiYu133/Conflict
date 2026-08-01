# VisualShaderNodeIs

Inherits: VisualShaderNode < Resource < RefCounted < Object

A boolean comparison operator to be used within the visual shader graph.

## Description

Returns the boolean result of the comparison between INF or NaN and a scalar parameter.

## Properties

Function | function | 0

---

## Enumerations

enum Function
Function FUNC_IS_INF = 0

Comparison with INF (Infinity).

Function FUNC_IS_NAN = 1

Comparison with NaN (Not a Number; indicates invalid numeric results, such as division by zero).

Function FUNC_MAX = 2

Represents the size of the Function enum.

---

## Property Descriptions

Function function = 0 

- void set_function(value: Function)
- Function get_function()

The comparison function.
