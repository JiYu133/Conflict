# Area3D

Inherits: CollisionObject3D < Node3D < Node < Object

A region of 3D space that detects other CollisionObject3Ds entering or exiting it.

## Description

Area3D is a region of 3D space defined by one or multiple CollisionShape3D or CollisionPolygon3D child nodes. It detects when other CollisionObject3Ds enter or exit it, and it also keeps track of which collision objects haven't exited it yet (i.e. which one are overlapping it).

This node can also locally alter or override physics parameters (gravity, damping) and route audio to custom audio buses.

Note: Areas and bodies created with PhysicsServer3D might not interact as expected with Area3Ds, and might not emit signals or track objects correctly.

Warning: Using a ConcavePolygonShape3D inside a CollisionShape3D child of this node (created e.g. by using the Create Trimesh Collision Sibling option in the Mesh menu that appears when selecting a MeshInstance3D node) may give unexpected results, since this collision shape is hollow. If this is not desired, it has to be split into multiple ConvexPolygonShape3Ds or primitive shapes like BoxShape3D, or in some cases it may be replaceable by a CollisionPolygon3D.

## Tutorials

- Using Area2D
- 3D Platformer Demo [https://godotengine.org/asset-library/asset/2748]
- GUI in 3D Viewport Demo [https://godotengine.org/asset-library/asset/2807]

## Properties

float | angular_damp | 0.1
SpaceOverride | angular_damp_space_override | 0
StringName | audio_bus_name | &"Master"
bool | audio_bus_override | false
float | gravity | 9.8
Vector3 | gravity_direction | Vector3(0, -1, 0)
bool | gravity_point | false
Vector3 | gravity_point_center | Vector3(0, -1, 0)
float | gravity_point_unit_distance | 0.0
SpaceOverride | gravity_space_override | 0
float | linear_damp | 0.1
SpaceOverride | linear_damp_space_override | 0
bool | monitorable | true
bool | monitoring | true
int | priority | 0
float | reverb_bus_amount | 0.0
bool | reverb_bus_enabled | false
StringName | reverb_bus_name | &"Master"
float | reverb_bus_uniformity | 0.0
float | wind_attenuation_factor | 0.0
float | wind_force_magnitude | 0.0
NodePath | wind_source_path | NodePath("")

## Methods

Array[Area3D] | get_overlapping_areas() const
Array[Node3D] | get_overlapping_bodies() const
bool | has_overlapping_areas() const
bool | has_overlapping_bodies() const
bool | overlaps_area(area: Node) const
bool | overlaps_body(body: Node) const

---

## Signals

area_entered(area: Area3D) 

Emitted when the received area enters this area. Requires monitoring to be set to true.

---

area_exited(area: Area3D) 

Emitted when the received area exits this area. Requires monitoring to be set to true.

---

area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) 

Emitted when a Shape3D of the received area enters a shape of this area. Requires monitoring to be set to true.

local_shape_index and area_shape_index contain indices of the interacting shapes from this area and the other area, respectively. area_rid contains the RID of the other area. These values can be used with the PhysicsServer3D.

Example: Get the CollisionShape3D node from the shape index:

```
var other_shape_owner = area.shape_find_owner(area_shape_index)
var other_shape_node = area.shape_owner_get_owner(other_shape_owner)
var local_shape_owner = shape_find_owner(local_shape_index)
var local_shape_node = shape_owner_get_owner(local_shape_owner)
```

---

area_shape_exited(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) 

Emitted when a Shape3D of the received area exits a shape of this area. Requires monitoring to be set to true.

See also area_shape_entered.

---

body_entered(body: Node3D) 

Emitted when the received body enters this area. body can be a PhysicsBody3D, SoftBody3D or GridMap. GridMaps are detected if their MeshLibrary has collision shapes configured. Requires monitoring to be set to true.

Note: Godot Physics does not support reporting overlaps with SoftBody3D, so will not emit this signal in such cases.

---

body_exited(body: Node3D) 

Emitted when the received body exits this area. body can be a PhysicsBody3D, SoftBody3D or GridMap. GridMaps are detected if their MeshLibrary has collision shapes configured. Requires monitoring to be set to true.

Note: Godot Physics does not support reporting overlaps with SoftBody3D, so will not emit this signal in such cases.

---

body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) 

Emitted when a Shape3D of the received body enters a shape of this area. body can be a PhysicsBody3D, SoftBody3D or GridMap. GridMaps are detected if their MeshLibrary has collision shapes configured. Requires monitoring to be set to true.

local_shape_index and body_shape_index contain indices of the interacting shapes from this area and the interacting body, respectively. body_rid contains the RID of the body. These values can be used with the PhysicsServer3D.

Note: Godot Physics does not support reporting overlaps with SoftBody3D, so will not emit this signal in such cases.

Example: Get the CollisionShape3D node from the shape index:

```
var body_shape_owner = body.shape_find_owner(body_shape_index)
var body_shape_node = body.shape_owner_get_owner(body_shape_owner)
var local_shape_owner = shape_find_owner(local_shape_index)
var local_shape_node = shape_owner_get_owner(local_shape_owner)
```

---

body_shape_exited(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) 

Emitted when a Shape3D of the received body exits a shape of this area. body can be a PhysicsBody3D, SoftBody3D or GridMap. GridMaps are detected if their MeshLibrary has collision shapes configured. Requires monitoring to be set to true.

See also body_shape_entered.

Note: Godot Physics does not support reporting overlaps with SoftBody3D, so will not emit this signal in such cases.

---

## Enumerations

enum SpaceOverride
SpaceOverride SPACE_OVERRIDE_DISABLED = 0

This area does not affect gravity/damping.

SpaceOverride SPACE_OVERRIDE_COMBINE = 1

This area adds its gravity/damping values to whatever has been calculated so far (in priority order).

SpaceOverride SPACE_OVERRIDE_COMBINE_REPLACE = 2

This area adds its gravity/damping values to whatever has been calculated so far (in priority order), ignoring any lower priority areas.

SpaceOverride SPACE_OVERRIDE_REPLACE = 3

This area replaces any gravity/damping, even the defaults, ignoring any lower priority areas.

SpaceOverride SPACE_OVERRIDE_REPLACE_COMBINE = 4

This area replaces any gravity/damping calculated so far (in priority order), but keeps calculating the rest of the areas.

---

## Property Descriptions

float angular_damp = 0.1 

- void set_angular_damp(value: float)
- float get_angular_damp()

The rate at which objects stop spinning in this area. Represents the angular velocity lost per second.

See ProjectSettings.physics/3d/default_angular_damp for more details about damping.

---

SpaceOverride angular_damp_space_override = 0 

- void set_angular_damp_space_override_mode(value: SpaceOverride)
- SpaceOverride get_angular_damp_space_override_mode()

Override mode for angular damping calculations within this area.

---

StringName audio_bus_name = &"Master" 

- void set_audio_bus_name(value: StringName)
- StringName get_audio_bus_name()

The name of the area's audio bus.

---

bool audio_bus_override = false 

- void set_audio_bus_override(value: bool)
- bool is_overriding_audio_bus()

If true, the area's audio bus overrides the default audio bus.

---

float gravity = 9.8 

- void set_gravity(value: float)
- float get_gravity()

The area's gravity intensity (in meters per second squared). This value multiplies the gravity direction. This is useful to alter the force of gravity without altering its direction.

---

Vector3 gravity_direction = Vector3(0, -1, 0) 

- void set_gravity_direction(value: Vector3)
- Vector3 get_gravity_direction()

The area's gravity vector (not normalized).

---

bool gravity_point = false 

- void set_gravity_is_point(value: bool)
- bool is_gravity_a_point()

If true, gravity is calculated from a point (set via gravity_point_center). See also gravity_space_override.

---

Vector3 gravity_point_center = Vector3(0, -1, 0) 

- void set_gravity_point_center(value: Vector3)
- Vector3 get_gravity_point_center()

If gravity is a point (see gravity_point), this will be the point of attraction.

---

float gravity_point_unit_distance = 0.0 

- void set_gravity_point_unit_distance(value: float)
- float get_gravity_point_unit_distance()

The distance at which the gravity strength is equal to gravity. For example, on a planet 100 meters in radius with a surface gravity of 4.0 m/s², set the gravity to 4.0 and the unit distance to 100.0. The gravity will have falloff according to the inverse square law, so in the example, at 200 meters from the center the gravity will be 1.0 m/s² (twice the distance, 1/4th the gravity), at 50 meters it will be 16.0 m/s² (half the distance, 4x the gravity), and so on.

The above is true only when the unit distance is a positive number. When this is set to 0.0, the gravity will be constant regardless of distance.

---

SpaceOverride gravity_space_override = 0 

- void set_gravity_space_override_mode(value: SpaceOverride)
- SpaceOverride get_gravity_space_override_mode()

Override mode for gravity calculations within this area.

---

float linear_damp = 0.1 

- void set_linear_damp(value: float)
- float get_linear_damp()

The rate at which objects stop moving in this area. Represents the linear velocity lost per second.

See ProjectSettings.physics/3d/default_linear_damp for more details about damping.

---

SpaceOverride linear_damp_space_override = 0 

- void set_linear_damp_space_override_mode(value: SpaceOverride)
- SpaceOverride get_linear_damp_space_override_mode()

Override mode for linear damping calculations within this area.

---

bool monitorable = true 

- void set_monitorable(value: bool)
- bool is_monitorable()

If true, other monitoring areas can detect this area.

---

bool monitoring = true 

- void set_monitoring(value: bool)
- bool is_monitoring()

If true, the area detects bodies or areas entering and exiting it.

---

int priority = 0 

- void set_priority(value: int)
- int get_priority()

The area's priority. Higher priority areas are processed first. The World3D's physics is always processed last, after all areas.

---

float reverb_bus_amount = 0.0 

- void set_reverb_amount(value: float)
- float get_reverb_amount()

The degree to which this area applies reverb to its associated audio. Ranges from 0 to 1 with 0.1 precision.

---

bool reverb_bus_enabled = false 

- void set_use_reverb_bus(value: bool)
- bool is_using_reverb_bus()

If true, the area applies reverb to its associated audio.

---

StringName reverb_bus_name = &"Master" 

- void set_reverb_bus_name(value: StringName)
- StringName get_reverb_bus_name()

The name of the reverb bus to use for this area's associated audio.

---

float reverb_bus_uniformity = 0.0 

- void set_reverb_uniformity(value: float)
- float get_reverb_uniformity()

The degree to which this area's reverb is a uniform effect. Ranges from 0 to 1 with 0.1 precision.

---

float wind_attenuation_factor = 0.0 

- void set_wind_attenuation_factor(value: float)
- float get_wind_attenuation_factor()

The exponential rate at which wind force decreases with distance from its origin.

Note: This wind force only applies to SoftBody3D nodes. Other physics bodies are currently not affected by wind.

---

float wind_force_magnitude = 0.0 

- void set_wind_force_magnitude(value: float)
- float get_wind_force_magnitude()

The magnitude of area-specific wind force.

Note: This wind force only applies to SoftBody3D nodes. Other physics bodies are currently not affected by wind.

---

NodePath wind_source_path = NodePath("") 

- void set_wind_source_path(value: NodePath)
- NodePath get_wind_source_path()

The Node3D which is used to specify the direction and origin of an area-specific wind force. The direction is opposite to the z-axis of the Node3D's local transform, and its origin is the origin of the Node3D's local transform.

Note: This wind force only applies to SoftBody3D nodes. Other physics bodies are currently not affected by wind.

---

## Method Descriptions

Array[Area3D] get_overlapping_areas() const 

Returns a list of intersecting Area3Ds. The overlapping area's CollisionObject3D.collision_layer must be part of this area's CollisionObject3D.collision_mask in order to be detected.

For performance reasons (collisions are all processed at the same time) this list is modified once during the physics step, not immediately after objects are moved. Consider using signals instead.

---

Array[Node3D] get_overlapping_bodies() const 

Returns a list of intersecting PhysicsBody3Ds, SoftBody3Ds, and GridMaps. The overlapping body's CollisionObject3D.collision_layer must be part of this area's CollisionObject3D.collision_mask in order to be detected.

For performance reasons (collisions are all processed at the same time) this list is modified once during the physics step, not immediately after objects are moved. Consider using signals instead.

Note: Godot Physics does not support reporting overlaps with SoftBody3D, so will not return any such bodies.

---

bool has_overlapping_areas() const 

Returns true if intersecting any Area3Ds, otherwise returns false. The overlapping area's CollisionObject3D.collision_layer must be part of this area's CollisionObject3D.collision_mask in order to be detected.

For performance reasons (collisions are all processed at the same time) the list of overlapping areas is modified once during the physics step, not immediately after objects are moved. Consider using signals instead.

---

bool has_overlapping_bodies() const 

Returns true if intersecting any PhysicsBody3Ds, SoftBody3Ds, or GridMaps, otherwise returns false. The overlapping body's CollisionObject3D.collision_layer must be part of this area's CollisionObject3D.collision_mask in order to be detected.

For performance reasons (collisions are all processed at the same time) the list of overlapping bodies is modified once during the physics step, not immediately after objects are moved. Consider using signals instead.

Note: Godot Physics does not support reporting overlaps with SoftBody3D, so will not consider such bodies.

---

bool overlaps_area(area: Node) const 

Returns true if the given Area3D intersects or overlaps this Area3D, false otherwise.

Note: The result of this test is not immediate after moving objects. For performance, list of overlaps is updated once per frame and before the physics step. Consider using signals instead.

---

bool overlaps_body(body: Node) const 

Returns true if the given physics body intersects or overlaps this Area3D, false otherwise.

body argument can either be a PhysicsBody3D, SoftBody3D, or a GridMap instance. While GridMaps are not physics body themselves, they register their tiles with collision shapes as a virtual physics body.

Note: The result of this test is not immediate after moving objects. For performance, list of overlaps is updated once per frame and before the physics step. Consider using signals instead.

Note: Godot Physics does not support reporting overlaps with SoftBody3D, so will return false in such cases.
