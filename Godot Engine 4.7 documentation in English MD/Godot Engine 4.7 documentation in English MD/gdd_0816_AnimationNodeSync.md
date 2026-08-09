# AnimationNodeSync

Inherits: AnimationNode < Resource < RefCounted < Object

Inherited By: AnimationNodeAdd2, AnimationNodeAdd3, AnimationNodeBlend2, AnimationNodeBlend3, AnimationNodeOneShot, AnimationNodeSub2, AnimationNodeTransition

Base class for AnimationNodes with multiple input ports that must be synchronized.

## Description

An animation node used to combine, mix, or blend two or more animations together while keeping them synchronized within an AnimationTree.

## Tutorials

- Using AnimationTree

## Properties

bool | sync | false

---

## Property Descriptions

bool sync = false 

- void set_use_sync(value: bool)
- bool is_using_sync()

If false, the blended animations' frame are stopped when the blend value is 0.

If true, forcing the blended animations to advance frame.
