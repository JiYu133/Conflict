# VisualShaderNodeResizableBase

Inherits: VisualShaderNode < Resource < RefCounted < Object

Inherited By: VisualShaderNodeCurveTexture, VisualShaderNodeCurveXYZTexture, VisualShaderNodeFrame, VisualShaderNodeGroupBase

Base class for resizable nodes in a visual shader graph.

## Description

Resizable nodes have a handle that allows the user to adjust their size as needed.

## Properties

Vector2 | size | Vector2(0, 0)

---

## Property Descriptions

Vector2 size = Vector2(0, 0) 

- void set_size(value: Vector2)
- Vector2 get_size()

The size of the node in the visual shader graph.
