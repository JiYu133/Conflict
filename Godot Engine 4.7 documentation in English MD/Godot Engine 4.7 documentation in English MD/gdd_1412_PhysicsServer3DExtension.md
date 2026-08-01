# PhysicsServer3DExtension

Inherits: PhysicsServer3D < Object

Provides virtual methods that can be overridden to create custom PhysicsServer3D implementations.

## Description

This class extends PhysicsServer3D by providing additional virtual methods that can be overridden. When these methods are overridden, they will be called instead of the internal methods of the physics server.

Intended for use with GDExtension to create custom implementations of PhysicsServer3D.

## Methods

void | _area_add_shape(area: RID, shape: RID, transform: Transform3D, disabled: bool) virtual required
void | _area_attach_object_instance_id(area: RID, id: int) virtual required
void | _area_clear_shapes(area: RID) virtual required
RID | _area_create() virtual required
int | _area_get_collision_layer(area: RID) virtual required const
int | _area_get_collision_mask(area: RID) virtual required const
int | _area_get_object_instance_id(area: RID) virtual required const
Variant | _area_get_param(area: RID, param: AreaParameter) virtual required const
RID | _area_get_shape(area: RID, shape_idx: int) virtual required const
int | _area_get_shape_count(area: RID) virtual required const
Transform3D | _area_get_shape_transform(area: RID, shape_idx: int) virtual required const
RID | _area_get_space(area: RID) virtual required const
Transform3D | _area_get_transform(area: RID) virtual required const
void | _area_remove_shape(area: RID, shape_idx: int) virtual required
void | _area_set_area_monitor_callback(area: RID, callback: Callable) virtual required
void | _area_set_collision_layer(area: RID, layer: int) virtual required
void | _area_set_collision_mask(area: RID, mask: int) virtual required
void | _area_set_monitor_callback(area: RID, callback: Callable) virtual required
void | _area_set_monitorable(area: RID, monitorable: bool) virtual required
void | _area_set_param(area: RID, param: AreaParameter, value: Variant) virtual required
void | _area_set_ray_pickable(area: RID, enable: bool) virtual required
void | _area_set_shape(area: RID, shape_idx: int, shape: RID) virtual required
void | _area_set_shape_disabled(area: RID, shape_idx: int, disabled: bool) virtual required
void | _area_set_shape_transform(area: RID, shape_idx: int, transform: Transform3D) virtual required
void | _area_set_space(area: RID, space: RID) virtual required
void | _area_set_transform(area: RID, transform: Transform3D) virtual required
void | _body_add_collision_exception(body: RID, excepted_body: RID) virtual required
void | _body_add_constant_central_force(body: RID, force: Vector3) virtual required
void | _body_add_constant_force(body: RID, force: Vector3, position: Vector3) virtual required
void | _body_add_constant_torque(body: RID, torque: Vector3) virtual required
void | _body_add_shape(body: RID, shape: RID, transform: Transform3D, disabled: bool) virtual required
void | _body_apply_central_force(body: RID, force: Vector3) virtual required
void | _body_apply_central_impulse(body: RID, impulse: Vector3) virtual required
void | _body_apply_force(body: RID, force: Vector3, position: Vector3) virtual required
void | _body_apply_impulse(body: RID, impulse: Vector3, position: Vector3) virtual required
void | _body_apply_torque(body: RID, torque: Vector3) virtual required
void | _body_apply_torque_impulse(body: RID, impulse: Vector3) virtual required
void | _body_attach_object_instance_id(body: RID, id: int) virtual required
void | _body_clear_shapes(body: RID) virtual required
RID | _body_create() virtual required
Array[RID] | _body_get_collision_exceptions(body: RID) virtual required const
int | _body_get_collision_layer(body: RID) virtual required const
int | _body_get_collision_mask(body: RID) virtual required const
float | _body_get_collision_priority(body: RID) virtual required const
Vector3 | _body_get_constant_force(body: RID) virtual required const
Vector3 | _body_get_constant_torque(body: RID) virtual required const
float | _body_get_contacts_reported_depth_threshold(body: RID) virtual required const
PhysicsDirectBodyState3D | _body_get_direct_state(body: RID) virtual required
int | _body_get_max_contacts_reported(body: RID) virtual required const
BodyMode | _body_get_mode(body: RID) virtual required const
int | _body_get_object_instance_id(body: RID) virtual required const
Variant | _body_get_param(body: RID, param: BodyParameter) virtual required const
RID | _body_get_shape(body: RID, shape_idx: int) virtual required const
int | _body_get_shape_count(body: RID) virtual required const
Transform3D | _body_get_shape_transform(body: RID, shape_idx: int) virtual required const
RID | _body_get_space(body: RID) virtual required const
Variant | _body_get_state(body: RID, state: BodyState) virtual required const
int | _body_get_user_flags(body: RID) virtual required const
bool | _body_is_axis_locked(body: RID, axis: BodyAxis) virtual required const
bool | _body_is_continuous_collision_detection_enabled(body: RID) virtual required const
bool | _body_is_omitting_force_integration(body: RID) virtual required const
void | _body_remove_collision_exception(body: RID, excepted_body: RID) virtual required
void | _body_remove_shape(body: RID, shape_idx: int) virtual required
void | _body_reset_mass_properties(body: RID) virtual required
void | _body_set_axis_lock(body: RID, axis: BodyAxis, lock: bool) virtual required
void | _body_set_axis_velocity(body: RID, axis_velocity: Vector3) virtual required
void | _body_set_collision_layer(body: RID, layer: int) virtual required
void | _body_set_collision_mask(body: RID, mask: int) virtual required
void | _body_set_collision_priority(body: RID, priority: float) virtual required
void | _body_set_constant_force(body: RID, force: Vector3) virtual required
void | _body_set_constant_torque(body: RID, torque: Vector3) virtual required
void | _body_set_contacts_reported_depth_threshold(body: RID, threshold: float) virtual required
void | _body_set_enable_continuous_collision_detection(body: RID, enable: bool) virtual required
void | _body_set_force_integration_callback(body: RID, callable: Callable, userdata: Variant) virtual required
void | _body_set_max_contacts_reported(body: RID, amount: int) virtual required
void | _body_set_mode(body: RID, mode: BodyMode) virtual required
void | _body_set_omit_force_integration(body: RID, enable: bool) virtual required
void | _body_set_param(body: RID, param: BodyParameter, value: Variant) virtual required
void | _body_set_ray_pickable(body: RID, enable: bool) virtual required
void | _body_set_shape(body: RID, shape_idx: int, shape: RID) virtual required
void | _body_set_shape_disabled(body: RID, shape_idx: int, disabled: bool) virtual required
void | _body_set_shape_transform(body: RID, shape_idx: int, transform: Transform3D) virtual required
void | _body_set_space(body: RID, space: RID) virtual required
void | _body_set_state(body: RID, state: BodyState, value: Variant) virtual required
void | _body_set_state_sync_callback(body: RID, callable: Callable) virtual required
void | _body_set_user_flags(body: RID, flags: int) virtual required
bool | _body_test_motion(body: RID, from: Transform3D, motion: Vector3, margin: float, max_collisions: int, collide_separation_ray: bool, recovery_as_collision: bool, r_result: PhysicsServer3DExtensionMotionResult*) virtual required const
RID | _box_shape_create() virtual required
RID | _capsule_shape_create() virtual required
RID | _concave_polygon_shape_create() virtual required
float | _cone_twist_joint_get_param(joint: RID, param: ConeTwistJointParam) virtual required const
void | _cone_twist_joint_set_param(joint: RID, param: ConeTwistJointParam, value: float) virtual required
RID | _convex_polygon_shape_create() virtual required
RID | _custom_shape_create() virtual required
RID | _cylinder_shape_create() virtual required
void | _end_sync() virtual required
void | _finish() virtual required
void | _flush_queries() virtual required
void | _free_rid(rid: RID) virtual required
bool | _generic_6dof_joint_get_flag(joint: RID, axis: Axis, flag: G6DOFJointAxisFlag) virtual required const
float | _generic_6dof_joint_get_param(joint: RID, axis: Axis, param: G6DOFJointAxisParam) virtual required const
void | _generic_6dof_joint_set_flag(joint: RID, axis: Axis, flag: G6DOFJointAxisFlag, enable: bool) virtual required
void | _generic_6dof_joint_set_param(joint: RID, axis: Axis, param: G6DOFJointAxisParam, value: float) virtual required
int | _get_process_info(process_info: ProcessInfo) virtual required
RID | _heightmap_shape_create() virtual required
bool | _hinge_joint_get_flag(joint: RID, flag: HingeJointFlag) virtual required const
float | _hinge_joint_get_param(joint: RID, param: HingeJointParam) virtual required const
void | _hinge_joint_set_flag(joint: RID, flag: HingeJointFlag, enabled: bool) virtual required
void | _hinge_joint_set_param(joint: RID, param: HingeJointParam, value: float) virtual required
void | _init() virtual required
bool | _is_flushing_queries() virtual required const
void | _joint_clear(joint: RID) virtual required
RID | _joint_create() virtual required
void | _joint_disable_collisions_between_bodies(joint: RID, disable: bool) virtual required
int | _joint_get_solver_priority(joint: RID) virtual required const
JointType | _joint_get_type(joint: RID) virtual required const
bool | _joint_is_disabled_collisions_between_bodies(joint: RID) virtual required const
void | _joint_make_cone_twist(joint: RID, body_A: RID, local_ref_A: Transform3D, body_B: RID, local_ref_B: Transform3D) virtual required
void | _joint_make_generic_6dof(joint: RID, body_A: RID, local_ref_A: Transform3D, body_B: RID, local_ref_B: Transform3D) virtual required
void | _joint_make_hinge(joint: RID, body_A: RID, hinge_A: Transform3D, body_B: RID, hinge_B: Transform3D) virtual required
void | _joint_make_hinge_simple(joint: RID, body_A: RID, pivot_A: Vector3, axis_A: Vector3, body_B: RID, pivot_B: Vector3, axis_B: Vector3) virtual required
void | _joint_make_pin(joint: RID, body_A: RID, local_A: Vector3, body_B: RID, local_B: Vector3) virtual required
void | _joint_make_slider(joint: RID, body_A: RID, local_ref_A: Transform3D, body_B: RID, local_ref_B: Transform3D) virtual required
void | _joint_set_solver_priority(joint: RID, priority: int) virtual required
Vector3 | _pin_joint_get_local_a(joint: RID) virtual required const
Vector3 | _pin_joint_get_local_b(joint: RID) virtual required const
float | _pin_joint_get_param(joint: RID, param: PinJointParam) virtual required const
void | _pin_joint_set_local_a(joint: RID, local_A: Vector3) virtual required
void | _pin_joint_set_local_b(joint: RID, local_B: Vector3) virtual required
void | _pin_joint_set_param(joint: RID, param: PinJointParam, value: float) virtual required
RID | _separation_ray_shape_create() virtual required
void | _set_active(active: bool) virtual required
float | _shape_get_custom_solver_bias(shape: RID) virtual required const
Variant | _shape_get_data(shape: RID) virtual required const
float | _shape_get_margin(shape: RID) virtual required const
ShapeType | _shape_get_type(shape: RID) virtual required const
void | _shape_set_custom_solver_bias(shape: RID, bias: float) virtual required
void | _shape_set_data(shape: RID, data: Variant) virtual required
void | _shape_set_margin(shape: RID, margin: float) virtual required
float | _slider_joint_get_param(joint: RID, param: SliderJointParam) virtual required const
void | _slider_joint_set_param(joint: RID, param: SliderJointParam, value: float) virtual required
void | _soft_body_add_collision_exception(body: RID, body_b: RID) virtual required
void | _soft_body_apply_central_force(body: RID, force: Vector3) virtual required
void | _soft_body_apply_central_impulse(body: RID, impulse: Vector3) virtual required
void | _soft_body_apply_point_force(body: RID, point_index: int, force: Vector3) virtual required
void | _soft_body_apply_point_impulse(body: RID, point_index: int, impulse: Vector3) virtual required
RID | _soft_body_create() virtual required
AABB | _soft_body_get_bounds(body: RID) virtual required const
Array[RID] | _soft_body_get_collision_exceptions(body: RID) virtual required const
int | _soft_body_get_collision_layer(body: RID) virtual required const
int | _soft_body_get_collision_mask(body: RID) virtual required const
float | _soft_body_get_damping_coefficient(body: RID) virtual required const
float | _soft_body_get_drag_coefficient(body: RID) virtual required const
float | _soft_body_get_linear_stiffness(body: RID) virtual required const
Vector3 | _soft_body_get_point_global_position(body: RID, point_index: int) virtual required const
float | _soft_body_get_pressure_coefficient(body: RID) virtual required const
float | _soft_body_get_shrinking_factor(body: RID) virtual required const
int | _soft_body_get_simulation_precision(body: RID) virtual required const
RID | _soft_body_get_space(body: RID) virtual required const
Variant | _soft_body_get_state(body: RID, state: BodyState) virtual required const
float | _soft_body_get_total_mass(body: RID) virtual required const
bool | _soft_body_is_point_pinned(body: RID, point_index: int) virtual required const
void | _soft_body_move_point(body: RID, point_index: int, global_position: Vector3) virtual required
void | _soft_body_pin_point(body: RID, point_index: int, pin: bool) virtual required
void | _soft_body_remove_all_pinned_points(body: RID) virtual required
void | _soft_body_remove_collision_exception(body: RID, body_b: RID) virtual required
void | _soft_body_set_collision_layer(body: RID, layer: int) virtual required
void | _soft_body_set_collision_mask(body: RID, mask: int) virtual required
void | _soft_body_set_damping_coefficient(body: RID, damping_coefficient: float) virtual required
void | _soft_body_set_drag_coefficient(body: RID, drag_coefficient: float) virtual required
void | _soft_body_set_linear_stiffness(body: RID, linear_stiffness: float) virtual required
void | _soft_body_set_mesh(body: RID, mesh: RID) virtual required
void | _soft_body_set_pressure_coefficient(body: RID, pressure_coefficient: float) virtual required
void | _soft_body_set_ray_pickable(body: RID, enable: bool) virtual required
void | _soft_body_set_shrinking_factor(body: RID, shrinking_factor: float) virtual required
void | _soft_body_set_simulation_precision(body: RID, simulation_precision: int) virtual required
void | _soft_body_set_space(body: RID, space: RID) virtual required
void | _soft_body_set_state(body: RID, state: BodyState, variant: Variant) virtual required
void | _soft_body_set_total_mass(body: RID, total_mass: float) virtual required
void | _soft_body_set_transform(body: RID, transform: Transform3D) virtual required
void | _soft_body_update_rendering_server(body: RID, rendering_server_handler: PhysicsServer3DRenderingServerHandler) virtual required
RID | _space_create() virtual required
int | _space_get_contact_count(space: RID) virtual required const
PackedVector3Array | _space_get_contacts(space: RID) virtual required const
PhysicsDirectSpaceState3D | _space_get_direct_state(space: RID) virtual required
float | _space_get_param(space: RID, param: SpaceParameter) virtual required const
bool | _space_is_active(space: RID) virtual required const
void | _space_set_active(space: RID, active: bool) virtual required
void | _space_set_debug_contacts(space: RID, max_contacts: int) virtual required
void | _space_set_param(space: RID, param: SpaceParameter, value: float) virtual required
RID | _sphere_shape_create() virtual required
void | _step(step: float) virtual required
void | _sync() virtual required
RID | _world_boundary_shape_create() virtual required
bool | body_test_motion_is_excluding_body(body: RID) const
bool | body_test_motion_is_excluding_object(object: int) const

---

## Method Descriptions

void _area_add_shape(area: RID, shape: RID, transform: Transform3D, disabled: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _area_attach_object_instance_id(area: RID, id: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _area_clear_shapes(area: RID) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _area_create() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _area_get_collision_layer(area: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _area_get_collision_mask(area: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _area_get_object_instance_id(area: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Variant _area_get_param(area: RID, param: AreaParameter) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _area_get_shape(area: RID, shape_idx: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _area_get_shape_count(area: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Transform3D _area_get_shape_transform(area: RID, shape_idx: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _area_get_space(area: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Transform3D _area_get_transform(area: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _area_remove_shape(area: RID, shape_idx: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _area_set_area_monitor_callback(area: RID, callback: Callable) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _area_set_collision_layer(area: RID, layer: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _area_set_collision_mask(area: RID, mask: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _area_set_monitor_callback(area: RID, callback: Callable) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _area_set_monitorable(area: RID, monitorable: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _area_set_param(area: RID, param: AreaParameter, value: Variant) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _area_set_ray_pickable(area: RID, enable: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _area_set_shape(area: RID, shape_idx: int, shape: RID) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _area_set_shape_disabled(area: RID, shape_idx: int, disabled: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _area_set_shape_transform(area: RID, shape_idx: int, transform: Transform3D) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _area_set_space(area: RID, space: RID) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _area_set_transform(area: RID, transform: Transform3D) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_add_collision_exception(body: RID, excepted_body: RID) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_add_constant_central_force(body: RID, force: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_add_constant_force(body: RID, force: Vector3, position: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_add_constant_torque(body: RID, torque: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_add_shape(body: RID, shape: RID, transform: Transform3D, disabled: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_apply_central_force(body: RID, force: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_apply_central_impulse(body: RID, impulse: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_apply_force(body: RID, force: Vector3, position: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_apply_impulse(body: RID, impulse: Vector3, position: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_apply_torque(body: RID, torque: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_apply_torque_impulse(body: RID, impulse: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_attach_object_instance_id(body: RID, id: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_clear_shapes(body: RID) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _body_create() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Array[RID] _body_get_collision_exceptions(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _body_get_collision_layer(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _body_get_collision_mask(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _body_get_collision_priority(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _body_get_constant_force(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _body_get_constant_torque(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _body_get_contacts_reported_depth_threshold(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

PhysicsDirectBodyState3D _body_get_direct_state(body: RID) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _body_get_max_contacts_reported(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

BodyMode _body_get_mode(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _body_get_object_instance_id(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Variant _body_get_param(body: RID, param: BodyParameter) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _body_get_shape(body: RID, shape_idx: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _body_get_shape_count(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Transform3D _body_get_shape_transform(body: RID, shape_idx: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _body_get_space(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Variant _body_get_state(body: RID, state: BodyState) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _body_get_user_flags(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _body_is_axis_locked(body: RID, axis: BodyAxis) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _body_is_continuous_collision_detection_enabled(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _body_is_omitting_force_integration(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_remove_collision_exception(body: RID, excepted_body: RID) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_remove_shape(body: RID, shape_idx: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_reset_mass_properties(body: RID) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_axis_lock(body: RID, axis: BodyAxis, lock: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_axis_velocity(body: RID, axis_velocity: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_collision_layer(body: RID, layer: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_collision_mask(body: RID, mask: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_collision_priority(body: RID, priority: float) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_constant_force(body: RID, force: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_constant_torque(body: RID, torque: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_contacts_reported_depth_threshold(body: RID, threshold: float) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_enable_continuous_collision_detection(body: RID, enable: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_force_integration_callback(body: RID, callable: Callable, userdata: Variant) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_max_contacts_reported(body: RID, amount: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_mode(body: RID, mode: BodyMode) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_omit_force_integration(body: RID, enable: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_param(body: RID, param: BodyParameter, value: Variant) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_ray_pickable(body: RID, enable: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_shape(body: RID, shape_idx: int, shape: RID) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_shape_disabled(body: RID, shape_idx: int, disabled: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_shape_transform(body: RID, shape_idx: int, transform: Transform3D) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_space(body: RID, space: RID) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_state(body: RID, state: BodyState, value: Variant) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_state_sync_callback(body: RID, callable: Callable) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _body_set_user_flags(body: RID, flags: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _body_test_motion(body: RID, from: Transform3D, motion: Vector3, margin: float, max_collisions: int, collide_separation_ray: bool, recovery_as_collision: bool, r_result: PhysicsServer3DExtensionMotionResult*) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _box_shape_create() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _capsule_shape_create() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _concave_polygon_shape_create() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _cone_twist_joint_get_param(joint: RID, param: ConeTwistJointParam) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _cone_twist_joint_set_param(joint: RID, param: ConeTwistJointParam, value: float) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _convex_polygon_shape_create() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _custom_shape_create() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _cylinder_shape_create() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _end_sync() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _finish() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _flush_queries() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _free_rid(rid: RID) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _generic_6dof_joint_get_flag(joint: RID, axis: Axis, flag: G6DOFJointAxisFlag) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _generic_6dof_joint_get_param(joint: RID, axis: Axis, param: G6DOFJointAxisParam) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _generic_6dof_joint_set_flag(joint: RID, axis: Axis, flag: G6DOFJointAxisFlag, enable: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _generic_6dof_joint_set_param(joint: RID, axis: Axis, param: G6DOFJointAxisParam, value: float) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _get_process_info(process_info: ProcessInfo) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _heightmap_shape_create() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _hinge_joint_get_flag(joint: RID, flag: HingeJointFlag) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _hinge_joint_get_param(joint: RID, param: HingeJointParam) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _hinge_joint_set_flag(joint: RID, flag: HingeJointFlag, enabled: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _hinge_joint_set_param(joint: RID, param: HingeJointParam, value: float) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _init() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _is_flushing_queries() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _joint_clear(joint: RID) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _joint_create() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _joint_disable_collisions_between_bodies(joint: RID, disable: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _joint_get_solver_priority(joint: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

JointType _joint_get_type(joint: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _joint_is_disabled_collisions_between_bodies(joint: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _joint_make_cone_twist(joint: RID, body_A: RID, local_ref_A: Transform3D, body_B: RID, local_ref_B: Transform3D) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _joint_make_generic_6dof(joint: RID, body_A: RID, local_ref_A: Transform3D, body_B: RID, local_ref_B: Transform3D) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _joint_make_hinge(joint: RID, body_A: RID, hinge_A: Transform3D, body_B: RID, hinge_B: Transform3D) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _joint_make_hinge_simple(joint: RID, body_A: RID, pivot_A: Vector3, axis_A: Vector3, body_B: RID, pivot_B: Vector3, axis_B: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _joint_make_pin(joint: RID, body_A: RID, local_A: Vector3, body_B: RID, local_B: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _joint_make_slider(joint: RID, body_A: RID, local_ref_A: Transform3D, body_B: RID, local_ref_B: Transform3D) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _joint_set_solver_priority(joint: RID, priority: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _pin_joint_get_local_a(joint: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _pin_joint_get_local_b(joint: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _pin_joint_get_param(joint: RID, param: PinJointParam) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _pin_joint_set_local_a(joint: RID, local_A: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _pin_joint_set_local_b(joint: RID, local_B: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _pin_joint_set_param(joint: RID, param: PinJointParam, value: float) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _separation_ray_shape_create() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _set_active(active: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _shape_get_custom_solver_bias(shape: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Variant _shape_get_data(shape: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _shape_get_margin(shape: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

ShapeType _shape_get_type(shape: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _shape_set_custom_solver_bias(shape: RID, bias: float) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _shape_set_data(shape: RID, data: Variant) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _shape_set_margin(shape: RID, margin: float) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _slider_joint_get_param(joint: RID, param: SliderJointParam) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _slider_joint_set_param(joint: RID, param: SliderJointParam, value: float) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_add_collision_exception(body: RID, body_b: RID) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_apply_central_force(body: RID, force: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_apply_central_impulse(body: RID, impulse: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_apply_point_force(body: RID, point_index: int, force: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_apply_point_impulse(body: RID, point_index: int, impulse: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _soft_body_create() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

AABB _soft_body_get_bounds(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Array[RID] _soft_body_get_collision_exceptions(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _soft_body_get_collision_layer(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _soft_body_get_collision_mask(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _soft_body_get_damping_coefficient(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _soft_body_get_drag_coefficient(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _soft_body_get_linear_stiffness(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _soft_body_get_point_global_position(body: RID, point_index: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _soft_body_get_pressure_coefficient(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _soft_body_get_shrinking_factor(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _soft_body_get_simulation_precision(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _soft_body_get_space(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Variant _soft_body_get_state(body: RID, state: BodyState) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _soft_body_get_total_mass(body: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _soft_body_is_point_pinned(body: RID, point_index: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_move_point(body: RID, point_index: int, global_position: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_pin_point(body: RID, point_index: int, pin: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_remove_all_pinned_points(body: RID) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_remove_collision_exception(body: RID, body_b: RID) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_set_collision_layer(body: RID, layer: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_set_collision_mask(body: RID, mask: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_set_damping_coefficient(body: RID, damping_coefficient: float) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_set_drag_coefficient(body: RID, drag_coefficient: float) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_set_linear_stiffness(body: RID, linear_stiffness: float) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_set_mesh(body: RID, mesh: RID) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_set_pressure_coefficient(body: RID, pressure_coefficient: float) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_set_ray_pickable(body: RID, enable: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_set_shrinking_factor(body: RID, shrinking_factor: float) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_set_simulation_precision(body: RID, simulation_precision: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_set_space(body: RID, space: RID) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_set_state(body: RID, state: BodyState, variant: Variant) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_set_total_mass(body: RID, total_mass: float) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_set_transform(body: RID, transform: Transform3D) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _soft_body_update_rendering_server(body: RID, rendering_server_handler: PhysicsServer3DRenderingServerHandler) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _space_create() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _space_get_contact_count(space: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

PackedVector3Array _space_get_contacts(space: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

PhysicsDirectSpaceState3D _space_get_direct_state(space: RID) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _space_get_param(space: RID, param: SpaceParameter) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _space_is_active(space: RID) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _space_set_active(space: RID, active: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _space_set_debug_contacts(space: RID, max_contacts: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _space_set_param(space: RID, param: SpaceParameter, value: float) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _sphere_shape_create() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _step(step: float) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _sync() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _world_boundary_shape_create() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool body_test_motion_is_excluding_body(body: RID) const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool body_test_motion_is_excluding_object(object: int) const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!
