# Vector4i

A 4D vector using integer coordinates.

## Description

A 4-element structure that can be used to represent 4D grid coordinates or any other quadruplet of integers.

It uses integer coordinates and is therefore preferable to Vector4 when exact precision is required. Note that the values are limited to 32 bits, and unlike Vector4 this cannot be configured with an engine build option. Use int or PackedInt64Array if 64-bit values are needed.

Note: In a boolean context, a Vector4i will evaluate to false if it's equal to Vector4i(0, 0, 0, 0). Otherwise, a Vector4i will always evaluate to true.

## Properties

int | w | 0
int | x | 0
int | y | 0
int | z | 0

## Constructors

Vector4i | Vector4i()
Vector4i | Vector4i(from: Vector4i)
Vector4i | Vector4i(from: Vector4)
Vector4i | Vector4i(x: int, y: int, z: int, w: int)

## Methods

Vector4i | abs() const
Vector4i | clamp(min: Vector4i, max: Vector4i) const
Vector4i | clampi(min: int, max: int) const
int | distance_squared_to(to: Vector4i) const
float | distance_to(to: Vector4i) const
float | length() const
int | length_squared() const
Vector4i | max(with: Vector4i) const
int | max_axis_index() const
Vector4i | maxi(with: int) const
Vector4i | min(with: Vector4i) const
int | min_axis_index() const
Vector4i | mini(with: int) const
Vector4i | sign() const
Vector4i | snapped(step: Vector4i) const
Vector4i | snappedi(step: int) const

## Operators

bool | operator !=(right: Vector4i)
Vector4i | operator %(right: Vector4i)
Vector4i | operator %(right: int)
Vector4i | operator *(right: Vector4i)
Vector4 | operator *(right: float)
Vector4i | operator *(right: int)
Vector4i | operator +(right: Vector4i)
Vector4i | operator -(right: Vector4i)
Vector4i | operator /(right: Vector4i)
Vector4 | operator /(right: float)
Vector4i | operator /(right: int)
bool | operator <(right: Vector4i)
bool | operator <=(right: Vector4i)
bool | operator ==(right: Vector4i)
bool | operator >(right: Vector4i)
bool | operator >=(right: Vector4i)
int | operator [](index: int)
Vector4i | operator unary+()
Vector4i | operator unary-()

---

## Enumerations

enum Axis
Axis AXIS_X = 0

Enumerated value for the X axis. Returned by max_axis_index() and min_axis_index().

Axis AXIS_Y = 1

Enumerated value for the Y axis. Returned by max_axis_index() and min_axis_index().

Axis AXIS_Z = 2

Enumerated value for the Z axis. Returned by max_axis_index() and min_axis_index().

Axis AXIS_W = 3

Enumerated value for the W axis. Returned by max_axis_index() and min_axis_index().

---

## Constants

ZERO = Vector4i(0, 0, 0, 0) 

Zero vector, a vector with all components set to 0.

ONE = Vector4i(1, 1, 1, 1) 

One vector, a vector with all components set to 1.

MIN = Vector4i(-2147483648, -2147483648, -2147483648, -2147483648) 

Min vector, a vector with all components equal to INT32_MIN. Can be used as a negative integer equivalent of Vector4.INF.

MAX = Vector4i(2147483647, 2147483647, 2147483647, 2147483647) 

Max vector, a vector with all components equal to INT32_MAX. Can be used as an integer equivalent of Vector4.INF.

---

## Property Descriptions

int w = 0 

The vector's W component. Also accessible by using the index position [3].

---

int x = 0 

The vector's X component. Also accessible by using the index position [0].

---

int y = 0 

The vector's Y component. Also accessible by using the index position [1].

---

int z = 0 

The vector's Z component. Also accessible by using the index position [2].

---

## Constructor Descriptions

Vector4i Vector4i() 

Constructs a default-initialized Vector4i with all components set to 0.

---

Vector4i Vector4i(from: Vector4i)

Constructs a Vector4i as a copy of the given Vector4i.

---

Vector4i Vector4i(from: Vector4)

Constructs a new Vector4i from the given Vector4 by truncating components' fractional parts (rounding towards zero). For a different behavior consider passing the result of Vector4.ceil(), Vector4.floor() or Vector4.round() to this constructor instead.

---

Vector4i Vector4i(x: int, y: int, z: int, w: int)

Returns a Vector4i with the given components.

---

## Method Descriptions

Vector4i abs() const 

Returns a new vector with all components in absolute values (i.e. positive).

---

Vector4i clamp(min: Vector4i, max: Vector4i) const 

Returns a new vector with all components clamped between the components of min and max, by running @GlobalScope.clamp() on each component.

---

Vector4i clampi(min: int, max: int) const 

Returns a new vector with all components clamped between min and max, by running @GlobalScope.clamp() on each component.

---

int distance_squared_to(to: Vector4i) const 

Returns the squared Euclidean distance [https://en.wikipedia.org/wiki/Euclidean_distance] between this vector and to.

This method runs faster than distance_to(), so prefer it if you need to compare vectors or need the squared distance for some formula.

---

float distance_to(to: Vector4i) const 

Returns the Euclidean distance [https://en.wikipedia.org/wiki/Euclidean_distance] between this vector and to.

---

float length() const 

Returns the length (magnitude) of this vector.

---

int length_squared() const 

Returns the squared length (squared magnitude) of this vector.

This method runs faster than length(), so prefer it if you need to compare vectors or need the squared distance for some formula.

---

Vector4i max(with: Vector4i) const 

Returns the component-wise maximum of this and with, equivalent to Vector4i(maxi(x, with.x), maxi(y, with.y), maxi(z, with.z), maxi(w, with.w)).

---

int max_axis_index() const 

Returns the axis of the vector's highest value. See AXIS_* constants. If all components are equal, this method returns AXIS_X.

---

Vector4i maxi(with: int) const 

Returns the component-wise maximum of this and with, equivalent to Vector4i(maxi(x, with), maxi(y, with), maxi(z, with), maxi(w, with)).

---

Vector4i min(with: Vector4i) const 

Returns the component-wise minimum of this and with, equivalent to Vector4i(mini(x, with.x), mini(y, with.y), mini(z, with.z), mini(w, with.w)).

---

int min_axis_index() const 

Returns the axis of the vector's lowest value. See AXIS_* constants. If all components are equal, this method returns AXIS_W.

---

Vector4i mini(with: int) const 

Returns the component-wise minimum of this and with, equivalent to Vector4i(mini(x, with), mini(y, with), mini(z, with), mini(w, with)).

---

Vector4i sign() const 

Returns a new vector with each component set to 1 if it's positive, -1 if it's negative, and 0 if it's zero. The result is identical to calling @GlobalScope.sign() on each component.

---

Vector4i snapped(step: Vector4i) const 

Returns a new vector with each component snapped to the closest multiple of the corresponding component in step.

---

Vector4i snappedi(step: int) const 

Returns a new vector with each component snapped to the closest multiple of step.

---

## Operator Descriptions

bool operator !=(right: Vector4i) 

Returns true if the vectors are not equal.

---

Vector4i operator %(right: Vector4i) 

Gets the remainder of each component of the Vector4i with the components of the given Vector4i. This operation uses truncated division, which is often not desired as it does not work well with negative numbers. Consider using @GlobalScope.posmod() instead if you want to handle negative numbers.

```gdscript
print(Vector4i(10, -20, 30, -40) % Vector4i(7, 8, 9, 10)) # Prints (3, -4, 3, 0)
```

---

Vector4i operator %(right: int) 

Gets the remainder of each component of the Vector4i with the given int. This operation uses truncated division, which is often not desired as it does not work well with negative numbers. Consider using @GlobalScope.posmod() instead if you want to handle negative numbers.

```gdscript
print(Vector4i(10, -20, 30, -40) % 7) # Prints (3, -6, 2, -5)
```

---

Vector4i operator *(right: Vector4i) 

Multiplies each component of the Vector4i by the components of the given Vector4i.

```gdscript
print(Vector4i(10, 20, 30, 40) * Vector4i(3, 4, 5, 6)) # Prints (30, 80, 150, 240)
```

---

Vector4 operator *(right: float) 

Multiplies each component of the Vector4i by the given float.

Returns a Vector4 value due to floating-point operations.

```gdscript
print(Vector4i(10, 20, 30, 40) * 2) # Prints (20.0, 40.0, 60.0, 80.0)
```

---

Vector4i operator *(right: int) 

Multiplies each component of the Vector4i by the given int.

---

Vector4i operator +(right: Vector4i) 

Adds each component of the Vector4i by the components of the given Vector4i.

```gdscript
print(Vector4i(10, 20, 30, 40) + Vector4i(3, 4, 5, 6)) # Prints (13, 24, 35, 46)
```

---

Vector4i operator -(right: Vector4i) 

Subtracts each component of the Vector4i by the components of the given Vector4i.

```gdscript
print(Vector4i(10, 20, 30, 40) - Vector4i(3, 4, 5, 6)) # Prints (7, 16, 25, 34)
```

---

Vector4i operator /(right: Vector4i) 

Divides each component of the Vector4i by the components of the given Vector4i.

```gdscript
print(Vector4i(10, 20, 30, 40) / Vector4i(2, 5, 3, 4)) # Prints (5, 4, 10, 10)
```

---

Vector4 operator /(right: float) 

Divides each component of the Vector4i by the given float.

Returns a Vector4 value due to floating-point operations.

```gdscript
print(Vector4i(1, 2, 3, 4) / 2.5) # Prints (0.4, 0.8, 1.2, 1.6)
```

---

Vector4i operator /(right: int) 

Divides each component of the Vector4i by the given int.

---

bool operator <(right: Vector4i) 

Compares two Vector4i vectors by first checking if the X value of the left vector is less than the X value of the right vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, Z values of the two vectors, and then with the W values. This operator is useful for sorting vectors.

---

bool operator <=(right: Vector4i) 

Compares two Vector4i vectors by first checking if the X value of the left vector is less than or equal to the X value of the right vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, Z values of the two vectors, and then with the W values. This operator is useful for sorting vectors.

---

bool operator ==(right: Vector4i) 

Returns true if the vectors are exactly equal.

---

bool operator >(right: Vector4i) 

Compares two Vector4i vectors by first checking if the X value of the left vector is greater than the X value of the right vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, Z values of the two vectors, and then with the W values. This operator is useful for sorting vectors.

---

bool operator >=(right: Vector4i) 

Compares two Vector4i vectors by first checking if the X value of the left vector is greater than or equal to the X value of the right vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, Z values of the two vectors, and then with the W values. This operator is useful for sorting vectors.

---

int operator [](index: int) 

Access vector components using their index. v[0] is equivalent to v.x, v[1] is equivalent to v.y, v[2] is equivalent to v.z, and v[3] is equivalent to v.w.

---

Vector4i operator unary+() 

Returns the same value as if the + was not there. Unary + does nothing, but sometimes it can make your code more readable.

---

Vector4i operator unary-() 

Returns the negative value of the Vector4i. This is the same as writing Vector4i(-v.x, -v.y, -v.z, -v.w). This operation flips the direction of the vector while keeping the same magnitude.
