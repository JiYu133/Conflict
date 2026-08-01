# VisualShaderNodeMix

Inherits: VisualShaderNode < Resource < RefCounted < Object

Linearly interpolates between two values within the visual shader graph.

## Description

Translates to mix(a, b, weight) in the shader language.

## Properties

OpType | op_type | 0

---

## Enumerations

enum OpType
OpType OP_TYPE_SCALAR = 0

A floating-point scalar.

OpType OP_TYPE_VECTOR_2D = 1

A 2D vector type.

OpType OP_TYPE_VECTOR_2D_SCALAR = 2

The a and b ports use a 2D vector type. The weight port uses a scalar type.

OpType OP_TYPE_VECTOR_3D = 3

A 3D vector type.

OpType OP_TYPE_VECTOR_3D_SCALAR = 4

The a and b ports use a 3D vector type. The weight port uses a scalar type.

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
