# MeshLibrary

Inherits: Resource < RefCounted < Object

Library of meshes.

## Description

A library of meshes. Contains a list of Mesh resources, each with a name and ID. Each item can also include collision and navigation shapes. This resource is used in GridMap.

## Tutorials

- 3D Kinematic Character Demo [https://godotengine.org/asset-library/asset/2739]
- 3D Platformer Demo [https://godotengine.org/asset-library/asset/2748]

## Methods

void | clear()
void | create_item(id: int)
int | find_item_by_name(name: String) const
int | get_item_count() const
PackedInt32Array | get_item_list() const
Mesh | get_item_mesh(id: int) const
ShadowCastingSetting | get_item_mesh_cast_shadow(id: int) const
Transform3D | get_item_mesh_transform(id: int) const
String | get_item_name(id: int) const
int | get_item_navigation_layers(id: int) const
NavigationMesh | get_item_navigation_mesh(id: int) const
Transform3D | get_item_navigation_mesh_transform(id: int) const
Texture2D | get_item_preview(id: int) const
Array | get_item_shapes(id: int) const
int | get_last_unused_item_id() const
void | remove_item(id: int)
void | set_item_mesh(id: int, mesh: Mesh)
void | set_item_mesh_cast_shadow(id: int, shadow_casting_setting: ShadowCastingSetting)
void | set_item_mesh_transform(id: int, mesh_transform: Transform3D)
void | set_item_name(id: int, name: String)
void | set_item_navigation_layers(id: int, navigation_layers: int)
void | set_item_navigation_mesh(id: int, navigation_mesh: NavigationMesh)
void | set_item_navigation_mesh_transform(id: int, navigation_mesh: Transform3D)
void | set_item_preview(id: int, texture: Texture2D)
void | set_item_shapes(id: int, shapes: Array)

---

## Method Descriptions

void clear() 

Clears the library.

---

void create_item(id: int) 

Creates a new item in the library with the given ID.

You can get an unused ID from get_last_unused_item_id().

---

int find_item_by_name(name: String) const 

Returns the first item with the given name, or -1 if no item is found.

---

int get_item_count() const 

Returns the number of items present in the library.

---

PackedInt32Array get_item_list() const 

Returns the list of item IDs in use.

---

Mesh get_item_mesh(id: int) const 

Returns the item's mesh.

---

ShadowCastingSetting get_item_mesh_cast_shadow(id: int) const 

Returns the item's shadow casting mode.

---

Transform3D get_item_mesh_transform(id: int) const 

Returns the transform applied to the item's mesh.

---

String get_item_name(id: int) const 

Returns the item's name.

---

int get_item_navigation_layers(id: int) const 

Returns the item's navigation layers bitmask.

---

NavigationMesh get_item_navigation_mesh(id: int) const 

Returns the item's navigation mesh.

---

Transform3D get_item_navigation_mesh_transform(id: int) const 

Returns the transform applied to the item's navigation mesh.

---

Texture2D get_item_preview(id: int) const 

When running in the editor, returns a generated item preview (a 3D rendering in isometric perspective). When used in a running project, returns the manually-defined item preview which can be set using set_item_preview(). Returns an empty Texture2D if no preview was manually set in a running project.

---

Array get_item_shapes(id: int) const 

Returns an item's collision shapes.

The array consists of each Shape3D followed by its Transform3D.

---

int get_last_unused_item_id() const 

Gets an unused ID for a new item.

---

void remove_item(id: int) 

Removes the item.

---

void set_item_mesh(id: int, mesh: Mesh) 

Sets the item's mesh.

---

void set_item_mesh_cast_shadow(id: int, shadow_casting_setting: ShadowCastingSetting) 

Sets the item's shadow casting mode to shadow_casting_setting.

---

void set_item_mesh_transform(id: int, mesh_transform: Transform3D) 

Sets the transform to apply to the item's mesh.

---

void set_item_name(id: int, name: String) 

Sets the item's name.

This name is shown in the editor. It can also be used to look up the item later using find_item_by_name().

---

void set_item_navigation_layers(id: int, navigation_layers: int) 

Sets the item's navigation layers bitmask.

---

void set_item_navigation_mesh(id: int, navigation_mesh: NavigationMesh) 

Sets the item's navigation mesh.

---

void set_item_navigation_mesh_transform(id: int, navigation_mesh: Transform3D) 

Sets the transform to apply to the item's navigation mesh.

---

void set_item_preview(id: int, texture: Texture2D) 

Sets a texture to use as the item's preview icon in the editor.

---

void set_item_shapes(id: int, shapes: Array) 

Sets an item's collision shapes.

The array should consist of Shape3D objects, each followed by a Transform3D that will be applied to it. For shapes that should not have a transform, use Transform3D.IDENTITY.
