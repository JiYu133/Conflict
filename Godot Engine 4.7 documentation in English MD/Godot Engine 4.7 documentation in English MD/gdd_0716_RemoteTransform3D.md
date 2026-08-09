# RemoteTransform3D

Inherits: Node3D < Node < Object

RemoteTransform3D pushes its own Transform3D to another Node3D derived Node in the scene.

## Description

RemoteTransform3D pushes its own Transform3D to another Node3D derived Node (called the remote node) in the scene.

It can be set to update another Node's position, rotation and/or scale. It can use either global or local coordinates.

## Properties

NodePath | remote_path | NodePath("")
bool | update_position | true
bool | update_rotation | true
bool | update_scale | true
bool | use_global_coordinates | true

## Methods

void | force_update_cache()

---

## Property Descriptions

NodePath remote_path = NodePath("") 

- void set_remote_node(value: NodePath)
- NodePath get_remote_node()

The NodePath to the remote node, relative to the RemoteTransform3D's position in the scene.

---

bool update_position = true 

- void set_update_position(value: bool)
- bool get_update_position()

If true, the remote node's position is updated.

---

bool update_rotation = true 

- void set_update_rotation(value: bool)
- bool get_update_rotation()

If true, the remote node's rotation is updated.

---

bool update_scale = true 

- void set_update_scale(value: bool)
- bool get_update_scale()

If true, the remote node's scale is updated.

---

bool use_global_coordinates = true 

- void set_use_global_coordinates(value: bool)
- bool get_use_global_coordinates()

If true, global coordinates are used. If false, local coordinates are used.

---

## Method Descriptions

void force_update_cache() 

RemoteTransform3D caches the remote node. It may not notice if the remote node disappears; force_update_cache() forces it to update the cache again.
