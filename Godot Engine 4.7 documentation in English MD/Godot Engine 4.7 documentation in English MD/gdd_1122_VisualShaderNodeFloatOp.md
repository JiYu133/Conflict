# VisualShaderNodeFloatOp

Inherits: VisualShaderNode < Resource < RefCounted < Object

A floating-point scalar operator to be used within the visual shader graph.

## Description

Applies operator to two floating-point inputs: a and b.

## Properties

Operator | operator | 0

---

## Enumerations

enum Operator
Operator OP_ADD = 0

Sums two numbers using a + b.

Operator OP_SUB = 1

Subtracts two numbers using a - b.

Operator OP_MUL = 2

Multiplies two numbers using a * b.

Operator OP_DIV = 3

Divides two numbers using a / b.

Operator OP_MOD = 4

Calculates the remainder of two numbers. Translates to mod(a, b) in the Godot Shader Language.

Operator OP_POW = 5

Raises the a to the power of b. Translates to pow(a, b) in the Godot Shader Language.

Operator OP_MAX = 6

Returns the greater of two numbers. Translates to max(a, b) in the Godot Shader Language.

Operator OP_MIN = 7

Returns the lesser of two numbers. Translates to min(a, b) in the Godot Shader Language.

Operator OP_ATAN2 = 8

Returns the arc-tangent of the parameters. Translates to atan(a, b) in the Godot Shader Language.

Operator OP_STEP = 9

Generates a step function by comparing b(x) to a(edge). Returns 0.0 if x is smaller than edge and otherwise 1.0. Translates to step(a, b) in the Godot Shader Language.

Operator OP_ENUM_SIZE = 10

Represents the size of the Operator enum.

---

## Property Descriptions

Operator operator = 0 

- void set_operator(value: Operator)
- Operator get_operator()

An operator to be applied to the inputs.
