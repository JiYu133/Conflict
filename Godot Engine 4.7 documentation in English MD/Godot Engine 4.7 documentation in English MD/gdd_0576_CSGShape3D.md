# CSGShape3D

Inherits: GeometryInstance3D < VisualInstance3D < Node3D < Node < Object

Inherited By: CSGCombiner3D, CSGPrimitive3D

The CSG base class.

## Description

This is the CSG base class that provides CSG operation support to the various CSG nodes in Godot.

Performance: CSG nodes are only intended for prototyping as they have a significant CPU performance cost. Consider baking final CSG operation results into static geometry that replaces the CSG nodes.

Individual CSG root node results can be baked to nodes with static resources with the editor menu that appears when a CSG root node is selected.

Individual CSG root nodes can also be baked to static resources with scripts by calling bake_static_mesh() for the visual mesh or bake_collision_shape() for the physics collision.

Entire scenes of CSG nodes can be baked to static geometry and exported with the editor glTF scene exporter: Scene > Export As... > glTF 2.0 Scene...

## Tutorials

- Prototyping levels with CSG

## Properties

bool | autosmooth | false
bool | calculate_tangents | true
int | collision_layer | 1
int | collision_mask | 1
float | collision_priority | 1.0
Operation | operation | 0
float | smoothing_angle | 50.0
float | snap |
bool | use_collision | false

## Methods

ConcavePolygonShape3D | bake_collision_shape()
ArrayMesh | bake_static_mesh()
bool | get_collision_layer_value(layer_number: int) const
bool | get_collision_mask_value(layer_number: int) const
Array | get_meshes() const
bool | is_root_shape() const
void | set_collision_layer_value(layer_number: int, value: bool)
void | set_collision_mask_value(layer_number: int, value: bool)

---

## Enumerations

enum Operation
Operation OPERATION_UNION = 0

Geometry of both primitives is merged, intersecting geometry is removed.

Operation OPERATION_INTERSECTION = 1

Only intersecting geometry remains, the rest is removed.

Operation OPERATION_SUBTRACTION = 2

The second shape is subtracted from the first, leaving a dent with its shape.

---

## Property Descriptions

bool autosmooth = false 

- void set_autosmooth(value: bool)
- bool is_autosmooth()

Enables automatic smoothing. This overrides any smoothing on the CSG node and instead uses smoothing_angle to calculate normals based on the angle between faces.

Children of a CSGCombiner3D node will be treated as a single mesh.

---

bool calculate_tangents = true 

- void set_calculate_tangents(value: bool)
- bool is_calculating_tangents()

Calculate tangents for the CSG shape which allows the use of normal and height maps. This is only applied on the root shape, this setting is ignored on any child. Setting this to false can speed up shape generation slightly.

---

int collision_layer = 1 

- void set_collision_layer(value: int)
- int get_collision_layer()

The physics layers this area is in.

Collidable objects can exist in any of 32 different layers. These layers work like a tagging system, and are not visual. A collidable can use these layers to select with which objects it can collide, using the collision_mask property.

A contact is detected if object A is in any of the layers that object B scans, or object B is in any layer scanned by object A. See Collision layers and masks in the documentation for more information.

---

int collision_mask = 1 

- void set_collision_mask(value: int)
- int get_collision_mask()

The physics layers this CSG shape scans for collisions. Only effective if use_collision is true. See Collision layers and masks in the documentation for more information.

---

float collision_priority = 1.0 

- void set_collision_priority(value: float)
- float get_collision_priority()

The priority used to solve colliding when occurring penetration. Only effective if use_collision is true. The higher the priority is, the lower the penetration into the object will be. This can for example be used to prevent the player from breaking through the boundaries of a level.

---

Operation operation = 0 

- void set_operation(value: Operation)
- Operation get_operation()

The operation that is performed on this shape. This is ignored for the first CSG child node as the operation is between this node and the previous child of this nodes parent.

---

float smoothing_angle = 50.0 

- void set_smoothing_angle(value: float)
- float get_smoothing_angle()

When autosmooth is enabled, faces with an angle between them greater than this will be smoothed, while faces with a smaller angle will remain sharp.

Note: An angle lower than 0.1 will cause all smoothing to be disabled, this can be used to increase performance.

---

float snap 

- void set_snap(value: float)
- float get_snap()

Deprecated: The CSG library no longer uses snapping.

This property does nothing.

---

bool use_collision = false 

- void set_use_collision(value: bool)
- bool is_using_collision()

Adds a collision shape to the physics engine for our CSG shape. This will always act like a static body. Note that the collision shape is still active even if the CSG shape itself is hidden. See also collision_mask and collision_priority.

---

## Method Descriptions

ConcavePolygonShape3D bake_collision_shape() 

Returns a baked physics ConcavePolygonShape3D of this node's CSG operation result. Returns an empty shape if the node is not a CSG root node or has no valid geometry.

Performance: If the CSG operation results in a very detailed geometry with many faces physics performance will be very slow. Concave shapes should in general only be used for static level geometry and not with dynamic objects that are moving.

Note: CSG mesh data updates are deferred, which means they are updated with a delay of one rendered frame. To avoid getting an empty shape or outdated mesh data, make sure to call await get_tree().process_frame before using bake_collision_shape() in Node._ready() or after changing properties on the CSGShape3D.

---

ArrayMesh bake_static_mesh() 

Returns a baked static ArrayMesh of this node's CSG operation result. Materials from involved CSG nodes are added as extra mesh surfaces. Returns an empty mesh if the node is not a CSG root node or has no valid geometry.

Note: CSG mesh data updates are deferred, which means they are updated with a delay of one rendered frame. To avoid getting an empty mesh or outdated mesh data, make sure to call await get_tree().process_frame before using bake_static_mesh() in Node._ready() or after changing properties on the CSGShape3D.

---

bool get_collision_layer_value(layer_number: int) const 

Returns whether or not the specified layer of the collision_layer is enabled, given a layer_number between 1 and 32.

---

bool get_collision_mask_value(layer_number: int) const 

Returns whether or not the specified layer of the collision_mask is enabled, given a layer_number between 1 and 32.

---

Array get_meshes() const 

Returns an Array with two elements, the first is the Transform3D of this node and the second is the root Mesh of this node. Only works when this node is the root shape.

Note: CSG mesh data updates are deferred, which means they are updated with a delay of one rendered frame. To avoid getting an empty shape or outdated mesh data, make sure to call await get_tree().process_frame before using get_meshes() in Node._ready() or after changing properties on the CSGShape3D.

---

bool is_root_shape() const 

Returns true if this is a root shape and is thus the object that is rendered.

---

void set_collision_layer_value(layer_number: int, value: bool) 

Based on value, enables or disables the specified layer in the collision_layer, given a layer_number between 1 and 32.

---

void set_collision_mask_value(layer_number: int, value: bool) 

Based on value, enables or disables the specified layer in the collision_mask, given a layer_number between 1 and 32.
