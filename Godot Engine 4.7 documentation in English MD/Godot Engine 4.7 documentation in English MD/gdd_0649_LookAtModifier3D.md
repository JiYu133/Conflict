# LookAtModifier3D

Inherits: SkeletonModifier3D < Node3D < Node < Object

The LookAtModifier3D rotates a bone to look at a target.

## Description

This SkeletonModifier3D rotates a bone to look at a target. This is helpful for moving a character's head to look at the player, rotating a turret to look at a target, or any other case where you want to make a bone rotate towards something quickly and easily.

When applying multiple LookAtModifier3Ds, the LookAtModifier3D assigned to the parent bone must be put above the LookAtModifier3D assigned to the child bone in the list in order for the child bone results to be correct.

## Properties

int | bone | -1
String | bone_name | ""
float | duration | 0.0
EaseType | ease_type | 0
BoneAxis | forward_axis | 4
int | origin_bone |
String | origin_bone_name |
NodePath | origin_external_node |
OriginFrom | origin_from | 0
Vector3 | origin_offset | Vector3(0, 0, 0)
float | origin_safe_margin | 0.1
float | primary_damp_threshold |
float | primary_limit_angle |
float | primary_negative_damp_threshold |
float | primary_negative_limit_angle |
float | primary_positive_damp_threshold |
float | primary_positive_limit_angle |
Axis | primary_rotation_axis | 1
bool | relative | false
float | secondary_damp_threshold |
float | secondary_limit_angle |
float | secondary_negative_damp_threshold |
float | secondary_negative_limit_angle |
float | secondary_positive_damp_threshold |
float | secondary_positive_limit_angle |
bool | symmetry_limitation |
NodePath | target_node | NodePath("")
TransitionType | transition_type | 0
bool | use_angle_limitation | false
bool | use_secondary_rotation | true

## Methods

float | get_interpolation_remaining() const
bool | is_interpolating() const
bool | is_target_within_limitation() const

---

## Enumerations

enum OriginFrom
OriginFrom ORIGIN_FROM_SELF = 0

The bone rest position of the bone specified in bone is used as origin.

OriginFrom ORIGIN_FROM_SPECIFIC_BONE = 1

The bone global pose position of the bone specified in origin_bone is used as origin.

Note: It is recommended that you select only the parent bone unless you are familiar with the bone processing process. The specified bone pose at the time the LookAtModifier3D is processed is used as a reference. In other words, if you specify a child bone and the LookAtModifier3D causes the child bone to move, the rendered result and direction will not match.

OriginFrom ORIGIN_FROM_EXTERNAL_NODE = 2

The global position of the Node3D specified in origin_external_node is used as origin.

Note: Same as ORIGIN_FROM_SPECIFIC_BONE, when specifying a BoneAttachment3D with a child bone assigned, the rendered result and direction will not match.

---

## Property Descriptions

int bone = -1 

- void set_bone(value: int)
- int get_bone()

Index of the bone_name in the parent Skeleton3D.

---

String bone_name = "" 

- void set_bone_name(value: String)
- String get_bone_name()

The bone name of the Skeleton3D that the modification will operate on.

---

float duration = 0.0 

- void set_duration(value: float)
- float get_duration()

The duration of the time-based interpolation. Interpolation is triggered at the following cases:

- When the target node is changed
- When an axis is flipped due to angle limitation

Note: The flipping occurs when the target is outside the angle limitation and the internally computed secondary rotation axis of the forward vector is flipped. Visually, it occurs when the target is outside the angle limitation and crosses the plane of the forward_axis and primary_rotation_axis.

---

EaseType ease_type = 0 

- void set_ease_type(value: EaseType)
- EaseType get_ease_type()

The ease type of the time-based interpolation. See also EaseType.

---

BoneAxis forward_axis = 4 

- void set_forward_axis(value: BoneAxis)
- BoneAxis get_forward_axis()

The forward axis of the bone. This SkeletonModifier3D modifies the bone so that this axis points toward the target_node.

---

int origin_bone 

- void set_origin_bone(value: int)
- int get_origin_bone()

Index of the origin_bone_name in the parent Skeleton3D.

---

String origin_bone_name 

- void set_origin_bone_name(value: String)
- String get_origin_bone_name()

If origin_from is ORIGIN_FROM_SPECIFIC_BONE, the bone global pose position specified for this is used as origin.

---

NodePath origin_external_node 

- void set_origin_external_node(value: NodePath)
- NodePath get_origin_external_node()

If origin_from is ORIGIN_FROM_EXTERNAL_NODE, the global position of the Node3D specified for this is used as origin.

---

OriginFrom origin_from = 0 

- void set_origin_from(value: OriginFrom)
- OriginFrom get_origin_from()

This value determines from what origin is retrieved for use in the calculation of the forward vector.

---

Vector3 origin_offset = Vector3(0, 0, 0) 

- void set_origin_offset(value: Vector3)
- Vector3 get_origin_offset()

The offset of the bone pose origin. Matching the origins by offset is useful for cases where multiple bones must always face the same direction, such as the eyes.

Note: This value indicates the local position of the object set in origin_from.

---

float origin_safe_margin = 0.1 

- void set_origin_safe_margin(value: float)
- float get_origin_safe_margin()

If the target passes through too close to the origin than this value, time-based interpolation is used even if the target is within the angular limitations, to prevent the angular velocity from becoming too high.

---

float primary_damp_threshold 

- void set_primary_damp_threshold(value: float)
- float get_primary_damp_threshold()

The threshold to start damping for primary_limit_angle. It provides non-linear (b-spline) interpolation, let it feel more resistance the more it rotate to the edge limit. This is useful for simulating the limits of human motion.

If 1.0, no damping is performed. If 0.0, damping is always performed.

---

float primary_limit_angle 

- void set_primary_limit_angle(value: float)
- float get_primary_limit_angle()

The limit angle of the primary rotation when symmetry_limitation is true, in radians.

---

float primary_negative_damp_threshold 

- void set_primary_negative_damp_threshold(value: float)
- float get_primary_negative_damp_threshold()

The threshold to start damping for primary_negative_limit_angle.

---

float primary_negative_limit_angle 

- void set_primary_negative_limit_angle(value: float)
- float get_primary_negative_limit_angle()

The limit angle of negative side of the primary rotation when symmetry_limitation is false, in radians.

---

float primary_positive_damp_threshold 

- void set_primary_positive_damp_threshold(value: float)
- float get_primary_positive_damp_threshold()

The threshold to start damping for primary_positive_limit_angle.

---

float primary_positive_limit_angle 

- void set_primary_positive_limit_angle(value: float)
- float get_primary_positive_limit_angle()

The limit angle of positive side of the primary rotation when symmetry_limitation is false, in radians.

---

Axis primary_rotation_axis = 1 

- void set_primary_rotation_axis(value: Axis)
- Axis get_primary_rotation_axis()

The axis of the first rotation. This SkeletonModifier3D works by compositing the rotation by Euler angles to prevent to rotate the forward_axis.

---

bool relative = false 

- void set_relative(value: bool)
- bool is_relative()

The relative option. If true, the rotation is applied relative to the pose. If false, the rotation is applied relative to the rest. It means to replace the current pose with the LookAtModifier3D's result.

Note: This option affects the base angle for use_angle_limitation. Since the LookAtModifier3D relies strongly on Euler rotation, the axis that determines the limitation and the actual rotation are strongly tied together.

---

float secondary_damp_threshold 

- void set_secondary_damp_threshold(value: float)
- float get_secondary_damp_threshold()

The threshold to start damping for secondary_limit_angle.

---

float secondary_limit_angle 

- void set_secondary_limit_angle(value: float)
- float get_secondary_limit_angle()

The limit angle of the secondary rotation when symmetry_limitation is true, in radians.

---

float secondary_negative_damp_threshold 

- void set_secondary_negative_damp_threshold(value: float)
- float get_secondary_negative_damp_threshold()

The threshold to start damping for secondary_negative_limit_angle.

---

float secondary_negative_limit_angle 

- void set_secondary_negative_limit_angle(value: float)
- float get_secondary_negative_limit_angle()

The limit angle of negative side of the secondary rotation when symmetry_limitation is false, in radians.

---

float secondary_positive_damp_threshold 

- void set_secondary_positive_damp_threshold(value: float)
- float get_secondary_positive_damp_threshold()

The threshold to start damping for secondary_positive_limit_angle.

---

float secondary_positive_limit_angle 

- void set_secondary_positive_limit_angle(value: float)
- float get_secondary_positive_limit_angle()

The limit angle of positive side of the secondary rotation when symmetry_limitation is false, in radians.

---

bool symmetry_limitation 

- void set_symmetry_limitation(value: bool)
- bool is_limitation_symmetry()

If true, the limitations are spread from the bone symmetrically.

If false, the limitation can be specified separately for each side of the bone rest.

---

NodePath target_node = NodePath("") 

- void set_target_node(value: NodePath)
- NodePath get_target_node()

The NodePath to the node that is the target for the look at modification. This node is what the modification will rotate the bone to.

---

TransitionType transition_type = 0 

- void set_transition_type(value: TransitionType)
- TransitionType get_transition_type()

The transition type of the time-based interpolation. See also TransitionType.

---

bool use_angle_limitation = false 

- void set_use_angle_limitation(value: bool)
- bool is_using_angle_limitation()

If true, limits the amount of rotation. For example, this helps to prevent a character's neck from rotating 360 degrees.

Note: As with AnimationTree blending, interpolation is provided that favors Skeleton3D.get_bone_rest() or Skeleton3D.get_bone_pose() depends on the relative option. This means that interpolation does not select the shortest path in some cases.

Note: Some values for transition_type (such as Tween.TRANS_BACK, Tween.TRANS_ELASTIC, and Tween.TRANS_SPRING) may exceed the limitations. If interpolation occurs while overshooting the limitations, the result might not respect the bone rest.

---

bool use_secondary_rotation = true 

- void set_use_secondary_rotation(value: bool)
- bool is_using_secondary_rotation()

If true, provides rotation by two axes.

---

## Method Descriptions

float get_interpolation_remaining() const 

Returns the remaining seconds of the time-based interpolation.

---

bool is_interpolating() const 

Returns true if time-based interpolation is running. If true, it is equivalent to get_interpolation_remaining() returning 0.0.

This is useful to determine whether a LookAtModifier3D can be removed safely.

---

bool is_target_within_limitation() const 

Returns whether the target is within the angle limitations. It is useful for unsetting the target_node when the target is outside of the angle limitations.

Note: The value is updated after SkeletonModifier3D._process_modification(). To retrieve this value correctly, we recommend using the signal SkeletonModifier3D.modification_processed.
