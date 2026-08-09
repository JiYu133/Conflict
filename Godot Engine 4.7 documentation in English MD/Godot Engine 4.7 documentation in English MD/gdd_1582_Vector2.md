# Vector2

A 2D vector using floating-point coordinates.

## Description

A 2-element structure that can be used to represent 2D coordinates or any other pair of numeric values.

It uses floating-point coordinates. By default, these floating-point values use 32-bit precision, unlike float which is always 64-bit. If double precision is needed, compile the engine with the option precision=double.

See Vector2i for its integer counterpart.

Note: In a boolean context, a Vector2 will evaluate to false if it's equal to Vector2(0, 0). Otherwise, a Vector2 will always evaluate to true.

## Tutorials

- Math documentation index
- Vector math
- Advanced vector math
- 3Blue1Brown Essence of Linear Algebra [https://www.youtube.com/playlist?list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab]
- Matrix Transform Demo [https://godotengine.org/asset-library/asset/2787]
- All 2D Demos [https://github.com/godotengine/godot-demo-projects/tree/master/2d]

## Properties

float | x | 0.0
float | y | 0.0

## Constructors

Vector2 | Vector2()
Vector2 | Vector2(from: Vector2)
Vector2 | Vector2(from: Vector2i)
Vector2 | Vector2(x: float, y: float)

## Methods

Vector2 | abs() const
float | angle() const
float | angle_to(to: Vector2) const
float | angle_to_point(to: Vector2) const
float | aspect() const
Vector2 | bezier_derivative(control_1: Vector2, control_2: Vector2, end: Vector2, t: float) const
Vector2 | bezier_interpolate(control_1: Vector2, control_2: Vector2, end: Vector2, t: float) const
Vector2 | bounce(n: Vector2) const
Vector2 | ceil() const
Vector2 | clamp(min: Vector2, max: Vector2) const
Vector2 | clampf(min: float, max: float) const
float | cross(with: Vector2) const
Vector2 | cubic_interpolate(b: Vector2, pre_a: Vector2, post_b: Vector2, weight: float) const
Vector2 | cubic_interpolate_in_time(b: Vector2, pre_a: Vector2, post_b: Vector2, weight: float, b_t: float, pre_a_t: float, post_b_t: float) const
Vector2 | direction_to(to: Vector2) const
float | distance_squared_to(to: Vector2) const
float | distance_to(to: Vector2) const
float | dot(with: Vector2) const
Vector2 | floor() const
Vector2 | from_angle(angle: float) static
bool | is_equal_approx(to: Vector2) const
bool | is_finite() const
bool | is_normalized() const
bool | is_zero_approx() const
float | length() const
float | length_squared() const
Vector2 | lerp(to: Vector2, weight: float) const
Vector2 | limit_length(length: float = 1.0) const
Vector2 | max(with: Vector2) const
int | max_axis_index() const
Vector2 | maxf(with: float) const
Vector2 | min(with: Vector2) const
int | min_axis_index() const
Vector2 | minf(with: float) const
Vector2 | move_toward(to: Vector2, delta: float) const
Vector2 | normalized() const
Vector2 | orthogonal() const
Vector2 | posmod(mod: float) const
Vector2 | posmodv(modv: Vector2) const
Vector2 | project(b: Vector2) const
Vector2 | reflect(line: Vector2) const
Vector2 | rotated(angle: float) const
Vector2 | round() const
Vector2 | sign() const
Vector2 | slerp(to: Vector2, weight: float) const
Vector2 | slide(n: Vector2) const
Vector2 | snapped(step: Vector2) const
Vector2 | snappedf(step: float) const

## Operators

bool | operator !=(right: Vector2)
Vector2 | operator *(right: Transform2D)
Vector2 | operator *(right: Vector2)
Vector2 | operator *(right: float)
Vector2 | operator *(right: int)
Vector2 | operator +(right: Vector2)
Vector2 | operator -(right: Vector2)
Vector2 | operator /(right: Vector2)
Vector2 | operator /(right: float)
Vector2 | operator /(right: int)
bool | operator <(right: Vector2)
bool | operator <=(right: Vector2)
bool | operator ==(right: Vector2)
bool | operator >(right: Vector2)
bool | operator >=(right: Vector2)
float | operator [](index: int)
Vector2 | operator unary+()
Vector2 | operator unary-()

---

## Enumerations

enum Axis
Axis AXIS_X = 0

Enumerated value for the X axis. Returned by max_axis_index() and min_axis_index().

Axis AXIS_Y = 1

Enumerated value for the Y axis. Returned by max_axis_index() and min_axis_index().

---

## Constants

ZERO = Vector2(0, 0) 

Zero vector, a vector with all components set to 0.

ONE = Vector2(1, 1) 

One vector, a vector with all components set to 1.

INF = Vector2(inf, inf) 

Infinity vector, a vector with all components set to @GDScript.INF.

LEFT = Vector2(-1, 0) 

Left unit vector. Represents the direction of left.

RIGHT = Vector2(1, 0) 

Right unit vector. Represents the direction of right.

UP = Vector2(0, -1) 

Up unit vector. Y is down in 2D, so this vector points -Y.

DOWN = Vector2(0, 1) 

Down unit vector. Y is down in 2D, so this vector points +Y.

---

## Property Descriptions

float x = 0.0 

The vector's X component. Also accessible by using the index position [0].

---

float y = 0.0 

The vector's Y component. Also accessible by using the index position [1].

---

## Constructor Descriptions

Vector2 Vector2() 

Constructs a default-initialized Vector2 with all components set to 0.

---

Vector2 Vector2(from: Vector2)

Constructs a Vector2 as a copy of the given Vector2.

---

Vector2 Vector2(from: Vector2i)

Constructs a new Vector2 from Vector2i.

---

Vector2 Vector2(x: float, y: float)

Constructs a new Vector2 from the given x and y.

---

## Method Descriptions

Vector2 abs() const 

Returns a new vector with all components in absolute values (i.e. positive).

---

float angle() const 

Returns this vector's angle with respect to the positive X axis, or (1, 0) vector, in radians.

For example, Vector2.RIGHT.angle() will return zero, Vector2.DOWN.angle() will return PI / 2 (a quarter turn, or 90 degrees), and Vector2(1, -1).angle() will return -PI / 4 (a negative eighth turn, or -45 degrees).

This is equivalent to calling @GlobalScope.atan2() with y and x.

Illustration of the returned angle. [https://raw.githubusercontent.com/godotengine/godot-docs/master/img/vector2_angle.png]

---

float angle_to(to: Vector2) const 

Returns the signed angle to the given vector, in radians. The result ranges from -PI to PI (inclusive).

Illustration of the returned angle. [https://raw.githubusercontent.com/godotengine/godot-docs/master/img/vector2_angle_to.png]

---

float angle_to_point(to: Vector2) const 

Returns the signed angle between the X axis and the line from this vector to point to, in radians. The result ranges from -PI to PI (inclusive).

a.angle_to_point(b) is equivalent to (b - a).angle(). See also angle().

Illustration of the returned angle. [https://raw.githubusercontent.com/godotengine/godot-docs/master/img/vector2_angle_to_point.png]

---

float aspect() const 

Returns this vector's aspect ratio, which is x divided by y.

---

Vector2 bezier_derivative(control_1: Vector2, control_2: Vector2, end: Vector2, t: float) const 

Returns the derivative at the given t on the Bézier curve [https://en.wikipedia.org/wiki/B%C3%A9zier_curve] defined by this vector and the given control_1, control_2, and end points.

---

Vector2 bezier_interpolate(control_1: Vector2, control_2: Vector2, end: Vector2, t: float) const 

Returns the point at the given t on the Bézier curve [https://en.wikipedia.org/wiki/B%C3%A9zier_curve] defined by this vector and the given control_1, control_2, and end points.

---

Vector2 bounce(n: Vector2) const 

Returns the vector "bounced off" from a line defined by the given normal n perpendicular to the line.

Note: bounce() performs the operation that most engines and frameworks call reflect().

---

Vector2 ceil() const 

Returns a new vector with all components rounded up (towards positive infinity).

---

Vector2 clamp(min: Vector2, max: Vector2) const 

Returns a new vector with all components clamped between the components of min and max, by running @GlobalScope.clamp() on each component.

---

Vector2 clampf(min: float, max: float) const 

Returns a new vector with all components clamped between min and max, by running @GlobalScope.clamp() on each component.

---

float cross(with: Vector2) const 

Returns the 2D analog of the cross product for this vector and with.

This is the signed area of the parallelogram formed by the two vectors. If the second vector is clockwise from the first vector, then the cross product is the positive area. If counter-clockwise, the cross product is the negative area. If the two vectors are parallel this returns zero, making it useful for testing if two vectors are parallel.

Note: Cross product is not defined in 2D mathematically. This method embeds the 2D vectors in the XY plane of 3D space and uses their cross product's Z component as the analog.

---

Vector2 cubic_interpolate(b: Vector2, pre_a: Vector2, post_b: Vector2, weight: float) const 

Performs a cubic interpolation between this vector and b using pre_a and post_b as handles, and returns the result at position weight. weight is on the range of 0.0 to 1.0, representing the amount of interpolation.

---

Vector2 cubic_interpolate_in_time(b: Vector2, pre_a: Vector2, post_b: Vector2, weight: float, b_t: float, pre_a_t: float, post_b_t: float) const 

Performs a cubic interpolation between this vector and b using pre_a and post_b as handles, and returns the result at position weight. weight is on the range of 0.0 to 1.0, representing the amount of interpolation.

It can perform smoother interpolation than cubic_interpolate() by the time values.

---

Vector2 direction_to(to: Vector2) const 

Returns the normalized vector pointing from this vector to to.

a.direction_to(b) is equivalent to (b - a).normalized(). See also normalized().

---

float distance_squared_to(to: Vector2) const 

Returns the squared Euclidean distance [https://en.wikipedia.org/wiki/Euclidean_distance] between this vector and to.

This method runs faster than distance_to(), so prefer it if you need to compare vectors or need the squared distance for some formula.

---

float distance_to(to: Vector2) const 

Returns the Euclidean distance [https://en.wikipedia.org/wiki/Euclidean_distance] between this vector and to.

---

float dot(with: Vector2) const 

Returns the dot product of this vector and with. This can be used to compare the angle between two vectors. For example, this can be used to determine whether an enemy is facing the player.

The dot product will be 0 for a right angle (90 degrees), greater than 0 for angles narrower than 90 degrees and lower than 0 for angles wider than 90 degrees.

When using unit (normalized) vectors, the result will always be between -1.0 (180 degree angle) when the vectors are facing opposite directions, and 1.0 (0 degree angle) when the vectors are aligned.

Note: a.dot(b) is equivalent to b.dot(a).

---

Vector2 floor() const 

Returns a new vector with all components rounded down (towards negative infinity).

---

Vector2 from_angle(angle: float) static 

Creates a Vector2 rotated to the given angle in radians. This is equivalent to doing Vector2(cos(angle), sin(angle)) or Vector2.RIGHT.rotated(angle).

```gdscript
print(Vector2.from_angle(0)) # Prints (1.0, 0.0)
print(Vector2(1, 0).angle()) # Prints 0.0, which is the angle used above.
print(Vector2.from_angle(PI / 2)) # Prints (0.0, 1.0)
```

Note: The length of the returned Vector2 is approximately 1.0, but is is not guaranteed to be exactly 1.0 due to floating-point precision issues. Call normalized() on the returned Vector2 if you require a unit vector.

---

bool is_equal_approx(to: Vector2) const 

Returns true if this vector and to are approximately equal, by running @GlobalScope.is_equal_approx() on each component.

---

bool is_finite() const 

Returns true if this vector is finite, by calling @GlobalScope.is_finite() on each component.

---

bool is_normalized() const 

Returns true if the vector is normalized, i.e. its length is approximately equal to 1.

---

bool is_zero_approx() const 

Returns true if this vector's values are approximately zero, by running @GlobalScope.is_zero_approx() on each component.

This method is faster than using is_equal_approx() with one value as a zero vector.

---

float length() const 

Returns the length (magnitude) of this vector.

---

float length_squared() const 

Returns the squared length (squared magnitude) of this vector.

This method runs faster than length(), so prefer it if you need to compare vectors or need the squared distance for some formula.

---

Vector2 lerp(to: Vector2, weight: float) const 

Returns the result of the linear interpolation between this vector and to by amount weight. weight is on the range of 0.0 to 1.0, representing the amount of interpolation.

---

Vector2 limit_length(length: float = 1.0) const 

Returns the vector with a maximum length by limiting its length to length. If the vector is non-finite, the result is undefined.

---

Vector2 max(with: Vector2) const 

Returns the component-wise maximum of this and with, equivalent to Vector2(maxf(x, with.x), maxf(y, with.y)).

---

int max_axis_index() const 

Returns the axis of the vector's highest value. See AXIS_* constants. If all components are equal, this method returns AXIS_X.

---

Vector2 maxf(with: float) const 

Returns the component-wise maximum of this and with, equivalent to Vector2(maxf(x, with), maxf(y, with)).

---

Vector2 min(with: Vector2) const 

Returns the component-wise minimum of this and with, equivalent to Vector2(minf(x, with.x), minf(y, with.y)).

---

int min_axis_index() const 

Returns the axis of the vector's lowest value. See AXIS_* constants. If all components are equal, this method returns AXIS_Y.

---

Vector2 minf(with: float) const 

Returns the component-wise minimum of this and with, equivalent to Vector2(minf(x, with), minf(y, with)).

---

Vector2 move_toward(to: Vector2, delta: float) const 

Returns a new vector moved toward to by the fixed delta amount. Will not go past the final value.

---

Vector2 normalized() const 

Returns the result of scaling the vector to unit length. Equivalent to v / v.length(). Returns (0, 0) if v.length() == 0. See also is_normalized().

Note: This function may return incorrect values if the input vector length is near zero.

---

Vector2 orthogonal() const 

Returns a perpendicular vector rotated 90 degrees counter-clockwise compared to the original, with the same length.

---

Vector2 posmod(mod: float) const 

Returns a vector composed of the @GlobalScope.fposmod() of this vector's components and mod.

---

Vector2 posmodv(modv: Vector2) const 

Returns a vector composed of the @GlobalScope.fposmod() of this vector's components and modv's components.

---

Vector2 project(b: Vector2) const 

Returns a new vector resulting from projecting this vector onto the given vector b. The resulting new vector is parallel to b. See also slide().

Note: If the vector b is a zero vector, the components of the resulting new vector will be @GDScript.NAN.

---

Vector2 reflect(line: Vector2) const 

Returns the result of reflecting the vector from a line defined by the given direction vector line.

Note: reflect() differs from what other engines and frameworks call reflect(). In other engines, reflect() takes a normal direction which is a direction perpendicular to the line. In Godot, you specify the direction of the line directly. See also bounce() which does what most engines call reflect().

---

Vector2 rotated(angle: float) const 

Returns the result of rotating this vector by angle (in radians). See also @GlobalScope.deg_to_rad().

---

Vector2 round() const 

Returns a new vector with all components rounded to the nearest integer, with halfway cases rounded away from zero.

---

Vector2 sign() const 

Returns a new vector with each component set to 1.0 if it's positive, -1.0 if it's negative, and 0.0 if it's zero. The result is identical to calling @GlobalScope.sign() on each component.

---

Vector2 slerp(to: Vector2, weight: float) const 

Returns the result of spherical linear interpolation between this vector and to, by amount weight. weight is on the range of 0.0 to 1.0, representing the amount of interpolation.

This method also handles interpolating the lengths if the input vectors have different lengths. For the special case of one or both input vectors having zero length, this method behaves like lerp().

---

Vector2 slide(n: Vector2) const 

Returns a new vector resulting from sliding this vector along a line with normal n. The resulting new vector is perpendicular to n, and is equivalent to this vector minus its projection on n. See also project().

Note: The vector n must be normalized. See also normalized().

---

Vector2 snapped(step: Vector2) const 

Returns a new vector with each component snapped to the nearest multiple of the corresponding component in step. This can also be used to round the components to an arbitrary number of decimals.

---

Vector2 snappedf(step: float) const 

Returns a new vector with each component snapped to the nearest multiple of step. This can also be used to round the components to an arbitrary number of decimals.

---

## Operator Descriptions

bool operator !=(right: Vector2) 

Returns true if the vectors are not equal.

Note: Due to floating-point precision errors, consider using is_equal_approx() instead, which is more reliable.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

---

Vector2 operator *(right: Transform2D) 

Inversely transforms (multiplies) the Vector2 by the given Transform2D transformation matrix, under the assumption that the transformation basis is orthonormal (i.e. rotation/reflection is fine, scaling/skew is not).

vector * transform is equivalent to transform.inverse() * vector. See Transform2D.inverse().

For transforming by inverse of an affine transformation (e.g. with scaling) transform.affine_inverse() * vector can be used instead. See Transform2D.affine_inverse().

---

Vector2 operator *(right: Vector2) 

Multiplies each component of the Vector2 by the components of the given Vector2.

```gdscript
print(Vector2(10, 20) * Vector2(3, 4)) # Prints (30.0, 80.0)
```

---

Vector2 operator *(right: float) 

Multiplies each component of the Vector2 by the given float.

---

Vector2 operator *(right: int) 

Multiplies each component of the Vector2 by the given int.

---

Vector2 operator +(right: Vector2) 

Adds each component of the Vector2 by the components of the given Vector2.

```gdscript
print(Vector2(10, 20) + Vector2(3, 4)) # Prints (13.0, 24.0)
```

---

Vector2 operator -(right: Vector2) 

Subtracts each component of the Vector2 by the components of the given Vector2.

```gdscript
print(Vector2(10, 20) - Vector2(3, 4)) # Prints (7.0, 16.0)
```

---

Vector2 operator /(right: Vector2) 

Divides each component of the Vector2 by the components of the given Vector2.

```gdscript
print(Vector2(10, 20) / Vector2(2, 5)) # Prints (5.0, 4.0)
```

---

Vector2 operator /(right: float) 

Divides each component of the Vector2 by the given float.

---

Vector2 operator /(right: int) 

Divides each component of the Vector2 by the given int.

---

bool operator <(right: Vector2) 

Compares two Vector2 vectors by first checking if the X value of the left vector is less than the X value of the right vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors. This operator is useful for sorting vectors.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

---

bool operator <=(right: Vector2) 

Compares two Vector2 vectors by first checking if the X value of the left vector is less than or equal to the X value of the right vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors. This operator is useful for sorting vectors.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

---

bool operator ==(right: Vector2) 

Returns true if the vectors are exactly equal.

Note: Due to floating-point precision errors, consider using is_equal_approx() instead, which is more reliable.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

---

bool operator >(right: Vector2) 

Compares two Vector2 vectors by first checking if the X value of the left vector is greater than the X value of the right vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors. This operator is useful for sorting vectors.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

---

bool operator >=(right: Vector2) 

Compares two Vector2 vectors by first checking if the X value of the left vector is greater than or equal to the X value of the right vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors. This operator is useful for sorting vectors.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

---

float operator [](index: int) 

Access vector components using their index. v[0] is equivalent to v.x, and v[1] is equivalent to v.y.

---

Vector2 operator unary+() 

Returns the same value as if the + was not there. Unary + does nothing, but sometimes it can make your code more readable.

---

Vector2 operator unary-() 

Returns the negative value of the Vector2. This is the same as writing Vector2(-v.x, -v.y). This operation flips the direction of the vector while keeping the same magnitude. With floats, the number zero can be either positive or negative.
