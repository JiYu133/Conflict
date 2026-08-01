# VisualShaderNodeCompare

Inherits: VisualShaderNode < Resource < RefCounted < Object

A comparison function for common types within the visual shader graph.

## Description

Compares a and b of type by function. Returns a boolean scalar. Translates to if instruction in shader code.

## Properties

Condition | condition | 0
Function | function | 0
ComparisonType | type | 0

---

## Enumerations

enum ComparisonType
ComparisonType CTYPE_SCALAR = 0

A floating-point scalar.

ComparisonType CTYPE_SCALAR_INT = 1

An integer scalar.

ComparisonType CTYPE_SCALAR_UINT = 2

An unsigned integer scalar.

ComparisonType CTYPE_VECTOR_2D = 3

A 2D vector type.

ComparisonType CTYPE_VECTOR_3D = 4

A 3D vector type.

ComparisonType CTYPE_VECTOR_4D = 5

A 4D vector type.

ComparisonType CTYPE_BOOLEAN = 6

A boolean type.

ComparisonType CTYPE_TRANSFORM = 7

A transform (mat4) type.

ComparisonType CTYPE_MAX = 8

Represents the size of the ComparisonType enum.

---

enum Function
Function FUNC_EQUAL = 0

Comparison for equality (a == b).

Function FUNC_NOT_EQUAL = 1

Comparison for inequality (a != b).

Function FUNC_GREATER_THAN = 2

Comparison for greater than (a > b). Cannot be used if type set to CTYPE_BOOLEAN or CTYPE_TRANSFORM.

Function FUNC_GREATER_THAN_EQUAL = 3

Comparison for greater than or equal (a >= b). Cannot be used if type set to CTYPE_BOOLEAN or CTYPE_TRANSFORM.

Function FUNC_LESS_THAN = 4

Comparison for less than (a < b). Cannot be used if type set to CTYPE_BOOLEAN or CTYPE_TRANSFORM.

Function FUNC_LESS_THAN_EQUAL = 5

Comparison for less than or equal (a <= b). Cannot be used if type set to CTYPE_BOOLEAN or CTYPE_TRANSFORM.

Function FUNC_MAX = 6

Represents the size of the Function enum.

---

enum Condition
Condition COND_ALL = 0

The result will be true if all components in the vector satisfy the comparison condition.

Condition COND_ANY = 1

The result will be true if any component in the vector satisfies the comparison condition.

Condition COND_MAX = 2

Represents the size of the Condition enum.

---

## Property Descriptions

Condition condition = 0 

- void set_condition(value: Condition)
- Condition get_condition()

Extra condition which is applied if type is set to CTYPE_VECTOR_3D.

---

Function function = 0 

- void set_function(value: Function)
- Function get_function()

A comparison function.

---

ComparisonType type = 0 

- void set_comparison_type(value: ComparisonType)
- ComparisonType get_comparison_type()

The type to be used in the comparison.
