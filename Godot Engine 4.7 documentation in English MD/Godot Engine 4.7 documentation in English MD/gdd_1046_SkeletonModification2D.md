# SkeletonModification2D

Experimental: This class may be changed or removed in future versions.

Inherits: Resource < RefCounted < Object

Inherited By: SkeletonModification2DCCDIK, SkeletonModification2DFABRIK, SkeletonModification2DJiggle, SkeletonModification2DLookAt, SkeletonModification2DPhysicalBones, SkeletonModification2DStackHolder, SkeletonModification2DTwoBoneIK

Base class for resources that operate on Bone2Ds in a Skeleton2D.

## Description

This resource provides an interface that can be expanded so code that operates on Bone2D nodes in a Skeleton2D can be mixed and matched together to create complex interactions.

This is used to provide Godot with a flexible and powerful Inverse Kinematics solution that can be adapted for many different uses.

## Properties

bool | enabled | true
int | execution_mode | 0

## Methods

void | _draw_editor_gizmo() virtual
void | _execute(delta: float) virtual
void | _setup_modification(modification_stack: SkeletonModificationStack2D) virtual
float | clamp_angle(angle: float, min: float, max: float, invert: bool)
bool | get_editor_draw_gizmo() const
bool | get_is_setup() const
SkeletonModificationStack2D | get_modification_stack()
void | set_editor_draw_gizmo(draw_gizmo: bool)
void | set_is_setup(is_setup: bool)

---

## Property Descriptions

bool enabled = true 

- void set_enabled(value: bool)
- bool get_enabled()

If true, the modification's _execute() function will be called by the SkeletonModificationStack2D.

---

int execution_mode = 0 

- void set_execution_mode(value: int)
- int get_execution_mode()

The execution mode for the modification. This tells the modification stack when to execute the modification. Some modifications have settings that are only available in certain execution modes.

---

## Method Descriptions

void _draw_editor_gizmo() virtual 

Used for drawing editor-only modification gizmos. This function will only be called in the Godot editor and can be overridden to draw custom gizmos.

Note: You will need to use the Skeleton2D from SkeletonModificationStack2D.get_skeleton() and it's draw functions, as the SkeletonModification2D resource cannot draw on its own.

---

void _execute(delta: float) virtual 

Executes the given modification. This is where the modification performs whatever function it is designed to do.

---

void _setup_modification(modification_stack: SkeletonModificationStack2D) virtual 

Called when the modification is setup. This is where the modification performs initialization.

---

float clamp_angle(angle: float, min: float, max: float, invert: bool) 

Takes an angle and clamps it so it is within the passed-in min and max range. invert will inversely clamp the angle, clamping it to the range outside of the given bounds.

---

bool get_editor_draw_gizmo() const 

Returns whether this modification will call _draw_editor_gizmo() in the Godot editor to draw modification-specific gizmos.

---

bool get_is_setup() const 

Returns whether this modification has been successfully setup or not.

---

SkeletonModificationStack2D get_modification_stack() 

Returns the SkeletonModificationStack2D that this modification is bound to. Through the modification stack, you can access the Skeleton2D the modification is operating on.

---

void set_editor_draw_gizmo(draw_gizmo: bool) 

Sets whether this modification will call _draw_editor_gizmo() in the Godot editor to draw modification-specific gizmos.

---

void set_is_setup(is_setup: bool) 

Manually allows you to set the setup state of the modification. This function should only rarely be used, as the SkeletonModificationStack2D the modification is bound to should handle setting the modification up.
