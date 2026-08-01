# PhysicsBody3D

Inherits: CollisionObject3D < Node3D < Node < Object

Inherited By: CharacterBody3D, PhysicalBone3D, RigidBody3D, StaticBody3D

Abstract base class for 3D game objects affected by physics.

## Description

PhysicsBody3D is an abstract base class for 3D game objects affected by physics. All 3D physics bodies inherit from it.

Warning: With a non-uniform scale, this node will likely not behave as expected. It is advised to keep its scale the same on all axes and adjust its collision shape(s) instead.

## Tutorials

- Physics introduction
- Troubleshooting physics issues

## Properties

bool | axis_lock_angular_x | false
bool | axis_lock_angular_y | false
bool | axis_lock_angular_z | false
bool | axis_lock_linear_x | false
bool | axis_lock_linear_y | false
bool | axis_lock_linear_z | false

## Methods

void | add_collision_exception_with(body: Node)
bool | get_axis_lock(axis: BodyAxis) const
Array[PhysicsBody3D] | get_collision_exceptions()
Vector3 | get_gravity() const
KinematicCollision3D | move_and_collide(motion: Vector3, test_only: bool = false, safe_margin: float = 0.001, recovery_as_collision: bool = false, max_collisions: int = 1)
void | remove_collision_exception_with(body: Node)
void | set_axis_lock(axis: BodyAxis, lock: bool)
bool | test_move(from: Transform3D, motion: Vector3, collision: KinematicCollision3D = null, safe_margin: float = 0.001, recovery_as_collision: bool = false, max_collisions: int = 1)

---

## Property Descriptions

bool axis_lock_angular_x = false 

- void set_axis_lock(axis: BodyAxis, lock: bool)
- bool get_axis_lock(axis: BodyAxis) const

Lock the body's rotation in the X axis.

---

bool axis_lock_angular_y = false 

- void set_axis_lock(axis: BodyAxis, lock: bool)
- bool get_axis_lock(axis: BodyAxis) const

Lock the body's rotation in the Y axis.

---

bool axis_lock_angular_z = false 

- void set_axis_lock(axis: BodyAxis, lock: bool)
- bool get_axis_lock(axis: BodyAxis) const

Lock the body's rotation in the Z axis.

---

bool axis_lock_linear_x = false 

- void set_axis_lock(axis: BodyAxis, lock: bool)
- bool get_axis_lock(axis: BodyAxis) const

Lock the body's linear movement in the X axis.

---

bool axis_lock_linear_y = false 

- void set_axis_lock(axis: BodyAxis, lock: bool)
- bool get_axis_lock(axis: BodyAxis) const

Lock the body's linear movement in the Y axis.

---

bool axis_lock_linear_z = false 

- void set_axis_lock(axis: BodyAxis, lock: bool)
- bool get_axis_lock(axis: BodyAxis) const

Lock the body's linear movement in the Z axis.

---

## Method Descriptions

void add_collision_exception_with(body: Node) 

Adds a body to the list of bodies that this body can't collide with.

---

bool get_axis_lock(axis: BodyAxis) const 

Returns true if the specified linear or rotational axis is locked.

---

Array[PhysicsBody3D] get_collision_exceptions() 

Returns an array of nodes that were added as collision exceptions for this body.

---

Vector3 get_gravity() const 

Returns the gravity vector computed from all sources that can affect the body, including all gravity overrides from Area3D nodes and the global world gravity.

---

KinematicCollision3D move_and_collide(motion: Vector3, test_only: bool = false, safe_margin: float = 0.001, recovery_as_collision: bool = false, max_collisions: int = 1) 

Moves the body along the vector motion. In order to be frame rate independent in Node._physics_process() or Node._process(), motion should be computed using delta.

The body will stop if it collides. Returns a KinematicCollision3D, which contains information about the collision when stopped, or when touching another body along the motion.

If test_only is true, the body does not move but the would-be collision information is given.

safe_margin is the extra margin used for collision recovery (see CharacterBody3D.safe_margin for more details).

If recovery_as_collision is true, any depenetration from the recovery phase is also reported as a collision; this is used e.g. by CharacterBody3D for improving floor detection during floor snapping.

max_collisions allows to retrieve more than one collision result.

---

void remove_collision_exception_with(body: Node) 

Removes a body from the list of bodies that this body can't collide with.

---

void set_axis_lock(axis: BodyAxis, lock: bool) 

Locks or unlocks the specified linear or rotational axis depending on the value of lock.

---

bool test_move(from: Transform3D, motion: Vector3, collision: KinematicCollision3D = null, safe_margin: float = 0.001, recovery_as_collision: bool = false, max_collisions: int = 1) 

Checks for collisions without moving the body. In order to be frame rate independent in Node._physics_process() or Node._process(), motion should be computed using delta.

Virtually sets the node's position, scale and rotation to that of the given Transform3D, then tries to move the body along the vector motion. Returns true if a collision would stop the body from moving along the whole path.

collision is an optional object of type KinematicCollision3D, which contains additional information about the collision when stopped, or when touching another body along the motion.

safe_margin is the extra margin used for collision recovery (see CharacterBody3D.safe_margin for more details).

If recovery_as_collision is true, any depenetration from the recovery phase is also reported as a collision; this is useful for checking whether the body would touch any other bodies.

max_collisions allows to retrieve more than one collision result.
