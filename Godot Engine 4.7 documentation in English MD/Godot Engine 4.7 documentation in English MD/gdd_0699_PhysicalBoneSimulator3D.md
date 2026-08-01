# PhysicalBoneSimulator3D

Inherits: SkeletonModifier3D < Node3D < Node < Object

Node that can be the parent of PhysicalBone3D and can apply the simulation results to Skeleton3D.

## Description

Node that can be the parent of PhysicalBone3D and can apply the simulation results to Skeleton3D.

## Methods

bool | is_simulating_physics() const
void | physical_bones_add_collision_exception(exception: RID)
void | physical_bones_remove_collision_exception(exception: RID)
void | physical_bones_start_simulation(bones: Array[StringName] = [])
void | physical_bones_stop_simulation()

---

## Method Descriptions

bool is_simulating_physics() const 

Returns a boolean that indicates whether the PhysicalBoneSimulator3D is running and simulating.

---

void physical_bones_add_collision_exception(exception: RID) 

Adds a collision exception to the physical bone.

Works just like the RigidBody3D node.

---

void physical_bones_remove_collision_exception(exception: RID) 

Removes a collision exception to the physical bone.

Works just like the RigidBody3D node.

---

void physical_bones_start_simulation(bones: Array[StringName] = []) 

Tells the PhysicalBone3D nodes in the Skeleton to start simulating and reacting to the physics world.

Optionally, a list of bone names can be passed-in, allowing only the passed-in bones to be simulated.

---

void physical_bones_stop_simulation() 

Tells the PhysicalBone3D nodes in the Skeleton to stop simulating.
