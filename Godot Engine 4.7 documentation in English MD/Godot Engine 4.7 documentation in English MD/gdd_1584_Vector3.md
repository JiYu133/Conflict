# Vector3

A 3D vector using floating-point coordinates.

## Description

A 3-element structure that can be used to represent 3D coordinates or any other triplet of numeric values.

It uses floating-point coordinates. By default, these floating-point values use 32-bit precision, unlike float which is always 64-bit. If double precision is needed, compile the engine with the option precision=double.

See Vector3i for its integer counterpart.

Note: In a boolean context, a Vector3 will evaluate to false if it's equal to Vector3(0, 0, 0). Otherwise, a Vector3 will always evaluate to true.

## Tutorials

- Math documentation index
- Vector math
- Advanced vector math
- 3Blue1Brown Essence of Linear Algebra [https://www.youtube.com/playlist?list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab]
- Matrix Transform Demo [https://godotengine.org/asset-library/asset/2787]
- All 3D Demos [https://github.com/godotengine/godot-demo-projects/tree/master/3d]

## Properties

float | x | 0.0
float | y | 0.0
float | z | 0.0

## Constructors

Vector3 | Vector3()
Vector3 | Vector3(from: Vector3)
Vector3 | Vector3(from: Vector3i)
Vector3 | Vector3(x: float, y: float, z: float)

## Methods

Vector3 | abs() const
float | angle_to(to: Vector3) const
Vector3 | bezier_derivative(control_1: Vector3, control_2: Vector3, end: Vector3, t: float) const
Vector3 | bezier_interpolate(control_1: Vector3, control_2: Vector3, end: Vector3, t: float) const
Vector3 | bounce(n: Vector3) const
Vector3 | ceil() const
Vector3 | clamp(min: Vector3, max: Vector3) const
Vector3 | clampf(min: float, max: float) const
Vector3 | cross(with: Vector3) const
Vector3 | cubic_interpolate(b: Vector3, pre_a: Vector3, post_b: Vector3, weight: float) const
Vector3 | cubic_interpolate_in_time(b: Vector3, pre_a: Vector3, post_b: Vector3, weight: float, b_t: float, pre_a_t: float, post_b_t: float) const
Vector3 | direction_to(to: Vector3) const
float | distance_squared_to(to: Vector3) const
float | distance_to(to: Vector3) const
float | dot(with: Vector3) const
Vector3 | floor() const
Vector3 | inverse() const
bool | is_equal_approx(to: Vector3) const
bool | is_finite() const
bool | is_normalized() const
bool | is_zero_approx() const
float | length() const
float | length_squared() const
Vector3 | lerp(to: Vector3, weight: float) const
Vector3 | limit_length(length: float = 1.0) const
Vector3 | max(with: Vector3) const
int | max_axis_index() const
Vector3 | maxf(with: float) const
Vector3 | min(with: Vector3) const
int | min_axis_index() const
Vector3 | minf(with: float) const
Vector3 | move_toward(to: Vector3, delta: float) const
Vector3 | normalized() const
Vector3 | octahedron_decode(uv: Vector2) static
Vector2 | octahedron_encode() const
Basis | outer(with: Vector3) const
Vector3 | posmod(mod: float) const
Vector3 | posmodv(modv: Vector3) const
Vector3 | project(b: Vector3) const
Vector3 | reflect(n: Vector3) const
Vector3 | rotated(axis: Vector3, angle: float) const
Vector3 | round() const
Vector3 | sign() const
float | signed_angle_to(to: Vector3, axis: Vector3) const
Vector3 | slerp(to: Vector3, weight: float) const
Vector3 | slide(n: Vector3) const
Vector3 | snapped(step: Vector3) const
Vector3 | snappedf(step: float) const

## Operators

bool | operator !=(right: Vector3)
Vector3 | operator *(right: Basis)
Vector3 | operator *(right: Quaternion)
Vector3 | operator *(right: Transform3D)
Vector3 | operator *(right: Vector3)
Vector3 | operator *(right: float)
Vector3 | operator *(right: int)
Vector3 | operator +(right: Vector3)
Vector3 | operator -(right: Vector3)
Vector3 | operator /(right: Vector3)
Vector3 | operator /(right: float)
Vector3 | operator /(right: int)
bool | operator <(right: Vector3)
bool | operator <=(right: Vector3)
bool | operator ==(right: Vector3)
bool | operator >(right: Vector3)
bool | operator >=(right: Vector3)
float | operator [](index: int)
Vector3 | operator unary+()
Vector3 | operator unary-()

---

## Enumerations

enum Axis
Axis AXIS_X = 0

Enumerated value for the X axis. Returned by max_axis_index() and min_axis_index().

Axis AXIS_Y = 1

Enumerated value for the Y axis. Returned by max_axis_index() and min_axis_index().

Axis AXIS_Z = 2

Enumerated value for the Z axis. Returned by max_axis_index() and min_axis_index().

---

## Constants

ZERO = Vector3(0, 0, 0) 

Zero vector, a vector with all components set to 0.

ONE = Vector3(1, 1, 1) 

One vector, a vector with all components set to 1.

INF = Vector3(inf, inf, inf) 

Infinity vector, a vector with all components set to @GDScript.INF.

LEFT = Vector3(-1, 0, 0) 

Left unit vector. Represents the local direction of left, and the global direction of west.

RIGHT = Vector3(1, 0, 0) 

Right unit vector. Represents the local direction of right, and the global direction of east.

UP = Vector3(0, 1, 0) 

Up unit vector.

DOWN = Vector3(0, -1, 0) 

Down unit vector.

FORWARD = Vector3(0, 0, -1) 

Forward unit vector. Represents the local direction of forward, and the global direction of north. Keep in mind that the forward direction for lights, cameras, etc is different from 3D assets like characters, which face towards the camera by convention. Use MODEL_FRONT and similar constants when working in 3D asset space.

BACK = Vector3(0, 0, 1) 

Back unit vector. Represents the local direction of back, and the global direction of south.

MODEL_LEFT = Vector3(1, 0, 0) 

Unit vector pointing towards the left side of imported 3D assets.

MODEL_RIGHT = Vector3(-1, 0, 0) 

Unit vector pointing towards the right side of imported 3D assets.

MODEL_TOP = Vector3(0, 1, 0) 

Unit vector pointing towards the top side (up) of imported 3D assets.

MODEL_BOTTOM = Vector3(0, -1, 0) 

Unit vector pointing towards the bottom side (down) of imported 3D assets.

MODEL_FRONT = Vector3(0, 0, 1) 

Unit vector pointing towards the front side (facing forward) of imported 3D assets.

MODEL_REAR = Vector3(0, 0, -1) 

Unit vector pointing towards the rear side (back) of imported 3D assets.

---

## Property Descriptions

float x = 0.0 

The vector's X component. Also accessible by using the index position [0].

---

float y = 0.0 

The vector's Y component. Also accessible by using the index position [1].

---

float z = 0.0 

The vector's Z component. Also accessible by using the index position [2].

---

## Constructor Descriptions

Vector3 Vector3() 

Constructs a default-initialized Vector3 with all components set to 0.

---

Vector3 Vector3(from: Vector3)

Constructs a Vector3 as a copy of the given Vector3.

---

Vector3 Vector3(from: Vector3i)

Constructs a new Vector3 from Vector3i.

---

Vector3 Vector3(x: float, y: float, z: float)

Returns a Vector3 with the given components.

---

## Method Descriptions

Vector3 abs() const 

Returns a new vector with all components in absolute values (i.e. positive).

---

float angle_to(to: Vector3) const 

Returns the unsigned minimum angle to the given vector, in radians.

---

Vector3 bezier_derivative(control_1: Vector3, control_2: Vector3, end: Vector3, t: float) const 

Returns the derivative at the given t on the Bézier curve [https://en.wikipedia.org/wiki/B%C3%A9zier_curve] defined by this vector and the given control_1, control_2, and end points.

---

Vector3 bezier_interpolate(control_1: Vector3, control_2: Vector3, end: Vector3, t: float) const 

Returns the point at the given t on the Bézier curve [https://en.wikipedia.org/wiki/B%C3%A9zier_curve] defined by this vector and the given control_1, control_2, and end points.

---

Vector3 bounce(n: Vector3) const 

Returns the vector "bounced off" from a plane defined by the given normal n.

Note: bounce() performs the operation that most engines and frameworks call reflect().

---

Vector3 ceil() const 

Returns a new vector with all components rounded up (towards positive infinity).

---

Vector3 clamp(min: Vector3, max: Vector3) const 

Returns a new vector with all components clamped between the components of min and max, by running @GlobalScope.clamp() on each component.

---

Vector3 clampf(min: float, max: float) const 

Returns a new vector with all components clamped between min and max, by running @GlobalScope.clamp() on each component.

---

Vector3 cross(with: Vector3) const 

Returns the cross product of this vector and with.

This returns a vector perpendicular to both this and with, which would be the normal vector of the plane defined by the two vectors. As there are two such vectors, in opposite directions, this method returns the vector defined by a right-handed coordinate system. If the two vectors are parallel this returns an empty vector, making it useful for testing if two vectors are parallel.

---

Vector3 cubic_interpolate(b: Vector3, pre_a: Vector3, post_b: Vector3, weight: float) const 

Performs a cubic interpolation between this vector and b using pre_a and post_b as handles, and returns the result at position weight. weight is on the range of 0.0 to 1.0, representing the amount of interpolation.

---

Vector3 cubic_interpolate_in_time(b: Vector3, pre_a: Vector3, post_b: Vector3, weight: float, b_t: float, pre_a_t: float, post_b_t: float) const 

Performs a cubic interpolation between this vector and b using pre_a and post_b as handles, and returns the result at position weight. weight is on the range of 0.0 to 1.0, representing the amount of interpolation.

It can perform smoother interpolation than cubic_interpolate() by the time values.

---

Vector3 direction_to(to: Vector3) const 

Returns the normalized vector pointing from this vector to to. This is equivalent to using (b - a).normalized().

---

float distance_squared_to(to: Vector3) const 

Returns the squared Euclidean distance [https://en.wikipedia.org/wiki/Euclidean_distance] between this vector and to.

This method runs faster than distance_to(), so prefer it if you need to compare vectors or need the squared distance for some formula.

---

float distance_to(to: Vector3) const 

Returns the Euclidean distance [https://en.wikipedia.org/wiki/Euclidean_distance] between this vector and to.

---

float dot(with: Vector3) const 

Returns the dot product of this vector and with. This can be used to compare the angle between two vectors. For example, this can be used to determine whether an enemy is facing the player.

The dot product will be 0 for a right angle (90 degrees), greater than 0 for angles narrower than 90 degrees and lower than 0 for angles wider than 90 degrees.

When using unit (normalized) vectors, the result will always be between -1.0 (180 degree angle) when the vectors are facing opposite directions, and 1.0 (0 degree angle) when the vectors are aligned.

Note: a.dot(b) is equivalent to b.dot(a).

---

Vector3 floor() const 

Returns a new vector with all components rounded down (towards negative infinity).

---

Vector3 inverse() const 

Returns the inverse of the vector. This is the same as Vector3(1.0 / v.x, 1.0 / v.y, 1.0 / v.z).

---

bool is_equal_approx(to: Vector3) const 

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

Vector3 lerp(to: Vector3, weight: float) const 

Returns the result of the linear interpolation between this vector and to by amount weight. weight is on the range of 0.0 to 1.0, representing the amount of interpolation.

---

Vector3 limit_length(length: float = 1.0) const 

Returns the vector with a maximum length by limiting its length to length. If the vector is non-finite, the result is undefined.

---

Vector3 max(with: Vector3) const 

Returns the component-wise maximum of this and with, equivalent to Vector3(maxf(x, with.x), maxf(y, with.y), maxf(z, with.z)).

---

int max_axis_index() const 

Returns the axis of the vector's highest value. See AXIS_* constants. If all components are equal, this method returns AXIS_X.

---

Vector3 maxf(with: float) const 

Returns the component-wise maximum of this and with, equivalent to Vector3(maxf(x, with), maxf(y, with), maxf(z, with)).

---

Vector3 min(with: Vector3) const 

Returns the component-wise minimum of this and with, equivalent to Vector3(minf(x, with.x), minf(y, with.y), minf(z, with.z)).

---

int min_axis_index() const 

Returns the axis of the vector's lowest value. See AXIS_* constants. If all components are equal, this method returns AXIS_Z.

---

Vector3 minf(with: float) const 

Returns the component-wise minimum of this and with, equivalent to Vector3(minf(x, with), minf(y, with), minf(z, with)).

---

Vector3 move_toward(to: Vector3, delta: float) const 

Returns a new vector moved toward to by the fixed delta amount. Will not go past the final value.

---

Vector3 normalized() const 

Returns the result of scaling the vector to unit length. Equivalent to v / v.length(). Returns (0, 0, 0) if v.length() == 0. See also is_normalized().

Note: This function may return incorrect values if the input vector length is near zero.

---

Vector3 octahedron_decode(uv: Vector2) static 

Returns the Vector3 from an octahedral-compressed form created using octahedron_encode() (stored as a Vector2).

---

Vector2 octahedron_encode() const 

Returns the octahedral-encoded (oct32) form of this Vector3 as a Vector2. Since a Vector2 occupies 1/3 less memory compared to Vector3, this form of compression can be used to pass greater amounts of normalized() Vector3s without increasing storage or memory requirements. See also octahedron_decode().

Note: octahedron_encode() can only be used for normalized() vectors. octahedron_encode() does not check whether this Vector3 is normalized, and will return a value that does not decompress to the original value if the Vector3 is not normalized.

Note: Octahedral compression is lossy, although visual differences are rarely perceptible in real world scenarios.

---

Basis outer(with: Vector3) const 

Returns the outer product with with.

---

Vector3 posmod(mod: float) const 

Returns a vector composed of the @GlobalScope.fposmod() of this vector's components and mod.

---

Vector3 posmodv(modv: Vector3) const 

Returns a vector composed of the @GlobalScope.fposmod() of this vector's components and modv's components.

---

Vector3 project(b: Vector3) const 

Returns a new vector resulting from projecting this vector onto the given vector b. The resulting new vector is parallel to b. See also slide().

Note: If the vector b is a zero vector, the components of the resulting new vector will be @GDScript.NAN.

---

Vector3 reflect(n: Vector3) const 

Returns the result of reflecting the vector through a plane defined by the given normal vector n.

Note: reflect() differs from what other engines and frameworks call reflect(). In other engines, reflect() returns the result of the vector reflected by the given plane. The reflection thus passes through the given normal. While in Godot the reflection passes through the plane and can be thought of as bouncing off the normal. See also bounce() which does what most engines call reflect().

---

Vector3 rotated(axis: Vector3, angle: float) const 

Returns the result of rotating this vector around a given axis by angle (in radians). The axis must be a normalized vector. See also @GlobalScope.deg_to_rad().

---

Vector3 round() const 

Returns a new vector with all components rounded to the nearest integer, with halfway cases rounded away from zero.

---

Vector3 sign() const 

Returns a new vector with each component set to 1.0 if it's positive, -1.0 if it's negative, and 0.0 if it's zero. The result is identical to calling @GlobalScope.sign() on each component.

---

float signed_angle_to(to: Vector3, axis: Vector3) const 

Returns the signed angle to the given vector, in radians. The sign of the angle is positive in a counter-clockwise direction and negative in a clockwise direction when viewed from the side specified by the axis.

---

Vector3 slerp(to: Vector3, weight: float) const 

Returns the result of spherical linear interpolation between this vector and to, by amount weight. weight is on the range of 0.0 to 1.0, representing the amount of interpolation.

This method also handles interpolating the lengths if the input vectors have different lengths. For the special case of one or both input vectors having zero length, this method behaves like lerp().

---

Vector3 slide(n: Vector3) const 

Returns a new vector resulting from sliding this vector along a plane with normal n. The resulting new vector is perpendicular to n, and is equivalent to this vector minus its projection on n. See also project().

Note: The vector n must be normalized. See also normalized().

---

Vector3 snapped(step: Vector3) const 

Returns a new vector with each component snapped to the nearest multiple of the corresponding component in step. This can also be used to round the components to an arbitrary number of decimals.

---

Vector3 snappedf(step: float) const 

Returns a new vector with each component snapped to the nearest multiple of step. This can also be used to round the components to an arbitrary number of decimals.

---

## Operator Descriptions

bool operator !=(right: Vector3) 

Returns true if the vectors are not equal.

Note: Due to floating-point precision errors, consider using is_equal_approx() instead, which is more reliable.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

---

Vector3 operator *(right: Basis) 

Inversely transforms (multiplies) the Vector3 by the given Basis matrix, under the assumption that the basis is orthonormal (i.e. rotation/reflection is fine, scaling/skew is not).

vector * basis is equivalent to basis.transposed() * vector. See Basis.transposed().

For transforming by inverse of a non-orthonormal basis (e.g. with scaling) basis.inverse() * vector can be used instead. See Basis.inverse().

---

Vector3 operator *(right: Quaternion) 

Inversely transforms (multiplies) the Vector3 by the given Quaternion.

vector * quaternion is equivalent to quaternion.inverse() * vector. See Quaternion.inverse().

---

Vector3 operator *(right: Transform3D) 

Inversely transforms (multiplies) the Vector3 by the given Transform3D transformation matrix, under the assumption that the transformation basis is orthonormal (i.e. rotation/reflection is fine, scaling/skew is not).

vector * transform is equivalent to transform.inverse() * vector. See Transform3D.inverse().

For transforming by inverse of an affine transformation (e.g. with scaling) transform.affine_inverse() * vector can be used instead. See Transform3D.affine_inverse().

---

Vector3 operator *(right: Vector3) 

Multiplies each component of the Vector3 by the components of the given Vector3.

```gdscript
print(Vector3(10, 20, 30) * Vector3(3, 4, 5)) # Prints (30.0, 80.0, 150.0)
```

---

Vector3 operator *(right: float) 

Multiplies each component of the Vector3 by the given float.

---

Vector3 operator *(right: int) 

Multiplies each component of the Vector3 by the given int.

---

Vector3 operator +(right: Vector3) 

Adds each component of the Vector3 by the components of the given Vector3.

```gdscript
print(Vector3(10, 20, 30) + Vector3(3, 4, 5)) # Prints (13.0, 24.0, 35.0)
```

---

Vector3 operator -(right: Vector3) 

Subtracts each component of the Vector3 by the components of the given Vector3.

```gdscript
print(Vector3(10, 20, 30) - Vector3(3, 4, 5)) # Prints (7.0, 16.0, 25.0)
```

---

Vector3 operator /(right: Vector3) 

Divides each component of the Vector3 by the components of the given Vector3.

```gdscript
print(Vector3(10, 20, 30) / Vector3(2, 5, 3)) # Prints (5.0, 4.0, 10.0)
```

---

Vector3 operator /(right: float) 

Divides each component of the Vector3 by the given float.

---

Vector3 operator /(right: int) 

Divides each component of the Vector3 by the given int.

---

bool operator <(right: Vector3) 

Compares two Vector3 vectors by first checking if the X value of the left vector is less than the X value of the right vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, and then with the Z values. This operator is useful for sorting vectors.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

---

bool operator <=(right: Vector3) 

Compares two Vector3 vectors by first checking if the X value of the left vector is less than or equal to the X value of the right vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, and then with the Z values. This operator is useful for sorting vectors.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

---

bool operator ==(right: Vector3) 

Returns true if the vectors are exactly equal.

Note: Due to floating-point precision errors, consider using is_equal_approx() instead, which is more reliable.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

---

bool operator >(right: Vector3) 

Compares two Vector3 vectors by first checking if the X value of the left vector is greater than the X value of the right vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, and then with the Z values. This operator is useful for sorting vectors.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

---

bool operator >=(right: Vector3) 

Compares two Vector3 vectors by first checking if the X value of the left vector is greater than or equal to the X value of the right vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, and then with the Z values. This operator is useful for sorting vectors.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

---

float operator [](index: int) 

Access vector components using their index. v[0] is equivalent to v.x, v[1] is equivalent to v.y, and v[2] is equivalent to v.z.

---

Vector3 operator unary+() 

Returns the same value as if the + was not there. Unary + does nothing, but sometimes it can make your code more readable.

---

Vector3 operator unary-() 

Returns the negative value of the Vector3. This is the same as writing Vector3(-v.x, -v.y, -v.z). This operation flips the direction of the vector while keeping the same magnitude. With floats, the number zero can be either positive or negative.
