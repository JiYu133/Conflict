# VisualShaderNodeStep

Inherits: VisualShaderNode < Resource < RefCounted < Object

Calculates a Step function within the visual shader graph.

## Description

Translates to step(edge, x) in the shader language.

Returns 0.0 if x is smaller than edge and 1.0 otherwise.

## Properties

OpType | op_type | 0

---

## Enumerations

enum OpType
OpType OP_TYPE_SCALAR = 0

A floating-point scalar type.

OpType OP_TYPE_VECTOR_2D = 1

A 2D vector type.

OpType OP_TYPE_VECTOR_2D_SCALAR = 2

The x port uses a 2D vector type, while the edge port uses a floating-point scalar type.

OpType OP_TYPE_VECTOR_3D = 3

A 3D vector type.

OpType OP_TYPE_VECTOR_3D_SCALAR = 4

The x port uses a 3D vector type, while the edge port uses a floating-point scalar type.

OpType OP_TYPE_VECTOR_4D = 5

A 4D vector type.

OpType OP_TYPE_VECTOR_4D_SCALAR = 6

The a and b ports use a 4D vector type. The weight port uses a scalar type.

OpType OP_TYPE_MAX = 7

Represents the size of the OpType enum.

---

## Property Descriptions

OpType op_type = 0 

- void set_op_type(value: OpType)
- OpType get_op_type()

A type of operands and returned value.
