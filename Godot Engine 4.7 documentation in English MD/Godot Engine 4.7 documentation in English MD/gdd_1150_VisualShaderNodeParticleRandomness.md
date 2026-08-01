# VisualShaderNodeParticleRandomness

Inherits: VisualShaderNode < Resource < RefCounted < Object

Visual shader node for randomizing particle values.

## Description

Randomness node will output pseudo-random values of the given type based on the specified minimum and maximum values.

## Properties

OpType | op_type | 0

---

## Enumerations

enum OpType
OpType OP_TYPE_SCALAR = 0

A floating-point scalar.

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
