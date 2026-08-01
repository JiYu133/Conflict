# BoxContainer

Inherits: Container < Control < CanvasItem < Node < Object

Inherited By: HBoxContainer, VBoxContainer

A container that arranges its child controls horizontally or vertically.

## Description

A container that arranges its child controls horizontally or vertically, rearranging them automatically when their minimum size changes.

## Tutorials

- Using Containers

## Properties

AlignmentMode | alignment | 0
bool | vertical | false

## Methods

Control | add_spacer(begin: bool)

## Theme Properties

int | separation | 4

---

## Enumerations

enum AlignmentMode
AlignmentMode ALIGNMENT_BEGIN = 0

The child controls will be arranged at the beginning of the container, i.e. top if orientation is vertical, left if orientation is horizontal (right for RTL layout).

AlignmentMode ALIGNMENT_CENTER = 1

The child controls will be centered in the container.

AlignmentMode ALIGNMENT_END = 2

The child controls will be arranged at the end of the container, i.e. bottom if orientation is vertical, right if orientation is horizontal (left for RTL layout).

---

## Property Descriptions

AlignmentMode alignment = 0 

- void set_alignment(value: AlignmentMode)
- AlignmentMode get_alignment()

The alignment of the container's children (must be one of ALIGNMENT_BEGIN, ALIGNMENT_CENTER, or ALIGNMENT_END).

---

bool vertical = false 

- void set_vertical(value: bool)
- bool is_vertical()

If true, the BoxContainer will arrange its children vertically, rather than horizontally.

Can't be changed when using HBoxContainer and VBoxContainer.

---

## Method Descriptions

Control add_spacer(begin: bool) 

Adds a Control node to the box as a spacer. If begin is true, it will insert the Control node in front of all other children.

---

## Theme Property Descriptions

int separation = 4 

The space between the BoxContainer's elements, in pixels.
