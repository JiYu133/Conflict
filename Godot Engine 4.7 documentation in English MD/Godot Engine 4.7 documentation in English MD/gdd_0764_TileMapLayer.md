# TileMapLayer

Inherits: Node2D < CanvasItem < Node < Object

Node for 2D tile-based maps.

## Description

Node for 2D tile-based maps. A TileMapLayer uses a TileSet which contain a list of tiles which are used to create grid-based maps. Unlike the TileMap node, which is deprecated, TileMapLayer has only one layer of tiles. You can use several TileMapLayer to achieve the same result as a TileMap node.

For performance reasons, all TileMap updates are batched at the end of a frame. Notably, this means that scene tiles from a TileSetScenesCollectionSource are initialized after their parent. This is only queued when inside the scene tree.

To force an update earlier on, call update_internals().

Note: For performance and compatibility reasons, the coordinates serialized by TileMapLayer are limited to 16-bit signed integers, i.e. the range for X and Y coordinates is from -32768 to 32767. When saving tile data, tiles outside this range are wrapped.

## Tutorials

- Using Tilemaps
- 2D Platformer Demo [https://godotengine.org/asset-library/asset/2727]
- 2D Isometric Demo [https://godotengine.org/asset-library/asset/2718]
- 2D Hexagonal Demo [https://godotengine.org/asset-library/asset/2717]
- 2D Grid-based Navigation with AStarGrid2D Demo [https://godotengine.org/asset-library/asset/2723]
- 2D Role Playing Game (RPG) Demo [https://godotengine.org/asset-library/asset/2729]
- 2D Kinematic Character Demo [https://godotengine.org/asset-library/asset/2719]
- 2D Dynamic TileMap Layers Demo [https://godotengine.org/asset-library/asset/2713]

## Properties

bool | collision_enabled | true
DebugVisibilityMode | collision_visibility_mode | 0
bool | enabled | true
bool | navigation_enabled | true
DebugVisibilityMode | navigation_visibility_mode | 0
bool | occlusion_enabled | true
int | physics_quadrant_size | 16
int | rendering_quadrant_size | 16
PackedByteArray | tile_map_data | PackedByteArray()
TileSet | tile_set |
bool | use_kinematic_bodies | false
bool | x_draw_order_reversed | false
int | y_sort_origin | 0

## Methods

void | _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) virtual
void | _update_cells(coords: Array[Vector2i], forced_cleanup: bool) virtual
bool | _use_tile_data_runtime_update(coords: Vector2i) virtual
void | clear()
void | erase_cell(coords: Vector2i)
void | fix_invalid_tiles()
int | get_cell_alternative_tile(coords: Vector2i) const
Vector2i | get_cell_atlas_coords(coords: Vector2i) const
int | get_cell_source_id(coords: Vector2i) const
TileData | get_cell_tile_data(coords: Vector2i) const
Vector2i | get_coords_for_body_rid(body: RID) const
RID | get_navigation_map() const
Vector2i | get_neighbor_cell(coords: Vector2i, neighbor: CellNeighbor) const
TileMapPattern | get_pattern(coords_array: Array[Vector2i])
Array[Vector2i] | get_surrounding_cells(coords: Vector2i)
Array[Vector2i] | get_used_cells() const
Array[Vector2i] | get_used_cells_by_id(source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = -1) const
Rect2i | get_used_rect() const
bool | has_body_rid(body: RID) const
bool | is_cell_flipped_h(coords: Vector2i) const
bool | is_cell_flipped_v(coords: Vector2i) const
bool | is_cell_transposed(coords: Vector2i) const
Vector2i | local_to_map(local_position: Vector2) const
Vector2i | map_pattern(position_in_tilemap: Vector2i, coords_in_pattern: Vector2i, pattern: TileMapPattern)
Vector2 | map_to_local(map_position: Vector2i) const
void | notify_runtime_tile_data_update()
void | set_cell(coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = 0)
void | set_cells_terrain_connect(cells: Array[Vector2i], terrain_set: int, terrain: int, ignore_empty_terrains: bool = true)
void | set_cells_terrain_path(path: Array[Vector2i], terrain_set: int, terrain: int, ignore_empty_terrains: bool = true)
void | set_navigation_map(map: RID)
void | set_pattern(position: Vector2i, pattern: TileMapPattern)
void | update_internals()

---

## Signals

changed() 

Emitted when this TileMapLayer's properties changes. This includes modified cells, properties, or changes made to its assigned TileSet.

Note: This signal may be emitted very often when batch-modifying a TileMapLayer. Avoid executing complex processing in a connected function, and consider delaying it to the end of the frame instead (i.e. calling Object.call_deferred()).

---

## Enumerations

enum DebugVisibilityMode
DebugVisibilityMode DEBUG_VISIBILITY_MODE_DEFAULT = 0

Hide the collisions or navigation debug shapes in the editor, and use the debug settings to determine their visibility in game (i.e. SceneTree.debug_collisions_hint or SceneTree.debug_navigation_hint).

DebugVisibilityMode DEBUG_VISIBILITY_MODE_FORCE_HIDE = 2

Always hide the collisions or navigation debug shapes.

DebugVisibilityMode DEBUG_VISIBILITY_MODE_FORCE_SHOW = 1

Always show the collisions or navigation debug shapes.

---

## Property Descriptions

bool collision_enabled = true 

- void set_collision_enabled(value: bool)
- bool is_collision_enabled()

Enable or disable collisions.

---

DebugVisibilityMode collision_visibility_mode = 0 

- void set_collision_visibility_mode(value: DebugVisibilityMode)
- DebugVisibilityMode get_collision_visibility_mode()

Show or hide the TileMapLayer's collision shapes. If set to DEBUG_VISIBILITY_MODE_DEFAULT, this depends on the show collision debug settings.

---

bool enabled = true 

- void set_enabled(value: bool)
- bool is_enabled()

If false, disables this TileMapLayer completely (rendering, collision, navigation, scene tiles, etc.)

---

bool navigation_enabled = true 

- void set_navigation_enabled(value: bool)
- bool is_navigation_enabled()

If true, navigation regions are enabled.

---

DebugVisibilityMode navigation_visibility_mode = 0 

- void set_navigation_visibility_mode(value: DebugVisibilityMode)
- DebugVisibilityMode get_navigation_visibility_mode()

Show or hide the TileMapLayer's navigation meshes. If set to DEBUG_VISIBILITY_MODE_DEFAULT, this depends on the show navigation debug settings.

---

bool occlusion_enabled = true 

- void set_occlusion_enabled(value: bool)
- bool is_occlusion_enabled()

Enable or disable light occlusion.

---

int physics_quadrant_size = 16 

- void set_physics_quadrant_size(value: int)
- int get_physics_quadrant_size()

The TileMapLayer's physics quadrant size. Within a physics quadrant, cells with similar physics properties are grouped together and their collision shapes get merged. physics_quadrant_size defines the length of a square's side, in the map's coordinate system, that forms the quadrant. Thus, the default quadrant size groups together 16 * 16 = 256 tiles.

Note: As quadrants are created according to the map's coordinate system, the quadrant's "square shape" might not look like square in the TileMapLayer's local coordinate system.

Note: This impacts the value returned by get_coords_for_body_rid(). Higher values will make that function less precise. To get the exact cell coordinates, you need to set physics_quadrant_size to 1, which disables physics chunking.

---

int rendering_quadrant_size = 16 

- void set_rendering_quadrant_size(value: int)
- int get_rendering_quadrant_size()

The TileMapLayer's rendering quadrant size. A quadrant is a group of tiles to be drawn together on a single canvas item, for optimization purposes. rendering_quadrant_size defines the length of a square's side, in the map's coordinate system, that forms the quadrant. Thus, the default quadrant size groups together 16 * 16 = 256 tiles.

The quadrant size does not apply on a Y-sorted TileMapLayer, as tiles are grouped by Y position instead in that case.

Note: As quadrants are created according to the map's coordinate system, the quadrant's "square shape" might not look like square in the TileMapLayer's local coordinate system.

---

PackedByteArray tile_map_data = PackedByteArray() 

- void set_tile_map_data_from_array(value: PackedByteArray)
- PackedByteArray get_tile_map_data_as_array()

The raw tile map data as a byte array.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedByteArray for more details.

---

TileSet tile_set 

- void set_tile_set(value: TileSet)
- TileSet get_tile_set()

The TileSet used by this layer. The textures, collisions, and additional behavior of all available tiles are stored here.

---

bool use_kinematic_bodies = false 

- void set_use_kinematic_bodies(value: bool)
- bool is_using_kinematic_bodies()

If true, this TileMapLayer collision shapes will be instantiated as kinematic bodies. This can be needed for moving TileMapLayer nodes (i.e. moving platforms).

---

bool x_draw_order_reversed = false 

- void set_x_draw_order_reversed(value: bool)
- bool is_x_draw_order_reversed()

If CanvasItem.y_sort_enabled is enabled, setting this to true will reverse the order the tiles are drawn on the X-axis.

---

int y_sort_origin = 0 

- void set_y_sort_origin(value: int)
- int get_y_sort_origin()

This Y-sort origin value is added to each tile's Y-sort origin value. This allows, for example, to fake a different height level. This can be useful for top-down view games.

---

## Method Descriptions

void _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) virtual 

Called with a TileData object about to be used internally by the TileMapLayer, allowing its modification at runtime.

This method is only called if _use_tile_data_runtime_update() is implemented and returns true for the given tile coords.

Warning: The tile_data object's sub-resources are the same as the one in the TileSet. Modifying them might impact the whole TileSet. Instead, make sure to duplicate those resources.

Note: If the properties of tile_data object should change over time, use notify_runtime_tile_data_update() to notify the TileMapLayer it needs an update.

---

void _update_cells(coords: Array[Vector2i], forced_cleanup: bool) virtual 

Called when this TileMapLayer's cells need an internal update. This update may be caused from individual cells being modified or by a change in the tile_set (causing all cells to be queued for an update). The first call to this function is always for initializing all the TileMapLayer's cells. coords contains the coordinates of all modified cells, roughly in the order they were modified. forced_cleanup is true when the TileMapLayer's internals should be fully cleaned up. This is the case when:

- The layer is disabled;
- The layer is not visible;
- tile_set is set to null;
- The node is removed from the tree;
- The node is freed.

Note that any internal update happening while one of these conditions is verified is considered to be a "cleanup". See also update_internals().

Warning: Implementing this method may degrade the TileMapLayer's performance.

---

bool _use_tile_data_runtime_update(coords: Vector2i) virtual 

Should return true if the tile at coordinates coords requires a runtime update.

Warning: Make sure this function only returns true when needed. Any tile processed at runtime without a need for it will imply a significant performance penalty.

Note: If the result of this function should change, use notify_runtime_tile_data_update() to notify the TileMapLayer it needs an update.

---

void clear() 

Clears all cells.

---

void erase_cell(coords: Vector2i) 

Erases the cell at coordinates coords.

---

void fix_invalid_tiles() 

Clears cells containing tiles that do not exist in the tile_set.

---

int get_cell_alternative_tile(coords: Vector2i) const 

Returns the tile alternative ID of the cell at coordinates coords.

---

Vector2i get_cell_atlas_coords(coords: Vector2i) const 

Returns the tile atlas coordinates ID of the cell at coordinates coords. Returns Vector2i(-1, -1) if the cell does not exist.

---

int get_cell_source_id(coords: Vector2i) const 

Returns the tile source ID of the cell at coordinates coords. Returns -1 if the cell does not exist.

---

TileData get_cell_tile_data(coords: Vector2i) const 

Returns the TileData object associated with the given cell, or null if the cell does not exist or is not a TileSetAtlasSource.

```gdscript
func get_clicked_tile_power():
    var clicked_cell = tile_map_layer.local_to_map(tile_map_layer.get_local_mouse_position())
    var data = tile_map_layer.get_cell_tile_data(clicked_cell)
    if data:
        return data.get_custom_data("power")
    else:
        return 0
```

---

Vector2i get_coords_for_body_rid(body: RID) const 

Returns the coordinates of the physics quadrant (see physics_quadrant_size) for given physics body RID. Such an RID can be retrieved from KinematicCollision2D.get_collider_rid(), when colliding with a tile.

Note: Higher values of physics_quadrant_size will make this function less precise. To get the exact cell coordinates, you need to set physics_quadrant_size to 1, which disables physics chunking.

---

RID get_navigation_map() const 

Returns the RID of the NavigationServer2D navigation used by this TileMapLayer.

By default this returns the default World2D navigation map, unless a custom map was provided using set_navigation_map().

---

Vector2i get_neighbor_cell(coords: Vector2i, neighbor: CellNeighbor) const 

Returns the neighboring cell to the one at coordinates coords, identified by the neighbor direction. This method takes into account the different layouts a TileMap can take.

---

TileMapPattern get_pattern(coords_array: Array[Vector2i]) 

Creates and returns a new TileMapPattern from the given array of cells. See also set_pattern().

---

Array[Vector2i] get_surrounding_cells(coords: Vector2i) 

Returns the list of all neighboring cells to the one at coords. Any neighboring cell is one that is touching edges, so for a square cell 4 cells would be returned, for a hexagon 6 cells are returned.

---

Array[Vector2i] get_used_cells() const 

Returns a Vector2i array with the positions of all cells containing a tile. A cell is considered empty if its source identifier equals -1, its atlas coordinate identifier is Vector2(-1, -1) and its alternative identifier is -1.

---

Array[Vector2i] get_used_cells_by_id(source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = -1) const 

Returns a Vector2i array with the positions of all cells containing a tile. Tiles may be filtered according to their source (source_id), their atlas coordinates (atlas_coords), or alternative id (alternative_tile).

If a parameter has its value set to the default one, this parameter is not used to filter a cell. Thus, if all parameters have their respective default values, this method returns the same result as get_used_cells().

A cell is considered empty if its source identifier equals -1, its atlas coordinate identifier is Vector2(-1, -1) and its alternative identifier is -1.

---

Rect2i get_used_rect() const 

Returns a rectangle enclosing the used (non-empty) tiles of the map.

---

bool has_body_rid(body: RID) const 

Returns whether the provided body RID belongs to one of this TileMapLayer's cells.

---

bool is_cell_flipped_h(coords: Vector2i) const 

Returns true if the cell at coordinates coords is flipped horizontally. The result is valid only for atlas sources.

---

bool is_cell_flipped_v(coords: Vector2i) const 

Returns true if the cell at coordinates coords is flipped vertically. The result is valid only for atlas sources.

---

bool is_cell_transposed(coords: Vector2i) const 

Returns true if the cell at coordinates coords is transposed. The result is valid only for atlas sources.

---

Vector2i local_to_map(local_position: Vector2) const 

Returns the map coordinates of the cell containing the given local_position. If local_position is in global coordinates, consider using Node2D.to_local() before passing it to this method. See also map_to_local().

---

Vector2i map_pattern(position_in_tilemap: Vector2i, coords_in_pattern: Vector2i, pattern: TileMapPattern) 

Returns for the given coordinates coords_in_pattern in a TileMapPattern the corresponding cell coordinates if the pattern was pasted at the position_in_tilemap coordinates (see set_pattern()). This mapping is required as in half-offset tile shapes, the mapping might not work by calculating position_in_tile_map + coords_in_pattern.

---

Vector2 map_to_local(map_position: Vector2i) const 

Returns the centered position of a cell in the TileMapLayer's local coordinate space. To convert the returned value into global coordinates, use Node2D.to_global(). See also local_to_map().

Note: This may not correspond to the visual position of the tile, i.e. it ignores the TileData.texture_origin property of individual tiles.

---

void notify_runtime_tile_data_update() 

Notifies the TileMapLayer node that calls to _use_tile_data_runtime_update() or _tile_data_runtime_update() will lead to different results. This will thus trigger a TileMapLayer update.

Warning: Updating the TileMapLayer is computationally expensive and may impact performance. Try to limit the number of calls to this function to avoid unnecessary update.

Note: This does not trigger a direct update of the TileMapLayer, the update will be done at the end of the frame as usual (unless you call update_internals()).

---

void set_cell(coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = 0) 

Sets the tile identifiers for the cell at coordinates coords. Each tile of the TileSet is identified using three parts:

- The source identifier source_id identifies a TileSetSource identifier. See TileSet.set_source_id(),
- The atlas coordinate identifier atlas_coords identifies a tile coordinates in the atlas (if the source is a TileSetAtlasSource). For TileSetScenesCollectionSource it should always be Vector2i(0, 0),
- The alternative tile identifier alternative_tile identifies a tile alternative in the atlas (if the source is a TileSetAtlasSource), and the scene for a TileSetScenesCollectionSource.

If source_id is set to -1, atlas_coords to Vector2i(-1, -1), or alternative_tile to -1, the cell will be erased. An erased cell gets all its identifiers automatically set to their respective invalid values, namely -1, Vector2i(-1, -1) and -1.

---

void set_cells_terrain_connect(cells: Array[Vector2i], terrain_set: int, terrain: int, ignore_empty_terrains: bool = true) 

Update all the cells in the cells coordinates array so that they use the given terrain for the given terrain_set. If an updated cell has the same terrain as one of its neighboring cells, this function tries to join the two. This function might update neighboring tiles if needed to create correct terrain transitions.

If ignore_empty_terrains is true, empty terrains will be ignored when trying to find the best fitting tile for the given terrain constraints.

Note: To work correctly, this method requires the TileMapLayer's TileSet to have terrains set up with all required terrain combinations. Otherwise, it may produce unexpected results.

---

void set_cells_terrain_path(path: Array[Vector2i], terrain_set: int, terrain: int, ignore_empty_terrains: bool = true) 

Update all the cells in the path coordinates array so that they use the given terrain for the given terrain_set. The function will also connect two successive cell in the path with the same terrain. This function might update neighboring tiles if needed to create correct terrain transitions.

If ignore_empty_terrains is true, empty terrains will be ignored when trying to find the best fitting tile for the given terrain constraints.

Note: To work correctly, this method requires the TileMapLayer's TileSet to have terrains set up with all required terrain combinations. Otherwise, it may produce unexpected results.

---

void set_navigation_map(map: RID) 

Sets a custom map as a NavigationServer2D navigation map. If not set, uses the default World2D navigation map instead.

---

void set_pattern(position: Vector2i, pattern: TileMapPattern) 

Pastes the TileMapPattern at the given position in the tile map. See also get_pattern().

---

void update_internals() 

Triggers a direct update of the TileMapLayer. Usually, calling this function is not needed, as TileMapLayer node updates automatically when one of its properties or cells is modified.

However, for performance reasons, those updates are batched and delayed to the end of the frame. Calling this function will force the TileMapLayer to update right away instead.

Warning: Updating the TileMapLayer is computationally expensive and may impact performance. Try to limit the number of updates and how many tiles they impact.
