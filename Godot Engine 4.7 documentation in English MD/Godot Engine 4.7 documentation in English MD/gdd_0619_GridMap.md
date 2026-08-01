# GridMap

Inherits: Node3D < Node < Object

Node for 3D tile-based maps.

## Description

GridMap lets you place meshes on a grid interactively. It works both from the editor and from scripts, which can help you create in-game level editors.

GridMaps use a MeshLibrary which contains a list of tiles. Each tile is a mesh with materials plus optional collision and navigation shapes.

A GridMap contains a collection of cells. Each grid cell refers to a tile in the MeshLibrary. All cells in the map have the same dimensions.

Internally, a GridMap is split into a sparse collection of octants for efficient rendering and physics processing. Every octant has the same dimensions and can contain several cells.

Note: GridMap doesn't extend VisualInstance3D and therefore can't be hidden or cull masked based on VisualInstance3D.layers. If you make a light not affect the first layer, the whole GridMap won't be lit by the light in question.

## Tutorials

- Using gridmaps
- 3D Platformer Demo [https://godotengine.org/asset-library/asset/2748]
- 3D Kinematic Character Demo [https://godotengine.org/asset-library/asset/2739]

## Properties

bool | bake_navigation | false
bool | cell_center_x | true
bool | cell_center_y | true
bool | cell_center_z | true
int | cell_octant_size | 8
float | cell_scale | 1.0
Vector3 | cell_size | Vector3(2, 2, 2)
int | collision_layer | 1
int | collision_mask | 1
float | collision_priority | 1.0
DebugVisibilityMode | collision_visibility_mode | 0
MeshLibrary | mesh_library |
PhysicsMaterial | physics_material |

## Methods

void | clear()
void | clear_baked_meshes()
RID | get_bake_mesh_instance(idx: int)
Array | get_bake_meshes()
Basis | get_basis_with_orthogonal_index(index: int) const
int | get_cell_item(position: Vector3i) const
Basis | get_cell_item_basis(position: Vector3i) const
int | get_cell_item_orientation(position: Vector3i) const
bool | get_collision_layer_value(layer_number: int) const
bool | get_collision_mask_value(layer_number: int) const
Array | get_meshes() const
RID | get_navigation_map() const
Vector3i | get_octant_coords_from_cell_coords(cell_coords: Vector3i) const
Array[Vector3i] | get_octants_in_bounds(bounds: AABB) const
int | get_orthogonal_index_from_basis(basis: Basis) const
Array[Vector3i] | get_used_cells() const
Array[Vector3i] | get_used_cells_by_item(item: int) const
Array[Vector3i] | get_used_cells_in_octant(octant_coords: Vector3i) const
Array[Vector3i] | get_used_cells_in_octant_by_item(octant_coords: Vector3i, item: int) const
Array[Vector3i] | get_used_octants() const
Array[Vector3i] | get_used_octants_by_item(item: int) const
Array[Vector3i] | get_used_octants_in_bounds(bounds: AABB) const
Vector3i | local_to_map(local_position: Vector3) const
void | make_baked_meshes(gen_lightmap_uv: bool = false, lightmap_uv_texel_size: float = 0.1)
Vector3 | map_to_local(map_position: Vector3i) const
void | resource_changed(resource: Resource)
void | set_cell_item(position: Vector3i, item: int, orientation: int = 0)
void | set_collision_layer_value(layer_number: int, value: bool)
void | set_collision_mask_value(layer_number: int, value: bool)
void | set_navigation_map(navigation_map: RID)

---

## Signals

cell_size_changed(cell_size: Vector3) 

Emitted when cell_size changes.

---

changed() 

Emitted when the MeshLibrary of this GridMap changes.

---

## Enumerations

enum DebugVisibilityMode
DebugVisibilityMode DEBUG_VISIBILITY_MODE_DEFAULT = 0

Hide the collisions debug shapes in the editor, and use the debug settings to determine their visibility in game (i.e. SceneTree.debug_collisions_hint or SceneTree.debug_navigation_hint).

DebugVisibilityMode DEBUG_VISIBILITY_MODE_FORCE_SHOW = 1

Always show the collisions debug shapes.

DebugVisibilityMode DEBUG_VISIBILITY_MODE_FORCE_HIDE = 2

Always hide the collisions debug shapes.

---

## Constants

INVALID_CELL_ITEM = -1 

Invalid cell item that can be used in set_cell_item() to clear cells (or represent an empty cell in get_cell_item()).

---

## Property Descriptions

bool bake_navigation = false 

- void set_bake_navigation(value: bool)
- bool is_baking_navigation()

If true, this GridMap creates a navigation region for each cell that uses a mesh_library item with a navigation mesh. The created navigation region will use the navigation layers bitmask assigned to the MeshLibrary's item.

---

bool cell_center_x = true 

- void set_center_x(value: bool)
- bool get_center_x()

If true, grid items are centered on the X axis.

---

bool cell_center_y = true 

- void set_center_y(value: bool)
- bool get_center_y()

If true, grid items are centered on the Y axis.

---

bool cell_center_z = true 

- void set_center_z(value: bool)
- bool get_center_z()

If true, grid items are centered on the Z axis.

---

int cell_octant_size = 8 

- void set_octant_size(value: int)
- int get_octant_size()

The size of each octant measured in number of cells. This applies to all three axis.

---

float cell_scale = 1.0 

- void set_cell_scale(value: float)
- float get_cell_scale()

The scale of the cell items.

This does not affect the size of the grid cells themselves, only the items in them. This can be used to make cell items overlap their neighbors.

---

Vector3 cell_size = Vector3(2, 2, 2) 

- void set_cell_size(value: Vector3)
- Vector3 get_cell_size()

The dimensions of the grid's cells.

This does not affect the size of the meshes. See cell_scale.

---

int collision_layer = 1 

- void set_collision_layer(value: int)
- int get_collision_layer()

The physics layers this GridMap is in.

GridMaps act as static bodies, meaning they aren't affected by gravity or other forces. They only affect other physics bodies that collide with them.

---

int collision_mask = 1 

- void set_collision_mask(value: int)
- int get_collision_mask()

The physics layers this GridMap detects collisions in. See Collision layers and masks in the documentation for more information.

---

float collision_priority = 1.0 

- void set_collision_priority(value: float)
- float get_collision_priority()

The priority used to solve colliding when occurring penetration. The higher the priority is, the lower the penetration into the object will be. This can for example be used to prevent the player from breaking through the boundaries of a level.

---

DebugVisibilityMode collision_visibility_mode = 0 

- void set_collision_visibility_mode(value: DebugVisibilityMode)
- DebugVisibilityMode get_collision_visibility_mode()

Show or hide the GridMap's collision shapes. If set to DEBUG_VISIBILITY_MODE_DEFAULT, this depends on the show collision debug settings.

---

MeshLibrary mesh_library 

- void set_mesh_library(value: MeshLibrary)
- MeshLibrary get_mesh_library()

The assigned MeshLibrary.

---

PhysicsMaterial physics_material 

- void set_physics_material(value: PhysicsMaterial)
- PhysicsMaterial get_physics_material()

Overrides the default friction and bounce physics properties for the whole GridMap.

---

## Method Descriptions

void clear() 

Clear all cells.

---

void clear_baked_meshes() 

Clears all baked meshes. See make_baked_meshes().

---

RID get_bake_mesh_instance(idx: int) 

Returns RID of a baked mesh with the given idx.

---

Array get_bake_meshes() 

Returns an array of ArrayMeshes and Transform3D references of all bake meshes that exist within the current GridMap. Even indices contain ArrayMeshes, while odd indices contain Transform3Ds that are always equal to Transform3D.IDENTITY.

This method relies on the output of make_baked_meshes(), which will be called with gen_lightmap_uv set to true and lightmap_uv_texel_size set to 0.1 if it hasn't been called yet.

---

Basis get_basis_with_orthogonal_index(index: int) const 

Returns one of 24 possible rotations that lie along the vectors (x,y,z) with each component being either -1, 0, or 1. For further details, refer to the Godot source code.

---

int get_cell_item(position: Vector3i) const 

The MeshLibrary item index located at the given grid coordinates. If the cell is empty, INVALID_CELL_ITEM will be returned.

---

Basis get_cell_item_basis(position: Vector3i) const 

Returns the basis that gives the specified cell its orientation.

---

int get_cell_item_orientation(position: Vector3i) const 

The orientation of the cell at the given grid coordinates. -1 is returned if the cell is empty.

---

bool get_collision_layer_value(layer_number: int) const 

Returns whether or not the specified layer of the collision_layer is enabled, given a layer_number between 1 and 32.

---

bool get_collision_mask_value(layer_number: int) const 

Returns whether or not the specified layer of the collision_mask is enabled, given a layer_number between 1 and 32.

---

Array get_meshes() const 

Returns an array of Transform3D and Mesh references corresponding to the non-empty cells in the grid. The transforms are specified in local space. Even indices contain Transform3Ds, while odd indices contain Meshes related to the Transform3D in the index preceding it.

---

RID get_navigation_map() const 

Returns the RID of the navigation map this GridMap node uses for its cell baked navigation meshes.

This function returns always the map set on the GridMap node and not the map on the NavigationServer. If the map is changed directly with the NavigationServer API the GridMap node will not be aware of the map change.

---

Vector3i get_octant_coords_from_cell_coords(cell_coords: Vector3i) const 

Returns the Vector3i octant coordinates of the octant that the cell at cell_coords belongs to.

---

Array[Vector3i] get_octants_in_bounds(bounds: AABB) const 

Returns an array of Vector3i octant coordinates that are inside the given bounds, including octants that have no cells in use.

---

int get_orthogonal_index_from_basis(basis: Basis) const 

This function considers a discretization of rotations into 24 points on unit sphere, lying along the vectors (x,y,z) with each component being either -1, 0, or 1, and returns the index (in the range from 0 to 23) of the point best representing the orientation of the object. For further details, refer to the Godot source code.

---

Array[Vector3i] get_used_cells() const 

Returns an array of Vector3 with the non-empty cell coordinates in the grid map.

---

Array[Vector3i] get_used_cells_by_item(item: int) const 

Returns an array of all cells with the given item index specified in item.

---

Array[Vector3i] get_used_cells_in_octant(octant_coords: Vector3i) const 

Returns an array of Vector3is with the cell coordinates of non-empty cells inside the octant at octant_coords.

---

Array[Vector3i] get_used_cells_in_octant_by_item(octant_coords: Vector3i, item: int) const 

Returns an array of Vector3is with the cell coordinates of cells inside the octant at octant_coords that use the specified cell item.

---

Array[Vector3i] get_used_octants() const 

Returns an array of Vector3is with the octant coordinates of the non-empty octants in the grid map.

---

Array[Vector3i] get_used_octants_by_item(item: int) const 

Returns an array of Vector3is with the octant coordinates of the octants that use the specified item in the grid map.

---

Array[Vector3i] get_used_octants_in_bounds(bounds: AABB) const 

Returns an array of Vector3is with the octant coordinates of non-empty octants that are inside the local bounds.

---

Vector3i local_to_map(local_position: Vector3) const 

Returns the map coordinates of the cell containing the given local_position. If local_position is in global coordinates, consider using Node3D.to_local() before passing it to this method. See also map_to_local().

---

void make_baked_meshes(gen_lightmap_uv: bool = false, lightmap_uv_texel_size: float = 0.1) 

Generates a baked mesh that represents all meshes in the assigned MeshLibrary for use with LightmapGI. If gen_lightmap_uv is true, UV2 data will be generated for each mesh currently used in the GridMap. Otherwise, only meshes that already have UV2 data present will be able to use baked lightmaps. When generating UV2, lightmap_uv_texel_size controls the texel density for lightmaps, with lower values resulting in more detailed lightmaps. lightmap_uv_texel_size is ignored if gen_lightmap_uv is false. See also get_bake_meshes(), which relies on the output of this method.

Note: Calling this method will not actually bake lightmaps, as lightmap baking is performed using the LightmapGI node.

---

Vector3 map_to_local(map_position: Vector3i) const 

Returns the position of a grid cell in the GridMap's local coordinate space. To convert the returned value into global coordinates, use Node3D.to_global(). See also local_to_map().

---

void resource_changed(resource: Resource) 

Deprecated: Use Resource.changed instead.

This method does nothing.

---

void set_cell_item(position: Vector3i, item: int, orientation: int = 0) 

Sets the mesh index for the cell referenced by its grid coordinates.

A negative item index such as INVALID_CELL_ITEM will clear the cell.

Optionally, the item's orientation can be passed. For valid orientation values, see get_orthogonal_index_from_basis().

---

void set_collision_layer_value(layer_number: int, value: bool) 

Based on value, enables or disables the specified layer in the collision_layer, given a layer_number between 1 and 32.

---

void set_collision_mask_value(layer_number: int, value: bool) 

Based on value, enables or disables the specified layer in the collision_mask, given a layer_number between 1 and 32.

---

void set_navigation_map(navigation_map: RID) 

Sets the RID of the navigation map this GridMap node should use for its cell baked navigation meshes.
