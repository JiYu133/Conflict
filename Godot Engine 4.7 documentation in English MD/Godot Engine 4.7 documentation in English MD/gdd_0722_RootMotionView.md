# RootMotionView

Inherits: VisualInstance3D < Node3D < Node < Object

Editor-only helper for setting up root motion in AnimationMixer.

## Description

Root motion refers to an animation technique where a mesh's skeleton is used to give impulse to a character. When working with 3D animations, a popular technique is for animators to use the root skeleton bone to give motion to the rest of the skeleton. This allows animating characters in a way where steps actually match the floor below. It also allows precise interaction with objects during cinematics. See also AnimationMixer.

Note: RootMotionView is only visible in the editor. It will be hidden automatically in the running project.

## Tutorials

- Using AnimationTree - Root motion

## Properties

NodePath | animation_path | NodePath("")
float | cell_size | 1.0
Color | color | Color(0.5, 0.5, 1, 1)
float | radius | 10.0
bool | zero_y | true

---

## Property Descriptions

NodePath animation_path = NodePath("") 

- void set_animation_path(value: NodePath)
- NodePath get_animation_path()

Path to an AnimationMixer node to use as a basis for root motion.

---

float cell_size = 1.0 

- void set_cell_size(value: float)
- float get_cell_size()

The grid's cell size in 3D units.

---

Color color = Color(0.5, 0.5, 1, 1) 

- void set_color(value: Color)
- Color get_color()

The grid's color.

---

float radius = 10.0 

- void set_radius(value: float)
- float get_radius()

The grid's radius in 3D units. The grid's opacity will fade gradually as the distance from the origin increases until this radius is reached.

---

bool zero_y = true 

- void set_zero_y(value: bool)
- bool get_zero_y()

If true, the grid's points will all be on the same Y coordinate (local Y = 0). If false, the points' original Y coordinate is preserved.
