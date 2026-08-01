# TileData

Inherits: Object

Settings for a single tile in a TileSet.

## Description

TileData object represents a single tile in a TileSet. It is usually edited using the tileset editor, but it can be modified at runtime using TileMapLayer._tile_data_runtime_update().

## Properties

bool | flip_h | false
bool | flip_v | false
Material | material |
Color | modulate | Color(1, 1, 1, 1)
float | probability | 1.0
int | terrain | -1
int | terrain_set | -1
Vector2i | texture_origin | Vector2i(0, 0)
bool | transpose | false
int | y_sort_origin | 0
int | z_index | 0

## Methods

void | add_collision_polygon(layer_id: int)
void | add_occluder_polygon(layer_id: int)
float | get_collision_polygon_one_way_margin(layer_id: int, polygon_index: int) const
PackedVector2Array | get_collision_polygon_points(layer_id: int, polygon_index: int) const
int | get_collision_polygons_count(layer_id: int) const
float | get_constant_angular_velocity(layer_id: int) const
Vector2 | get_constant_linear_velocity(layer_id: int) const
Variant | get_custom_data(layer_name: String) const
Variant | get_custom_data_by_layer_id(layer_id: int) const
NavigationPolygon | get_navigation_polygon(layer_id: int, flip_h: bool = false, flip_v: bool = false, transpose: bool = false) const
OccluderPolygon2D | get_occluder(layer_id: int, flip_h: bool = false, flip_v: bool = false, transpose: bool = false) const
OccluderPolygon2D | get_occluder_polygon(layer_id: int, polygon_index: int, flip_h: bool = false, flip_v: bool = false, transpose: bool = false) const
int | get_occluder_polygons_count(layer_id: int) const
int | get_terrain_peering_bit(peering_bit: CellNeighbor) const
bool | has_custom_data(layer_name: String) const
bool | is_collision_polygon_one_way(layer_id: int, polygon_index: int) const
bool | is_valid_terrain_peering_bit(peering_bit: CellNeighbor) const
void | remove_collision_polygon(layer_id: int, polygon_index: int)
void | remove_occluder_polygon(layer_id: int, polygon_index: int)
void | set_collision_polygon_one_way(layer_id: int, polygon_index: int, one_way: bool)
void | set_collision_polygon_one_way_margin(layer_id: int, polygon_index: int, one_way_margin: float)
void | set_collision_polygon_points(layer_id: int, polygon_index: int, polygon: PackedVector2Array)
void | set_collision_polygons_count(layer_id: int, polygons_count: int)
void | set_constant_angular_velocity(layer_id: int, velocity: float)
void | set_constant_linear_velocity(layer_id: int, velocity: Vector2)
void | set_custom_data(layer_name: String, value: Variant)
void | set_custom_data_by_layer_id(layer_id: int, value: Variant)
void | set_navigation_polygon(layer_id: int, navigation_polygon: NavigationPolygon)
void | set_occluder(layer_id: int, occluder_polygon: OccluderPolygon2D)
void | set_occluder_polygon(layer_id: int, polygon_index: int, polygon: OccluderPolygon2D)
void | set_occluder_polygons_count(layer_id: int, polygons_count: int)
void | set_terrain_peering_bit(peering_bit: CellNeighbor, terrain: int)

---

## Signals

changed() 

Emitted when any of the properties are changed.

---

## Property Descriptions

bool flip_h = false 

- void set_flip_h(value: bool)
- bool get_flip_h()

If true, the tile will have its texture flipped horizontally.

---

bool flip_v = false 

- void set_flip_v(value: bool)
- bool get_flip_v()

If true, the tile will have its texture flipped vertically.

---

Material material 

- void set_material(value: Material)
- Material get_material()

The Material to use for this TileData. This can be a CanvasItemMaterial to use the default shader, or a ShaderMaterial to use a custom shader.

---

Color modulate = Color(1, 1, 1, 1) 

- void set_modulate(value: Color)
- Color get_modulate()

Color modulation of the tile.

---

float probability = 1.0 

- void set_probability(value: float)
- float get_probability()

Relative probability of this tile being selected when drawing a pattern of random tiles.

---

int terrain = -1 

- void set_terrain(value: int)
- int get_terrain()

ID of the terrain from the terrain set that the tile uses.

---

int terrain_set = -1 

- void set_terrain_set(value: int)
- int get_terrain_set()

ID of the terrain set that the tile uses.

---

Vector2i texture_origin = Vector2i(0, 0) 

- void set_texture_origin(value: Vector2i)
- Vector2i get_texture_origin()

Offsets the position of where the tile is drawn.

---

bool transpose = false 

- void set_transpose(value: bool)
- bool get_transpose()

If true, the tile will display transposed, i.e. with horizontal and vertical texture UVs swapped.

---

int y_sort_origin = 0 

- void set_y_sort_origin(value: int)
- int get_y_sort_origin()

Vertical point of the tile used for determining y-sorted order.

---

int z_index = 0 

- void set_z_index(value: int)
- int get_z_index()

Ordering index of this tile, relative to TileMapLayer.

---

## Method Descriptions

void add_collision_polygon(layer_id: int) 

Adds a collision polygon to the tile on the given TileSet physics layer.

---

void add_occluder_polygon(layer_id: int) 

Adds an occlusion polygon to the tile on the TileSet occlusion layer with index layer_id.

---

float get_collision_polygon_one_way_margin(layer_id: int, polygon_index: int) const 

Returns the one-way margin (for one-way platforms) of the polygon at index polygon_index for TileSet physics layer with index layer_id.

---

PackedVector2Array get_collision_polygon_points(layer_id: int, polygon_index: int) const 

Returns the points of the polygon at index polygon_index for TileSet physics layer with index layer_id.

---

int get_collision_polygons_count(layer_id: int) const 

Returns how many polygons the tile has for TileSet physics layer with index layer_id.

---

float get_constant_angular_velocity(layer_id: int) const 

Returns the constant angular velocity applied to objects colliding with this tile.

---

Vector2 get_constant_linear_velocity(layer_id: int) const 

Returns the constant linear velocity applied to objects colliding with this tile.

---

Variant get_custom_data(layer_name: String) const 

Returns the custom data value for custom data layer named layer_name. To check if a custom data layer exists, use has_custom_data().

---

Variant get_custom_data_by_layer_id(layer_id: int) const 

Returns the custom data value for custom data layer with index layer_id.

---

NavigationPolygon get_navigation_polygon(layer_id: int, flip_h: bool = false, flip_v: bool = false, transpose: bool = false) const 

Returns the navigation polygon of the tile for the TileSet navigation layer with index layer_id.

flip_h, flip_v, and transpose allow transforming the returned polygon.

---

OccluderPolygon2D get_occluder(layer_id: int, flip_h: bool = false, flip_v: bool = false, transpose: bool = false) const 

Deprecated: Use get_occluder_polygon() instead.

Returns the occluder polygon of the tile for the TileSet occlusion layer with index layer_id.

flip_h, flip_v, and transpose allow transforming the returned polygon.

---

OccluderPolygon2D get_occluder_polygon(layer_id: int, polygon_index: int, flip_h: bool = false, flip_v: bool = false, transpose: bool = false) const 

Returns the occluder polygon at index polygon_index from the TileSet occlusion layer with index layer_id.

The flip_h, flip_v, and transpose parameters can be true to transform the returned polygon.

---

int get_occluder_polygons_count(layer_id: int) const 

Returns the number of occluder polygons of the tile in the TileSet occlusion layer with index layer_id.

---

int get_terrain_peering_bit(peering_bit: CellNeighbor) const 

Returns the tile's terrain bit for the given peering_bit direction. To check that a direction is valid, use is_valid_terrain_peering_bit().

---

bool has_custom_data(layer_name: String) const 

Returns whether there exists a custom data layer named layer_name.

---

bool is_collision_polygon_one_way(layer_id: int, polygon_index: int) const 

Returns whether one-way collisions are enabled for the polygon at index polygon_index for TileSet physics layer with index layer_id.

---

bool is_valid_terrain_peering_bit(peering_bit: CellNeighbor) const 

Returns whether the given peering_bit direction is valid for this tile.

---

void remove_collision_polygon(layer_id: int, polygon_index: int) 

Removes the polygon at index polygon_index for TileSet physics layer with index layer_id.

---

void remove_occluder_polygon(layer_id: int, polygon_index: int) 

Removes the polygon at index polygon_index for TileSet occlusion layer with index layer_id.

---

void set_collision_polygon_one_way(layer_id: int, polygon_index: int, one_way: bool) 

Enables/disables one-way collisions on the polygon at index polygon_index for TileSet physics layer with index layer_id.

---

void set_collision_polygon_one_way_margin(layer_id: int, polygon_index: int, one_way_margin: float) 

Sets the one-way margin (for one-way platforms) of the polygon at index polygon_index for TileSet physics layer with index layer_id.

---

void set_collision_polygon_points(layer_id: int, polygon_index: int, polygon: PackedVector2Array) 

Sets the points of the polygon at index polygon_index for TileSet physics layer with index layer_id.

---

void set_collision_polygons_count(layer_id: int, polygons_count: int) 

Sets the polygons count for TileSet physics layer with index layer_id.

---

void set_constant_angular_velocity(layer_id: int, velocity: float) 

Sets the constant angular velocity. This does not rotate the tile. This angular velocity is applied to objects colliding with this tile.

---

void set_constant_linear_velocity(layer_id: int, velocity: Vector2) 

Sets the constant linear velocity. This does not move the tile. This linear velocity is applied to objects colliding with this tile. This is useful to create conveyor belts.

---

void set_custom_data(layer_name: String, value: Variant) 

Sets the tile's custom data value for the TileSet custom data layer with name layer_name.

---

void set_custom_data_by_layer_id(layer_id: int, value: Variant) 

Sets the tile's custom data value for the TileSet custom data layer with index layer_id.

---

void set_navigation_polygon(layer_id: int, navigation_polygon: NavigationPolygon) 

Sets the navigation polygon for the TileSet navigation layer with index layer_id.

---

void set_occluder(layer_id: int, occluder_polygon: OccluderPolygon2D) 

Deprecated: Use set_occluder_polygon() instead.

Sets the occluder for the TileSet occlusion layer with index layer_id.

---

void set_occluder_polygon(layer_id: int, polygon_index: int, polygon: OccluderPolygon2D) 

Sets the occluder for polygon with index polygon_index in the TileSet occlusion layer with index layer_id.

---

void set_occluder_polygons_count(layer_id: int, polygons_count: int) 

Sets the occluder polygon count in the TileSet occlusion layer with index layer_id.

---

void set_terrain_peering_bit(peering_bit: CellNeighbor, terrain: int) 

Sets the tile's terrain bit for the given peering_bit direction. To check that a direction is valid, use is_valid_terrain_peering_bit().
