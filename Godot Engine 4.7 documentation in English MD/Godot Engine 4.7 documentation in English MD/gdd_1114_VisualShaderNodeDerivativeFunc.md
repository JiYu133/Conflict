# VisualShaderNodeDerivativeFunc

Inherits: VisualShaderNode < Resource < RefCounted < Object

Calculates a derivative within the visual shader graph.

## Description

This node is only available in Fragment and Light visual shaders.

## Properties

Function | function | 0
OpType | op_type | 0
Precision | precision | 0

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

enum Function
Function FUNC_SUM = 0

Sum of absolute derivative in x and y.

Function FUNC_X = 1

Derivative in x using local differencing.

Function FUNC_Y = 2

Derivative in y using local differencing.

Function FUNC_MAX = 3

Represents the size of the Function enum.

---

enum Precision
Precision PRECISION_NONE = 0

No precision is specified, the GPU driver is allowed to use whatever level of precision it chooses. This is the default option and is equivalent to using dFdx() or dFdy() in text shaders.

Precision PRECISION_COARSE = 1

The derivative will be calculated using the current fragment's neighbors (which may not include the current fragment). This tends to be faster than using PRECISION_FINE, but may not be suitable when more precision is needed. This is equivalent to using dFdxCoarse() or dFdyCoarse() in text shaders.

Precision PRECISION_FINE = 2

The derivative will be calculated using the current fragment and its immediate neighbors. This tends to be slower than using PRECISION_COARSE, but may be necessary when more precision is needed. This is equivalent to using dFdxFine() or dFdyFine() in text shaders.

Precision PRECISION_MAX = 3

Represents the size of the Precision enum.

---

## Property Descriptions

Function function = 0 

- void set_function(value: Function)
- Function get_function()

A derivative function type.

---

OpType op_type = 0 

- void set_op_type(value: OpType)
- OpType get_op_type()

A type of operands and returned value.

---

Precision precision = 0 

- void set_precision(value: Precision)
- Precision get_precision()

Sets the level of precision to use for the derivative function. When using the Compatibility renderer, this setting has no effect.
