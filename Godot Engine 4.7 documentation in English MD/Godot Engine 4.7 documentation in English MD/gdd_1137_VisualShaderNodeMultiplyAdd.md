# VisualShaderNodeMultiplyAdd

Inherits: VisualShaderNode < Resource < RefCounted < Object

Performs a fused multiply-add operation within the visual shader graph.

## Description

Uses three operands to compute (a * b + c) expression.

## Properties

OpType | op_type | 0

---

## Enumerations

enum OpType
OpType OP_TYPE_SCALAR = 0

A floating-point scalar type.

OpType OP_TYPE_VECTOR_2D = 1

A 2D vector type.

OpType OP_TYPE_VECTOR_3D = 2

A 3D vector type.

OpType OP_TYPE_VECTOR_4D = 3

A 4D vector type.

OpType OP_TYPE_MAX = 4

Represents the size of the OpType enum.

---

## Property Descriptions

OpType op_type = 0 

- void set_op_type(value: OpType)
- OpType get_op_type()

A type of operands and returned value.
