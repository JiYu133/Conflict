# VisualShaderNodeRemap

Inherits: VisualShaderNode < Resource < RefCounted < Object

A visual shader node for remap function.

## Description

Remap will transform the input range into output range, e.g. you can change a 0..1 value to -2..2 etc. See @GlobalScope.remap() for more details.

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

The value port uses a 2D vector type, while the input min, input max, output min, and output max ports use a floating-point scalar type.

OpType OP_TYPE_VECTOR_3D = 3

A 3D vector type.

OpType OP_TYPE_VECTOR_3D_SCALAR = 4

The value port uses a 3D vector type, while the input min, input max, output min, and output max ports use a floating-point scalar type.

OpType OP_TYPE_VECTOR_4D = 5

A 4D vector type.

OpType OP_TYPE_VECTOR_4D_SCALAR = 6

The value port uses a 4D vector type, while the input min, input max, output min, and output max ports use a floating-point scalar type.

OpType OP_TYPE_MAX = 7

Represents the size of the OpType enum.

---

## Property Descriptions

OpType op_type = 0 

- void set_op_type(value: OpType)
- OpType get_op_type()

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!
