# World3D

Inherits: Resource < RefCounted < Object

A resource that holds all components of a 3D world, such as a visual scenario and a physics space.

## Description

Class that has everything pertaining to a world: A physics space, a visual scenario, and a sound space. 3D nodes register their resources into the current 3D world.

## Tutorials

- Ray-casting

## Properties

CameraAttributes | camera_attributes
PhysicsDirectSpaceState3D | direct_space_state
Environment | environment
Environment | fallback_environment
RID | navigation_map
RID | scenario
RID | space

---

## Property Descriptions

CameraAttributes camera_attributes 

- void set_camera_attributes(value: CameraAttributes)
- CameraAttributes get_camera_attributes()

The default CameraAttributes resource to use if none set on the Camera3D.

---

PhysicsDirectSpaceState3D direct_space_state 

- PhysicsDirectSpaceState3D get_direct_space_state()

Direct access to the world's physics 3D space state. Used for querying current and potential collisions. When using multi-threaded physics, access is limited to Node._physics_process() in the main thread.

---

Environment environment 

- void set_environment(value: Environment)
- Environment get_environment()

The World3D's Environment.

---

Environment fallback_environment 

- void set_fallback_environment(value: Environment)
- Environment get_fallback_environment()

The World3D's fallback environment will be used if environment fails or is missing.

---

RID navigation_map 

- RID get_navigation_map()

The RID of this world's navigation map. Used by the NavigationServer3D.

---

RID scenario 

- RID get_scenario()

The World3D's visual scenario.

---

RID space 

- RID get_space()

The World3D's physics space.
