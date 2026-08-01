# Marker2D

Inherits: Node2D < CanvasItem < Node < Object

Generic 2D position hint for editing.

## Description

Generic 2D position hint for editing. It's just like a plain Node2D, but it displays as a cross in the 2D editor at all times. You can set the cross' visual size by using the gizmo in the 2D editor while the node is selected.

## Properties

float | gizmo_extents | 10.0

---

## Property Descriptions

float gizmo_extents = 10.0 

- void set_gizmo_extents(value: float)
- float get_gizmo_extents()

Size of the gizmo cross that appears in the editor.
