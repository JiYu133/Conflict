# SkeletonModification2DJiggle

Experimental: This class may be changed or removed in future versions.

Inherits: SkeletonModification2D < Resource < RefCounted < Object

A modification that jiggles Bone2D nodes as they move towards a target.

## Description

This modification moves a series of bones, typically called a bone chain, towards a target. What makes this modification special is that it calculates the velocity and acceleration for each bone in the bone chain, and runs a very light physics-like calculation using the inputted values. This allows the bones to overshoot the target and "jiggle" around. It can be configured to act more like a spring, or sway around like cloth might.

This modification is useful for adding additional motion to things like hair, the edges of clothing, and more. It has several settings to that allow control over how the joint moves when the target moves.

Note: The Jiggle modifier has jiggle_joints, which are the data objects that hold the data for each joint in the Jiggle chain. This is different from than Bone2D nodes! Jiggle joints hold the data needed for each Bone2D in the bone chain used by the Jiggle modification.

## Properties

float | damping | 0.75
Vector2 | gravity | Vector2(0, 6)
int | jiggle_data_chain_length | 0
float | mass | 0.75
float | stiffness | 3.0
NodePath | target_nodepath | NodePath("")
bool | use_gravity | false

## Methods

int | get_collision_mask() const
NodePath | get_jiggle_joint_bone2d_node(joint_idx: int) const
int | get_jiggle_joint_bone_index(joint_idx: int) const
float | get_jiggle_joint_damping(joint_idx: int) const
Vector2 | get_jiggle_joint_gravity(joint_idx: int) const
float | get_jiggle_joint_mass(joint_idx: int) const
bool | get_jiggle_joint_override(joint_idx: int) const
float | get_jiggle_joint_stiffness(joint_idx: int) const
bool | get_jiggle_joint_use_gravity(joint_idx: int) const
bool | get_use_colliders() const
void | reset()
void | set_collision_mask(collision_mask: int)
void | set_jiggle_joint_bone2d_node(joint_idx: int, bone2d_node: NodePath)
void | set_jiggle_joint_bone_index(joint_idx: int, bone_idx: int)
void | set_jiggle_joint_damping(joint_idx: int, damping: float)
void | set_jiggle_joint_gravity(joint_idx: int, gravity: Vector2)
void | set_jiggle_joint_mass(joint_idx: int, mass: float)
void | set_jiggle_joint_override(joint_idx: int, override: bool)
void | set_jiggle_joint_stiffness(joint_idx: int, stiffness: float)
void | set_jiggle_joint_use_gravity(joint_idx: int, use_gravity: bool)
void | set_use_colliders(use_colliders: bool)

---

## Property Descriptions

float damping = 0.75 

- void set_damping(value: float)
- float get_damping()

The default amount of damping applied to the Jiggle joints, if they are not overridden. Higher values lead to more of the calculated velocity being applied.

---

Vector2 gravity = Vector2(0, 6) 

- void set_gravity(value: Vector2)
- Vector2 get_gravity()

The default amount of gravity applied to the Jiggle joints, if they are not overridden.

---

int jiggle_data_chain_length = 0 

- void set_jiggle_data_chain_length(value: int)
- int get_jiggle_data_chain_length()

The amount of Jiggle joints in the Jiggle modification.

---

float mass = 0.75 

- void set_mass(value: float)
- float get_mass()

The default amount of mass assigned to the Jiggle joints, if they are not overridden. Higher values lead to faster movements and more overshooting.

---

float stiffness = 3.0 

- void set_stiffness(value: float)
- float get_stiffness()

The default amount of stiffness assigned to the Jiggle joints, if they are not overridden. Higher values act more like springs, quickly moving into the correct position.

---

NodePath target_nodepath = NodePath("") 

- void set_target_node(value: NodePath)
- NodePath get_target_node()

The NodePath to the node that is the target for the Jiggle modification. This node is what the Jiggle chain will attempt to rotate the bone chain to.

---

bool use_gravity = false 

- void set_use_gravity(value: bool)
- bool get_use_gravity()

Whether the gravity vector, gravity, should be applied to the Jiggle joints, assuming they are not overriding the default settings.

---

## Method Descriptions

int get_collision_mask() const 

Returns the collision mask used by the Jiggle modifier when collisions are enabled.

---

NodePath get_jiggle_joint_bone2d_node(joint_idx: int) const 

Returns the Bone2D node assigned to the Jiggle joint at joint_idx.

---

int get_jiggle_joint_bone_index(joint_idx: int) const 

Returns the index of the Bone2D node assigned to the Jiggle joint at joint_idx.

---

float get_jiggle_joint_damping(joint_idx: int) const 

Returns the amount of damping of the Jiggle joint at joint_idx.

---

Vector2 get_jiggle_joint_gravity(joint_idx: int) const 

Returns a Vector2 representing the amount of gravity the Jiggle joint at joint_idx is influenced by.

---

float get_jiggle_joint_mass(joint_idx: int) const 

Returns the amount of mass of the jiggle joint at joint_idx.

---

bool get_jiggle_joint_override(joint_idx: int) const 

Returns a boolean that indicates whether the joint at joint_idx is overriding the default Jiggle joint data defined in the modification.

---

float get_jiggle_joint_stiffness(joint_idx: int) const 

Returns the stiffness of the Jiggle joint at joint_idx.

---

bool get_jiggle_joint_use_gravity(joint_idx: int) const 

Returns a boolean that indicates whether the joint at joint_idx is using gravity or not.

---

bool get_use_colliders() const 

Returns whether the jiggle modifier is taking physics colliders into account when solving.

---

void reset() 

Resets the internal jiggle simulation state to the current bone positions, clearing velocity, acceleration, and accumulated forces.

---

void set_collision_mask(collision_mask: int) 

Sets the collision mask that the Jiggle modifier will use when reacting to colliders, if the Jiggle modifier is set to take colliders into account.

---

void set_jiggle_joint_bone2d_node(joint_idx: int, bone2d_node: NodePath) 

Sets the Bone2D node assigned to the Jiggle joint at joint_idx.

---

void set_jiggle_joint_bone_index(joint_idx: int, bone_idx: int) 

Sets the bone index, bone_idx, of the Jiggle joint at joint_idx. When possible, this will also update the bone2d_node of the Jiggle joint based on data provided by the linked skeleton.

---

void set_jiggle_joint_damping(joint_idx: int, damping: float) 

Sets the amount of damping of the Jiggle joint at joint_idx.

---

void set_jiggle_joint_gravity(joint_idx: int, gravity: Vector2) 

Sets the gravity vector of the Jiggle joint at joint_idx.

---

void set_jiggle_joint_mass(joint_idx: int, mass: float) 

Sets the of mass of the Jiggle joint at joint_idx.

---

void set_jiggle_joint_override(joint_idx: int, override: bool) 

Sets whether the Jiggle joint at joint_idx should override the default Jiggle joint settings. Setting this to true will make the joint use its own settings rather than the default ones attached to the modification.

---

void set_jiggle_joint_stiffness(joint_idx: int, stiffness: float) 

Sets the of stiffness of the Jiggle joint at joint_idx.

---

void set_jiggle_joint_use_gravity(joint_idx: int, use_gravity: bool) 

Sets whether the Jiggle joint at joint_idx should use gravity.

---

void set_use_colliders(use_colliders: bool) 

If true, the Jiggle modifier will take colliders into account, keeping them from entering into these collision objects.
