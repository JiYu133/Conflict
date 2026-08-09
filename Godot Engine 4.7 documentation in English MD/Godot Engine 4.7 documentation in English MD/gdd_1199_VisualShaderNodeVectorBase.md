# VisualShaderNodeVectorBase

Inherits: VisualShaderNode < Resource < RefCounted < Object

Inherited By: VisualShaderNodeFaceForward, VisualShaderNodeVectorCompose, VisualShaderNodeVectorDecompose, VisualShaderNodeVectorDistance, VisualShaderNodeVectorFunc, VisualShaderNodeVectorLen, VisualShaderNodeVectorOp, VisualShaderNodeVectorRefract

A base type for the nodes that perform vector operations within the visual shader graph.

## Description

This is an abstract class. See the derived types for descriptions of the possible operations.

## Properties

OpType | op_type | 1

---

## Enumerations

enum OpType
OpType OP_TYPE_VECTOR_2D = 0

A 2D vector type.

OpType OP_TYPE_VECTOR_3D = 1

A 3D vector type.

OpType OP_TYPE_VECTOR_4D = 2

A 4D vector type.

OpType OP_TYPE_MAX = 3

Represents the size of the OpType enum.

---

## Property Descriptions

OpType op_type = 1 

- void set_op_type(value: OpType)
- OpType get_op_type()

A vector type that this operation is performed on.
