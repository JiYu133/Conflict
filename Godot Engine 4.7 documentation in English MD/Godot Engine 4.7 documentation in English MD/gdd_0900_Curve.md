# Curve

Inherits: Resource < RefCounted < Object

A mathematical curve.

## Description

This resource describes a mathematical curve by defining a set of points and tangents at each point. By default, it ranges between 0 and 1 on the X and Y axes, but these ranges can be changed.

Please note that many resources and nodes assume they are given unit curves. A unit curve is a curve whose domain (the X axis) is between 0 and 1. Some examples of unit curve usage are CPUParticles2D.angle_curve and Line2D.width_curve.

## Properties

int | bake_resolution | 100
float | max_domain | 1.0
float | max_value | 1.0
float | min_domain | 0.0
float | min_value | 0.0
int | point_count | 0
int | point_{index}/left_mode | 0
float | point_{index}/left_tangent | 0.0
Vector2 | point_{index}/position | Vector2(0, 0)
int | point_{index}/right_mode | 0
float | point_{index}/right_tangent | 0.0

## Methods

int | add_point(position: Vector2, left_tangent: float = 0, right_tangent: float = 0, left_mode: TangentMode = 0, right_mode: TangentMode = 0)
void | bake()
void | clean_dupes()
void | clear_points()
float | get_domain_range() const
TangentMode | get_point_left_mode(index: int) const
float | get_point_left_tangent(index: int) const
Vector2 | get_point_position(index: int) const
TangentMode | get_point_right_mode(index: int) const
float | get_point_right_tangent(index: int) const
float | get_value_range() const
void | remove_point(index: int)
float | sample(offset: float) const
float | sample_baked(offset: float) const
void | set_point_left_mode(index: int, mode: TangentMode)
void | set_point_left_tangent(index: int, tangent: float)
int | set_point_offset(index: int, offset: float)
void | set_point_right_mode(index: int, mode: TangentMode)
void | set_point_right_tangent(index: int, tangent: float)
void | set_point_value(index: int, y: float)

---

## Signals

domain_changed() 

Emitted when max_domain or min_domain is changed.

---

range_changed() 

Emitted when max_value or min_value is changed.

---

## Enumerations

enum TangentMode
TangentMode TANGENT_FREE = 0

The tangent on this side of the point is user-defined.

TangentMode TANGENT_LINEAR = 1

The curve calculates the tangent on this side of the point as the slope halfway towards the adjacent point.

TangentMode TANGENT_MODE_COUNT = 2

The total number of available tangent modes.

---

## Property Descriptions

int bake_resolution = 100 

- void set_bake_resolution(value: int)
- int get_bake_resolution()

The number of points to include in the baked (i.e. cached) curve data.

---

float max_domain = 1.0 

- void set_max_domain(value: float)
- float get_max_domain()

The maximum domain (x-coordinate) that points can have.

---

float max_value = 1.0 

- void set_max_value(value: float)
- float get_max_value()

The maximum value (y-coordinate) that points can have. Tangents can cause higher values between points.

---

float min_domain = 0.0 

- void set_min_domain(value: float)
- float get_min_domain()

The minimum domain (x-coordinate) that points can have.

---

float min_value = 0.0 

- void set_min_value(value: float)
- float get_min_value()

The minimum value (y-coordinate) that points can have. Tangents can cause lower values between points.

---

int point_count = 0 

- void set_point_count(value: int)
- int get_point_count()

The number of points describing the curve.

---

int point_{index}/left_mode = 0 

The left TangentMode for the point at index.

Note: index is a value in the 0 .. point_count - 1 range.

---

float point_{index}/left_tangent = 0.0 

The left tangent angle (in degrees) for the point at index.

Note: index is a value in the 0 .. point_count - 1 range.

---

Vector2 point_{index}/position = Vector2(0, 0) 

The position of the point at index.

Note: index is a value in the 0 .. point_count - 1 range.

---

int point_{index}/right_mode = 0 

The right TangentMode for the point at index.

Note: index is a value in the 0 .. point_count - 1 range.

---

float point_{index}/right_tangent = 0.0 

The right tangent angle (in degrees) for the point at index.

Note: index is a value in the 0 .. point_count - 1 range.

---

## Method Descriptions

int add_point(position: Vector2, left_tangent: float = 0, right_tangent: float = 0, left_mode: TangentMode = 0, right_mode: TangentMode = 0) 

Adds a point to the curve. For each side, if the *_mode is TANGENT_LINEAR, the *_tangent angle (in degrees) uses the slope of the curve halfway to the adjacent point. Allows custom assignments to the *_tangent angle if *_mode is set to TANGENT_FREE.

---

void bake() 

Recomputes the baked cache of points for the curve.

---

void clean_dupes() 

Removes duplicate points, i.e. points that are less than 0.00001 units (engine epsilon value) away from their neighbor on the curve.

---

void clear_points() 

Removes all points from the curve.

---

float get_domain_range() const 

Returns the difference between min_domain and max_domain.

---

TangentMode get_point_left_mode(index: int) const 

Returns the left TangentMode for the point at index.

---

float get_point_left_tangent(index: int) const 

Returns the left tangent angle (in degrees) for the point at index.

---

Vector2 get_point_position(index: int) const 

Returns the curve coordinates for the point at index.

---

TangentMode get_point_right_mode(index: int) const 

Returns the right TangentMode for the point at index.

---

float get_point_right_tangent(index: int) const 

Returns the right tangent angle (in degrees) for the point at index.

---

float get_value_range() const 

Returns the difference between min_value and max_value.

---

void remove_point(index: int) 

Removes the point at index from the curve.

---

float sample(offset: float) const 

Returns the Y value for the point that would exist at the X position offset along the curve.

---

float sample_baked(offset: float) const 

Returns the Y value for the point that would exist at the X position offset along the curve using the baked cache. Bakes the curve's points if not already baked.

---

void set_point_left_mode(index: int, mode: TangentMode) 

Sets the left TangentMode for the point at index to mode.

---

void set_point_left_tangent(index: int, tangent: float) 

Sets the left tangent angle for the point at index to tangent.

---

int set_point_offset(index: int, offset: float) 

Assigns the horizontal position offset to the point at index.

---

void set_point_right_mode(index: int, mode: TangentMode) 

Sets the right TangentMode for the point at index to mode.

---

void set_point_right_tangent(index: int, tangent: float) 

Sets the right tangent angle for the point at index to tangent.

---

void set_point_value(index: int, y: float) 

Assigns the vertical position y to the point at index.
