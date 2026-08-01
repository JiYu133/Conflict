# SkeletonIK3D

Deprecated: This class may be changed or removed in future versions.

Inherits: SkeletonModifier3D < Node3D < Node < Object

A node used to rotate all bones of a Skeleton3D bone chain a way that places the end bone at a desired 3D position.

## Description

SkeletonIK3D is used to rotate all bones of a Skeleton3D bone chain a way that places the end bone at a desired 3D position. A typical scenario for IK in games is to place a character's feet on the ground or a character's hands on a currently held object. SkeletonIK uses FabrikInverseKinematic internally to solve the bone chain and applies the results to the Skeleton3D bones_global_pose_override property for all affected bones in the chain. If fully applied, this overwrites any bone transform from Animations or bone custom poses set by users. The applied amount can be controlled with the SkeletonModifier3D.influence property.

```gdscript
# Apply IK effect automatically on every new frame (not the current)
skeleton_ik_node.start()
# Apply IK effect only on the current frame
skeleton_ik_node.start(true)
# Stop IK effect and reset bones_global_pose_override on Skeleton
skeleton_ik_node.stop()
# Apply full IK effect
skeleton_ik_node.set_influence(1.0)
# Apply half IK effect
skeleton_ik_node.set_influence(0.5)
# Apply zero IK effect (a value at or below 0.01 also removes bones_global_pose_override on Skeleton)
skeleton_ik_node.set_influence(0.0)
```

## Properties

float | interpolation |
Vector3 | magnet | Vector3(0, 0, 0)
int | max_iterations | 10
float | min_distance | 0.01
bool | override_tip_basis | true
StringName | root_bone | &""
Transform3D | target | Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)
NodePath | target_node | NodePath("")
StringName | tip_bone | &""
bool | use_magnet | false

## Methods

Skeleton3D | get_parent_skeleton() const
bool | is_running()
void | start(one_time: bool = false)
void | stop()

---

## Property Descriptions

float interpolation 

- void set_interpolation(value: float)
- float get_interpolation()

Deprecated: Use SkeletonModifier3D.influence instead.

Interpolation value for how much the IK results are applied to the current skeleton bone chain. A value of 1.0 will overwrite all skeleton bone transforms completely while a value of 0.0 will visually disable the SkeletonIK.

---

Vector3 magnet = Vector3(0, 0, 0) 

- void set_magnet_position(value: Vector3)
- Vector3 get_magnet_position()

Secondary target position (first is target property or target_node) for the IK chain. Use magnet position (pole target) to control the bending of the IK chain. Only works if the bone chain has more than 2 bones. The middle chain bone position will be linearly interpolated with the magnet position.

---

int max_iterations = 10 

- void set_max_iterations(value: int)
- int get_max_iterations()

Number of iteration loops used by the IK solver to produce more accurate (and elegant) bone chain results.

---

float min_distance = 0.01 

- void set_min_distance(value: float)
- float get_min_distance()

The minimum distance between bone and goal target. If the distance is below this value, the IK solver stops further iterations.

---

bool override_tip_basis = true 

- void set_override_tip_basis(value: bool)
- bool is_override_tip_basis()

If true overwrites the rotation of the tip bone with the rotation of the target (or target_node if defined).

---

StringName root_bone = &"" 

- void set_root_bone(value: StringName)
- StringName get_root_bone()

The name of the current root bone, the first bone in the IK chain.

---

Transform3D target = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0) 

- void set_target_transform(value: Transform3D)
- Transform3D get_target_transform()

First target of the IK chain where the tip bone is placed and, if override_tip_basis is true, how the tip bone is rotated. If a target_node path is available the nodes transform is used instead and this property is ignored.

---

NodePath target_node = NodePath("") 

- void set_target_node(value: NodePath)
- NodePath get_target_node()

Target node NodePath for the IK chain. If available, the node's current Transform3D is used instead of the target property.

---

StringName tip_bone = &"" 

- void set_tip_bone(value: StringName)
- StringName get_tip_bone()

The name of the current tip bone, the last bone in the IK chain placed at the target transform (or target_node if defined).

---

bool use_magnet = false 

- void set_use_magnet(value: bool)
- bool is_using_magnet()

If true, instructs the IK solver to consider the secondary magnet target (pole target) when calculating the bone chain. Use the magnet position (pole target) to control the bending of the IK chain.

---

## Method Descriptions

Skeleton3D get_parent_skeleton() const 

Returns the parent Skeleton3D node that was present when SkeletonIK entered the scene tree. Returns null if the parent node was not a Skeleton3D node when SkeletonIK3D entered the scene tree.

---

bool is_running() 

Returns true if SkeletonIK is applying IK effects on continues frames to the Skeleton3D bones. Returns false if SkeletonIK is stopped or start() was used with the one_time parameter set to true.

---

void start(one_time: bool = false) 

Starts applying IK effects on each frame to the Skeleton3D bones but will only take effect starting on the next frame. If one_time is true, this will take effect immediately but also reset on the next frame.

---

void stop() 

Stops applying IK effects on each frame to the Skeleton3D bones and also calls Skeleton3D.clear_bones_global_pose_override() to remove existing overrides on all bones.
