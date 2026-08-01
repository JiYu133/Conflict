# SubViewportContainer

Inherits: Container < Control < CanvasItem < Node < Object

A container used for displaying the contents of a SubViewport.

## Description

A container that displays the contents of underlying SubViewport child nodes. It uses the combined size of the SubViewports as minimum size, unless stretch is enabled.

Note: Changing a SubViewportContainer's Control.scale will cause its contents to appear distorted. To change its visual size without causing distortion, adjust the node's margins instead (if it's not already in a container).

Note: The SubViewportContainer forwards mouse-enter and mouse-exit notifications to its sub-viewports.

## Properties

FocusMode | focus_mode | 1 (overrides Control)
bool | mouse_target | false
bool | stretch | false
int | stretch_shrink | 1

## Methods

bool | _propagate_input_event(event: InputEvent) virtual const

---

## Property Descriptions

bool mouse_target = false 

- void set_mouse_target(value: bool)
- bool is_mouse_target_enabled()

Configure, if either the SubViewportContainer or alternatively the Control nodes of its SubViewport children should be available as targets of mouse-related functionalities, like identifying the drop target in drag-and-drop operations or cursor shape of hovered Control node.

If false, the Control nodes inside its SubViewport children are considered as targets.

If true, the SubViewportContainer itself will be considered as a target.

---

bool stretch = false 

- void set_stretch(value: bool)
- bool is_stretch_enabled()

If true, the sub-viewport will be automatically resized to the control's size.

Note: If true, this will prohibit changing SubViewport.size of its children manually.

---

int stretch_shrink = 1 

- void set_stretch_shrink(value: int)
- int get_stretch_shrink()

Divides the sub-viewport's effective resolution by this value while preserving its scale. This can be used to speed up rendering.

For example, a 1280×720 sub-viewport with stretch_shrink set to 2 will be rendered at 640×360 while occupying the same size in the container.

Note: stretch must be true for this property to work.

---

## Method Descriptions

bool _propagate_input_event(event: InputEvent) virtual const 

Experimental: This method may be changed or removed in future versions.

Virtual method to be implemented by the user. If it returns true, the event is propagated to SubViewport children. Propagation doesn't happen if it returns false. If the function is not implemented, all events are propagated to SubViewports.
