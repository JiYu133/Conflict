# Quaternion

A unit quaternion used for representing 3D rotations.

## Description

The Quaternion built-in Variant type is a 4D data structure that represents rotation in the form of a Hamilton convention quaternion [https://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation]. Compared to the Basis type which can store both rotation and scale, quaternions can only store rotation.

A Quaternion is composed by 4 floating-point components: w, x, y, and z. These components are very compact in memory, and because of this some operations are more efficient and less likely to cause floating-point errors. Methods such as get_angle(), get_axis(), and slerp() are faster than their Basis counterparts.

For a great introduction to quaternions, see this video by 3Blue1Brown [https://www.youtube.com/watch?v=d4EgbgTm0Bg]. You do not need to know the math behind quaternions, as Godot provides several helper methods that handle it for you. These include slerp() and spherical_cubic_interpolate(), as well as the * operator.

Note: Quaternions must be normalized before being used for rotation (see normalized()).

Note: Similarly to Vector2 and Vector3, the components of a quaternion use 32-bit precision by default, unlike float which is always 64-bit. If double precision is needed, compile the engine with the option precision=double.

Note: In a boolean context, a quaternion will evaluate to false if it's equal to IDENTITY. Otherwise, a quaternion will always evaluate to true.

Note

There are notable differences when using this API with C#. See C# API differences to GDScript for more information.

## Tutorials

- 3Blue1Brown's video on Quaternions [https://www.youtube.com/watch?v=d4EgbgTm0Bg]
- Online Quaternion Visualization [https://quaternions.online/]
- Using 3D transforms
- Third Person Shooter (TPS) Demo [https://godotengine.org/asset-library/asset/2710]
- Advanced Quaternion Visualization [https://iwatake2222.github.io/rotation_master/rotation_master.html]

## Properties

float | w | 1.0
float | x | 0.0
float | y | 0.0
float | z | 0.0

## Constructors

Quaternion | Quaternion()
Quaternion | Quaternion(from: Quaternion)
Quaternion | Quaternion(arc_from: Vector3, arc_to: Vector3)
Quaternion | Quaternion(axis: Vector3, angle: float)
Quaternion | Quaternion(from: Basis)
Quaternion | Quaternion(x: float, y: float, z: float, w: float)

## Methods

float | angle_to(to: Quaternion) const
float | dot(with: Quaternion) const
Quaternion | exp() const
Quaternion | from_euler(euler: Vector3) static
float | get_angle() const
Vector3 | get_axis() const
Vector3 | get_euler(order: int = 2) const
Quaternion | inverse() const
bool | is_equal_approx(to: Quaternion) const
bool | is_finite() const
bool | is_normalized() const
float | length() const
float | length_squared() const
Quaternion | log() const
Quaternion | normalized() const
Quaternion | slerp(to: Quaternion, weight: float) const
Quaternion | slerpni(to: Quaternion, weight: float) const
Quaternion | spherical_cubic_interpolate(b: Quaternion, pre_a: Quaternion, post_b: Quaternion, weight: float) const
Quaternion | spherical_cubic_interpolate_in_time(b: Quaternion, pre_a: Quaternion, post_b: Quaternion, weight: float, b_t: float, pre_a_t: float, post_b_t: float) const

## Operators

bool | operator !=(right: Quaternion)
Quaternion | operator *(right: Quaternion)
Vector3 | operator *(right: Vector3)
Quaternion | operator *(right: float)
Quaternion | operator *(right: int)
Quaternion | operator +(right: Quaternion)
Quaternion | operator -(right: Quaternion)
Quaternion | operator /(right: float)
Quaternion | operator /(right: int)
bool | operator ==(right: Quaternion)
float | operator [](index: int)
Quaternion | operator unary+()
Quaternion | operator unary-()

---

## Constants

IDENTITY = Quaternion(0, 0, 0, 1) 

The identity quaternion, representing no rotation. This has the same rotation as Basis.IDENTITY.

If a Vector3 is rotated (multiplied) by this quaternion, it does not change.

Note: In GDScript, this constant is equivalent to creating a Quaternion without any arguments. It can be used to make your code clearer, and for consistency with C#.

---

## Property Descriptions

float w = 1.0 

W component of the quaternion. This is the "real" part.

Note: Quaternion components should usually not be manipulated directly.

---

float x = 0.0 

X component of the quaternion. This is the value along the "imaginary" i axis.

Note: Quaternion components should usually not be manipulated directly.

---

float y = 0.0 

Y component of the quaternion. This is the value along the "imaginary" j axis.

Note: Quaternion components should usually not be manipulated directly.

---

float z = 0.0 

Z component of the quaternion. This is the value along the "imaginary" k axis.

Note: Quaternion components should usually not be manipulated directly.

---

## Constructor Descriptions

Quaternion Quaternion() 

Constructs a Quaternion identical to IDENTITY.

Note: In C#, this constructs a Quaternion with all of its components set to 0.0.

---

Quaternion Quaternion(from: Quaternion)

Constructs a Quaternion as a copy of the given Quaternion.

---

Quaternion Quaternion(arc_from: Vector3, arc_to: Vector3)

Constructs a Quaternion representing the shortest arc between arc_from and arc_to. These can be imagined as two points intersecting a sphere's surface, with a radius of 1.0.

---

Quaternion Quaternion(axis: Vector3, angle: float)

Constructs a Quaternion representing rotation around the axis by the given angle, in radians. The axis must be a normalized vector.

---

Quaternion Quaternion(from: Basis)

Constructs a Quaternion from the given rotation Basis.

This constructor is faster than Basis.get_rotation_quaternion(), but the given basis must be orthonormalized (see Basis.orthonormalized()). Otherwise, the constructor fails and returns IDENTITY.

---

Quaternion Quaternion(x: float, y: float, z: float, w: float)

Constructs a Quaternion defined by the given values.

Note: Only normalized quaternions represent rotation; if these values are not normalized, the new Quaternion will not be a valid rotation.

---

## Method Descriptions

float angle_to(to: Quaternion) const 

Returns the angle between this quaternion and to. This is the magnitude of the angle you would need to rotate by to get from one to the other.

Note: The magnitude of the floating-point error for this method is abnormally high, so methods such as is_zero_approx will not work reliably.

---

float dot(with: Quaternion) const 

Returns the dot product between this quaternion and with.

This is equivalent to (quat.x * with.x) + (quat.y * with.y) + (quat.z * with.z) + (quat.w * with.w).

---

Quaternion exp() const 

Returns the exponential of this quaternion. The rotation axis of the result is the normalized rotation axis of this quaternion, the angle of the result is the length of the vector part of this quaternion.

---

Quaternion from_euler(euler: Vector3) static 

Constructs a new Quaternion from the given Vector3 of Euler angles [https://en.wikipedia.org/wiki/Euler_angles], in radians. In Godot, Euler angles always use intrinsic order. This method always uses the intrinsic YXZ convention (@GlobalScope.EULER_ORDER_YXZ).

---

float get_angle() const 

Returns the angle of the rotation represented by this quaternion.

Note: The quaternion must be normalized.

---

Vector3 get_axis() const 

Returns the rotation axis of the rotation represented by this quaternion.

---

Vector3 get_euler(order: int = 2) const 

Returns this quaternion's rotation as a Vector3 of Euler angles [https://en.wikipedia.org/wiki/Euler_angles], in radians.

The order of each consecutive rotation can be changed with order (see EulerOrder constants). In Godot, Euler angles always use intrinsic order. By default, the intrinsic YXZ convention is used (@GlobalScope.EULER_ORDER_YXZ): since we are decomposing, local Z (roll) is calculated first, then local X (pitch), and lastly local Y (yaw). When using the opposite method from_euler() to compose a rotation, this order is reversed.

---

Quaternion inverse() const 

Returns the inverse version of this quaternion, inverting the sign of every component except w.

---

bool is_equal_approx(to: Quaternion) const 

Returns true if this quaternion and to are approximately equal, by calling @GlobalScope.is_equal_approx() on each component.

---

bool is_finite() const 

Returns true if this quaternion is finite, by calling @GlobalScope.is_finite() on each component.

---

bool is_normalized() const 

Returns true if this quaternion is normalized. See also normalized().

---

float length() const 

Returns this quaternion's length, also called magnitude.

---

float length_squared() const 

Returns this quaternion's length, squared.

Note: This method is faster than length(), so prefer it if you only need to compare quaternion lengths.

---

Quaternion log() const 

Returns the logarithm of this quaternion. Multiplies this quaternion's rotation axis by its rotation angle, and stores the result in the returned quaternion's vector part (x, y, and z). The returned quaternion's real part (w) is always 0.0.

---

Quaternion normalized() const 

Returns a copy of this quaternion, normalized so that its length is 1.0. See also is_normalized().

---

Quaternion slerp(to: Quaternion, weight: float) const 

Performs a spherical-linear interpolation with the to quaternion, given a weight and returns the result. Both this quaternion and to must be normalized.

---

Quaternion slerpni(to: Quaternion, weight: float) const 

Performs a spherical-linear interpolation with the to quaternion, given a weight and returns the result. Unlike slerp(), this method does not check if the rotation path is smaller than 90 degrees. Both this quaternion and to must be normalized.

---

Quaternion spherical_cubic_interpolate(b: Quaternion, pre_a: Quaternion, post_b: Quaternion, weight: float) const 

Performs a spherical cubic interpolation between quaternions pre_a, this vector, b, and post_b, by the given amount weight.

---

Quaternion spherical_cubic_interpolate_in_time(b: Quaternion, pre_a: Quaternion, post_b: Quaternion, weight: float, b_t: float, pre_a_t: float, post_b_t: float) const 

Performs a spherical cubic interpolation between quaternions pre_a, this vector, b, and post_b, by the given amount weight.

It can perform smoother interpolation than spherical_cubic_interpolate() by the time values.

---

## Operator Descriptions

bool operator !=(right: Quaternion) 

Returns true if the components of both quaternions are not exactly equal.

Note: Due to floating-point precision errors, consider using is_equal_approx() instead, which is more reliable.

---

Quaternion operator *(right: Quaternion) 

Composes (multiplies) two quaternions. This rotates the right quaternion (the child) by this quaternion (the parent).

---

Vector3 operator *(right: Vector3) 

Rotates (multiplies) the right vector by this quaternion, returning a Vector3.

---

Quaternion operator *(right: float) 

Multiplies each component of the Quaternion by the right float value.

This operation is not meaningful on its own, but it can be used as a part of a larger expression.

---

Quaternion operator *(right: int) 

Multiplies each component of the Quaternion by the right int value.

This operation is not meaningful on its own, but it can be used as a part of a larger expression.

---

Quaternion operator +(right: Quaternion) 

Adds each component of the left Quaternion to the right Quaternion.

This operation is not meaningful on its own, but it can be used as a part of a larger expression, such as approximating an intermediate rotation between two nearby rotations.

---

Quaternion operator -(right: Quaternion) 

Subtracts each component of the left Quaternion by the right Quaternion.

This operation is not meaningful on its own, but it can be used as a part of a larger expression.

---

Quaternion operator /(right: float) 

Divides each component of the Quaternion by the right float value.

This operation is not meaningful on its own, but it can be used as a part of a larger expression.

---

Quaternion operator /(right: int) 

Divides each component of the Quaternion by the right int value.

This operation is not meaningful on its own, but it can be used as a part of a larger expression.

---

bool operator ==(right: Quaternion) 

Returns true if the components of both quaternions are exactly equal.

Note: Due to floating-point precision errors, consider using is_equal_approx() instead, which is more reliable.

---

float operator [](index: int) 

Accesses each component of this quaternion by their index.

Index 0 is the same as x, index 1 is the same as y, index 2 is the same as z, and index 3 is the same as w.

---

Quaternion operator unary+() 

Returns the same value as if the + was not there. Unary + does nothing, but sometimes it can make your code more readable.

---

Quaternion operator unary-() 

Returns the negative value of the Quaternion. This is the same as multiplying all components by -1. This operation results in a quaternion that represents the same rotation.
