# CollisionObject2D

Inherits: Node2D < CanvasItem < Node < Object

Inherited By: Area2D, PhysicsBody2D

Abstract base class for 2D physics objects.

## Description

Abstract base class for 2D physics objects. CollisionObject2D can hold any number of Shape2Ds for collision. Each shape must be assigned to a shape owner. Shape owners are not nodes and do not appear in the editor, but are accessible through code using the shape_owner_* methods.

Note: Only collisions between objects within the same canvas (Viewport canvas or CanvasLayer) are supported. The behavior of collisions between objects in different canvases is undefined.

## Properties

int | collision_layer | 1
int | collision_mask | 1
float | collision_priority | 1.0
DisableMode | disable_mode | 0
bool | input_pickable | true

## Methods

void | _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) virtual
void | _mouse_enter() virtual
void | _mouse_exit() virtual
void | _mouse_shape_enter(shape_idx: int) virtual
void | _mouse_shape_exit(shape_idx: int) virtual
int | create_shape_owner(owner: Object)
bool | get_collision_layer_value(layer_number: int) const
bool | get_collision_mask_value(layer_number: int) const
RID | get_rid() const
Vector2 | get_shape_owner_one_way_collision_direction(owner_id: int) const
float | get_shape_owner_one_way_collision_margin(owner_id: int) const
PackedInt32Array | get_shape_owners()
bool | is_shape_owner_disabled(owner_id: int) const
bool | is_shape_owner_one_way_collision_enabled(owner_id: int) const
void | remove_shape_owner(owner_id: int)
void | set_collision_layer_value(layer_number: int, value: bool)
void | set_collision_mask_value(layer_number: int, value: bool)
int | shape_find_owner(shape_index: int) const
void | shape_owner_add_shape(owner_id: int, shape: Shape2D)
void | shape_owner_clear_shapes(owner_id: int)
Object | shape_owner_get_owner(owner_id: int) const
Shape2D | shape_owner_get_shape(owner_id: int, shape_id: int) const
int | shape_owner_get_shape_count(owner_id: int) const
int | shape_owner_get_shape_index(owner_id: int, shape_id: int) const
Transform2D | shape_owner_get_transform(owner_id: int) const
void | shape_owner_remove_shape(owner_id: int, shape_id: int)
void | shape_owner_set_disabled(owner_id: int, disabled: bool)
void | shape_owner_set_one_way_collision(owner_id: int, enable: bool)
void | shape_owner_set_one_way_collision_direction(owner_id: int, direction: Vector2)
void | shape_owner_set_one_way_collision_margin(owner_id: int, margin: float)
void | shape_owner_set_transform(owner_id: int, transform: Transform2D)

---

## Signals

input_event(viewport: Node, event: InputEvent, shape_idx: int) 

Emitted when an input event occurs. Requires input_pickable to be true and at least one collision_layer bit to be set. See _input_event() for details.

---

mouse_entered() 

Emitted when the mouse pointer enters any of this object's shapes. Requires input_pickable to be true and at least one collision_layer bit to be set. Note that moving between different shapes within a single CollisionObject2D won't cause this signal to be emitted.

Note: Due to the lack of continuous collision detection, this signal may not be emitted in the expected order if the mouse moves fast enough and the CollisionObject2D's area is small. This signal may also not be emitted if another CollisionObject2D is overlapping the CollisionObject2D in question.

---

mouse_exited() 

Emitted when the mouse pointer exits all this object's shapes. Requires input_pickable to be true and at least one collision_layer bit to be set. Note that moving between different shapes within a single CollisionObject2D won't cause this signal to be emitted.

Note: Due to the lack of continuous collision detection, this signal may not be emitted in the expected order if the mouse moves fast enough and the CollisionObject2D's area is small. This signal may also not be emitted if another CollisionObject2D is overlapping the CollisionObject2D in question.

---

mouse_shape_entered(shape_idx: int) 

Emitted when the mouse pointer enters any of this object's shapes or moves from one shape to another. shape_idx is the child index of the newly entered Shape2D. Requires input_pickable to be true and at least one collision_layer bit to be set.

---

mouse_shape_exited(shape_idx: int) 

Emitted when the mouse pointer exits any of this object's shapes. shape_idx is the child index of the exited Shape2D. Requires input_pickable to be true and at least one collision_layer bit to be set.

---

## Enumerations

enum DisableMode
DisableMode DISABLE_MODE_REMOVE = 0

When Node.process_mode is set to Node.PROCESS_MODE_DISABLED, remove from the physics simulation to stop all physics interactions with this CollisionObject2D.

Automatically re-added to the physics simulation when the Node is processed again.

DisableMode DISABLE_MODE_MAKE_STATIC = 1

When Node.process_mode is set to Node.PROCESS_MODE_DISABLED, make the body static. Doesn't affect Area2D. PhysicsBody2D can't be affected by forces or other bodies while static.

Automatically set PhysicsBody2D back to its original mode when the Node is processed again.

DisableMode DISABLE_MODE_KEEP_ACTIVE = 2

When Node.process_mode is set to Node.PROCESS_MODE_DISABLED, do not affect the physics simulation.

---

## Property Descriptions

int collision_layer = 1 

- void set_collision_layer(value: int)
- int get_collision_layer()

The physics layers this CollisionObject2D is in. Collision objects can exist in one or more of 32 different layers. See also collision_mask.

Note: Object A can detect a contact with object B only if object B is in any of the layers that object A scans. See Collision layers and masks in the documentation for more information.

---

int collision_mask = 1 

- void set_collision_mask(value: int)
- int get_collision_mask()

The physics layers this CollisionObject2D scans. Collision objects can scan one or more of 32 different layers. See also collision_layer.

Note: Object A can detect a contact with object B only if object B is in any of the layers that object A scans. See Collision layers and masks in the documentation for more information.

---

float collision_priority = 1.0 

- void set_collision_priority(value: float)
- float get_collision_priority()

The priority used to solve colliding when occurring penetration. The higher the priority is, the lower the penetration into the object will be. This can for example be used to prevent the player from breaking through the boundaries of a level.

---

DisableMode disable_mode = 0 

- void set_disable_mode(value: DisableMode)
- DisableMode get_disable_mode()

Defines the behavior in physics when Node.process_mode is set to Node.PROCESS_MODE_DISABLED.

---

bool input_pickable = true 

- void set_pickable(value: bool)
- bool is_pickable()

If true, this object is pickable. A pickable object can detect the mouse pointer entering/leaving, and if the mouse is inside it, report input events. Requires at least one collision_layer bit to be set.

---

## Method Descriptions

void _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) virtual 

Accepts unhandled InputEvents. shape_idx is the child index of the clicked Shape2D. Connect to input_event to easily pick up these events.

Note: _input_event() requires input_pickable to be true and at least one collision_layer bit to be set.

---

void _mouse_enter() virtual 

Called when the mouse pointer enters any of this object's shapes. Requires input_pickable to be true and at least one collision_layer bit to be set. Note that moving between different shapes within a single CollisionObject2D won't cause this function to be called.

---

void _mouse_exit() virtual 

Called when the mouse pointer exits all this object's shapes. Requires input_pickable to be true and at least one collision_layer bit to be set. Note that moving between different shapes within a single CollisionObject2D won't cause this function to be called.

---

void _mouse_shape_enter(shape_idx: int) virtual 

Called when the mouse pointer enters any of this object's shapes or moves from one shape to another. shape_idx is the child index of the newly entered Shape2D. Requires input_pickable to be true and at least one collision_layer bit to be called.

---

void _mouse_shape_exit(shape_idx: int) virtual 

Called when the mouse pointer exits any of this object's shapes. shape_idx is the child index of the exited Shape2D. Requires input_pickable to be true and at least one collision_layer bit to be called.

---

int create_shape_owner(owner: Object) 

Creates a new shape owner for the given object. Returns owner_id of the new owner for future reference.

---

bool get_collision_layer_value(layer_number: int) const 

Returns whether or not the specified layer of the collision_layer is enabled, given a layer_number between 1 and 32.

---

bool get_collision_mask_value(layer_number: int) const 

Returns whether or not the specified layer of the collision_mask is enabled, given a layer_number between 1 and 32.

---

RID get_rid() const 

Returns the object's RID.

---

Vector2 get_shape_owner_one_way_collision_direction(owner_id: int) const 

Returns the one_way_collision_direction of the shape owner identified by the given owner_id.

---

float get_shape_owner_one_way_collision_margin(owner_id: int) const 

Returns the one_way_collision_margin of the shape owner identified by given owner_id.

---

PackedInt32Array get_shape_owners() 

Returns an Array of owner_id identifiers. You can use these ids in other methods that take owner_id as an argument.

---

bool is_shape_owner_disabled(owner_id: int) const 

If true, the shape owner and its shapes are disabled.

---

bool is_shape_owner_one_way_collision_enabled(owner_id: int) const 

Returns true if collisions for the shape owner originating from this CollisionObject2D will not be reported to collided with CollisionObject2Ds.

---

void remove_shape_owner(owner_id: int) 

Removes the given shape owner.

---

void set_collision_layer_value(layer_number: int, value: bool) 

Based on value, enables or disables the specified layer in the collision_layer, given a layer_number between 1 and 32.

---

void set_collision_mask_value(layer_number: int, value: bool) 

Based on value, enables or disables the specified layer in the collision_mask, given a layer_number between 1 and 32.

---

int shape_find_owner(shape_index: int) const 

Returns the owner_id of the given shape.

---

void shape_owner_add_shape(owner_id: int, shape: Shape2D) 

Adds a Shape2D to the shape owner.

---

void shape_owner_clear_shapes(owner_id: int) 

Removes all shapes from the shape owner.

---

Object shape_owner_get_owner(owner_id: int) const 

Returns the parent object of the given shape owner.

---

Shape2D shape_owner_get_shape(owner_id: int, shape_id: int) const 

Returns the Shape2D with the given ID from the given shape owner.

---

int shape_owner_get_shape_count(owner_id: int) const 

Returns the number of shapes the given shape owner contains.

---

int shape_owner_get_shape_index(owner_id: int, shape_id: int) const 

Returns the child index of the Shape2D with the given ID from the given shape owner.

---

Transform2D shape_owner_get_transform(owner_id: int) const 

Returns the shape owner's Transform2D.

---

void shape_owner_remove_shape(owner_id: int, shape_id: int) 

Removes a shape from the given shape owner.

---

void shape_owner_set_disabled(owner_id: int, disabled: bool) 

If true, disables the given shape owner.

---

void shape_owner_set_one_way_collision(owner_id: int, enable: bool) 

If enable is true, collisions for the shape owner originating from this CollisionObject2D will not be reported to collided with CollisionObject2Ds.

---

void shape_owner_set_one_way_collision_direction(owner_id: int, direction: Vector2) 

Sets the one_way_collision_direction of the shape owner identified by the given owner_id to direction.

---

void shape_owner_set_one_way_collision_margin(owner_id: int, margin: float) 

Sets the one_way_collision_margin of the shape owner identified by given owner_id to margin pixels.

---

void shape_owner_set_transform(owner_id: int, transform: Transform2D) 

Sets the Transform2D of the given shape owner.
