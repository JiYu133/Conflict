# VisibleOnScreenEnabler2D

Inherits: VisibleOnScreenNotifier2D < Node2D < CanvasItem < Node < Object

A rectangular region of 2D space that, when visible on screen, enables a target node.

## Description

VisibleOnScreenEnabler2D contains a rectangular region of 2D space and a target node. The target node will be automatically enabled (via its Node.process_mode property) when any part of this region becomes visible on the screen, and automatically disabled otherwise. This can for example be used to activate enemies only when the player approaches them.

See VisibleOnScreenNotifier2D if you only want to be notified when the region is visible on screen.

Note: VisibleOnScreenEnabler2D uses the render culling code to determine whether it's visible on screen, so it won't function unless CanvasItem.visible is set to true.

## Properties

EnableMode | enable_mode | 0
NodePath | enable_node_path | NodePath("..")

---

## Enumerations

enum EnableMode
EnableMode ENABLE_MODE_INHERIT = 0

Corresponds to Node.PROCESS_MODE_INHERIT.

EnableMode ENABLE_MODE_ALWAYS = 1

Corresponds to Node.PROCESS_MODE_ALWAYS.

EnableMode ENABLE_MODE_WHEN_PAUSED = 2

Corresponds to Node.PROCESS_MODE_WHEN_PAUSED.

---

## Property Descriptions

EnableMode enable_mode = 0 

- void set_enable_mode(value: EnableMode)
- EnableMode get_enable_mode()

Determines how the target node is enabled. Corresponds to ProcessMode. When the node is disabled, it always uses Node.PROCESS_MODE_DISABLED.

---

NodePath enable_node_path = NodePath("..") 

- void set_enable_node_path(value: NodePath)
- NodePath get_enable_node_path()

The path to the target node, relative to the VisibleOnScreenEnabler2D. The target node is cached; it's only assigned when setting this property (if the VisibleOnScreenEnabler2D is inside the scene tree) and every time the VisibleOnScreenEnabler2D enters the scene tree. If the path is empty, no node will be affected. If the path is invalid, an error is also generated.
