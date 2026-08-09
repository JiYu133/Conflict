# Container

Inherits: Control < CanvasItem < Node < Object

Inherited By: AspectRatioContainer, BoxContainer, CenterContainer, EditorProperty, FlowContainer, FoldableContainer, GraphElement, GridContainer, MarginContainer, PanelContainer, ScrollContainer, SplitContainer, SubViewportContainer, TabContainer

Base class for all GUI containers.

## Description

Base class for all GUI containers. A Container automatically arranges its child controls in a certain way. This class can be inherited to make custom container types.

## Tutorials

- Using Containers

## Properties

bool | accessibility_region | false
MouseFilter | mouse_filter | 1 (overrides Control)
bool | propagate_maximum_size | true (overrides Control)

## Methods

PackedInt32Array | _get_allowed_size_flags_horizontal() virtual const
PackedInt32Array | _get_allowed_size_flags_vertical() virtual const
void | fit_child_in_rect(child: Control, rect: Rect2)
void | queue_sort()

---

## Signals

pre_sort_children() 

Emitted when children are going to be sorted.

---

sort_children() 

Emitted when sorting the children is needed.

---

## Constants

NOTIFICATION_PRE_SORT_CHILDREN = 50 

Notification just before children are going to be sorted, in case there's something to process beforehand.

NOTIFICATION_SORT_CHILDREN = 51 

Notification for when sorting the children, it must be obeyed immediately.

---

## Property Descriptions

bool accessibility_region = false 

- void set_accessibility_region(value: bool)
- bool is_accessibility_region()

If true, this container is marked as a region for accessibility. Use Control.accessibility_name to give the region a descriptive name. Screen readers can navigate between regions using landmark navigation.

---

## Method Descriptions

PackedInt32Array _get_allowed_size_flags_horizontal() virtual const 

Implement to return a list of allowed horizontal SizeFlags for child nodes. This doesn't technically prevent the usages of any other size flags, if your implementation requires that. This only limits the options available to the user in the Inspector dock.

Note: Having no size flags is equal to having Control.SIZE_SHRINK_BEGIN. As such, this value is always implicitly allowed.

---

PackedInt32Array _get_allowed_size_flags_vertical() virtual const 

Implement to return a list of allowed vertical SizeFlags for child nodes. This doesn't technically prevent the usages of any other size flags, if your implementation requires that. This only limits the options available to the user in the Inspector dock.

Note: Having no size flags is equal to having Control.SIZE_SHRINK_BEGIN. As such, this value is always implicitly allowed.

---

void fit_child_in_rect(child: Control, rect: Rect2) 

Fit a child control in a given rect. This is mainly a helper for creating custom container classes.

---

void queue_sort() 

Queue resort of the contained children. This is called automatically anyway, but can be called upon request.
