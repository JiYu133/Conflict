# Path2D

Inherits: Node2D < CanvasItem < Node < Object

Contains a Curve2D path for PathFollow2D nodes to follow.

## Description

Can have PathFollow2D child nodes moving along the Curve2D. See PathFollow2D for more information on usage.

Note: The path is considered as relative to the moved nodes (children of PathFollow2D). As such, the curve should usually start with a zero vector ((0, 0)).

## Properties

Curve2D | curve

---

## Property Descriptions

Curve2D curve 

- void set_curve(value: Curve2D)
- Curve2D get_curve()

A Curve2D describing the path.
