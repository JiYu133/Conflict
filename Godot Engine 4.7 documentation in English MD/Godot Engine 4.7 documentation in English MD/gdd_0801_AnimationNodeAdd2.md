# AnimationNodeAdd2

Inherits: AnimationNodeSync < AnimationNode < Resource < RefCounted < Object

Blends two animations additively inside of an AnimationNodeBlendTree.

## Description

A resource to add to an AnimationNodeBlendTree. Blends two animations additively based on the amount value.

If the amount is greater than 1.0, the animation connected to "in" port is blended with the amplified animation connected to "add" port.

If the amount is less than 0.0, the animation connected to "in" port is blended with the inverted animation connected to "add" port.

## Tutorials

- Using AnimationTree
