# TileSetAtlasSource

Inherits: TileSetSource < Resource < RefCounted < Object

Exposes a 2D atlas texture as a set of tiles for a TileSet resource.

## Description

An atlas is a grid of tiles laid out on a texture. Each tile in the grid must be exposed using create_tile(). Those tiles are then indexed using their coordinates in the grid.

Each tile can also have a size in the grid coordinates, making it more or less cells in the atlas.

Alternatives version of a tile can be created using create_alternative_tile(), which are then indexed using an alternative ID. The main tile (the one in the grid), is accessed with an alternative ID equal to 0.

Each tile alternate has a set of properties that is defined by the source's TileSet layers. Those properties are stored in a TileData object that can be accessed and modified using get_tile_data().

As TileData properties are stored directly in the TileSetAtlasSource resource, their properties might also be set using TileSetAtlasSource.set("://").

## Properties

Vector2i | margins | Vector2i(0, 0)
Vector2i | separation | Vector2i(0, 0)
Texture2D | texture |
Vector2i | texture_region_size | Vector2i(16, 16)
bool | use_texture_padding | true

## Methods

void | clear_tiles_outside_texture()
int | create_alternative_tile(atlas_coords: Vector2i, alternative_id_override: int = -1)
void | create_tile(atlas_coords: Vector2i, size: Vector2i = Vector2i(1, 1))
Vector2i | get_atlas_grid_size() const
int | get_next_alternative_tile_id(atlas_coords: Vector2i) const
Texture2D | get_runtime_texture() const
Rect2i | get_runtime_tile_texture_region(atlas_coords: Vector2i, frame: int) const
int | get_tile_animation_columns(atlas_coords: Vector2i) const
float | get_tile_animation_frame_duration(atlas_coords: Vector2i, frame_index: int) const
int | get_tile_animation_frames_count(atlas_coords: Vector2i) const
TileAnimationMode | get_tile_animation_mode(atlas_coords: Vector2i) const
Vector2i | get_tile_animation_separation(atlas_coords: Vector2i) const
float | get_tile_animation_speed(atlas_coords: Vector2i) const
float | get_tile_animation_total_duration(atlas_coords: Vector2i) const
Vector2i | get_tile_at_coords(atlas_coords: Vector2i) const
TileData | get_tile_data(atlas_coords: Vector2i, alternative_tile: int) const
Vector2i | get_tile_size_in_atlas(atlas_coords: Vector2i) const
Rect2i | get_tile_texture_region(atlas_coords: Vector2i, frame: int = 0) const
PackedVector2Array | get_tiles_to_be_removed_on_change(texture: Texture2D, margins: Vector2i, separation: Vector2i, texture_region_size: Vector2i)
bool | has_room_for_tile(atlas_coords: Vector2i, size: Vector2i, animation_columns: int, animation_separation: Vector2i, frames_count: int, ignored_tile: Vector2i = Vector2i(-1, -1)) const
bool | has_tiles_outside_texture() const
void | move_tile_in_atlas(atlas_coords: Vector2i, new_atlas_coords: Vector2i = Vector2i(-1, -1), new_size: Vector2i = Vector2i(-1, -1))
void | remove_alternative_tile(atlas_coords: Vector2i, alternative_tile: int)
void | remove_tile(atlas_coords: Vector2i)
void | set_alternative_tile_id(atlas_coords: Vector2i, alternative_tile: int, new_id: int)
void | set_tile_animation_columns(atlas_coords: Vector2i, frame_columns: int)
void | set_tile_animation_frame_duration(atlas_coords: Vector2i, frame_index: int, duration: float)
void | set_tile_animation_frames_count(atlas_coords: Vector2i, frames_count: int)
void | set_tile_animation_mode(atlas_coords: Vector2i, mode: TileAnimationMode)
void | set_tile_animation_separation(atlas_coords: Vector2i, separation: Vector2i)
void | set_tile_animation_speed(atlas_coords: Vector2i, speed: float)

---

## Enumerations

enum TileAnimationMode
TileAnimationMode TILE_ANIMATION_MODE_DEFAULT = 0

Tile animations start at same time, looking identical.

TileAnimationMode TILE_ANIMATION_MODE_RANDOM_START_TIMES = 1

Tile animations start at random times, looking varied.

TileAnimationMode TILE_ANIMATION_MODE_MAX = 2

Represents the size of the TileAnimationMode enum.

---

## Constants

TRANSFORM_FLIP_H = 4096 

Represents cell's horizontal flip flag. Should be used directly with TileMapLayer to flip placed tiles by altering their alternative IDs.

```gdscript
var alternate_id = $TileMapLayer.get_cell_alternative_tile(Vector2i(2, 2))
if not alternate_id & TileSetAtlasSource.TRANSFORM_FLIP_H:
    # If tile is not already flipped, flip it.
    $TileMapLayer.set_cell(Vector2i(2, 2), source_id, atlas_coords, alternate_id | TileSetAtlasSource.TRANSFORM_FLIP_H)
```

Note: These transformations can be combined to do the equivalent of 0, 90, 180, and 270 degree rotations, as shown below:

```gdscript
enum TileTransform {
    ROTATE_0 = 0,
    ROTATE_90 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H,
    ROTATE_180 = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V,
    ROTATE_270 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V,
}
```

TRANSFORM_FLIP_V = 8192 

Represents cell's vertical flip flag. See TRANSFORM_FLIP_H for usage.

TRANSFORM_TRANSPOSE = 16384 

Represents cell's transposed flag. See TRANSFORM_FLIP_H for usage.

---

## Property Descriptions

Vector2i margins = Vector2i(0, 0) 

- void set_margins(value: Vector2i)
- Vector2i get_margins()

Margins, in pixels, to offset the origin of the grid in the texture.

---

Vector2i separation = Vector2i(0, 0) 

- void set_separation(value: Vector2i)
- Vector2i get_separation()

Separation, in pixels, between each tile texture region of the grid.

---

Texture2D texture 

- void set_texture(value: Texture2D)
- Texture2D get_texture()

The atlas texture.

---

Vector2i texture_region_size = Vector2i(16, 16) 

- void set_texture_region_size(value: Vector2i)
- Vector2i get_texture_region_size()

The base tile size in the texture (in pixel). This size must be bigger than or equal to the TileSet's tile_size value.

---

bool use_texture_padding = true 

- void set_use_texture_padding(value: bool)
- bool get_use_texture_padding()

If true, generates an internal texture with an additional one pixel padding around each tile. Texture padding avoids a common artifact where lines appear between tiles.

Disabling this setting might lead a small performance improvement, as generating the internal texture requires both memory and processing time when the TileSetAtlasSource resource is modified.

---

## Method Descriptions

void clear_tiles_outside_texture() 

Removes all tiles that don't fit the available texture area. This method iterates over all the source's tiles, so it's advised to use has_tiles_outside_texture() beforehand.

---

int create_alternative_tile(atlas_coords: Vector2i, alternative_id_override: int = -1) 

Creates an alternative tile for the tile at coordinates atlas_coords. If alternative_id_override is -1, give it an automatically generated unique ID, or assigns it the given ID otherwise.

Returns the new alternative identifier, or -1 if the alternative could not be created with a provided alternative_id_override.

---

void create_tile(atlas_coords: Vector2i, size: Vector2i = Vector2i(1, 1)) 

Creates a new tile at coordinates atlas_coords with the given size.

---

Vector2i get_atlas_grid_size() const 

Returns the atlas grid size, which depends on how many tiles can fit in the texture. It thus depends on the texture's size, the atlas margins, and the tiles' texture_region_size.

---

int get_next_alternative_tile_id(atlas_coords: Vector2i) const 

Returns the alternative ID a following call to create_alternative_tile() would return.

---

Texture2D get_runtime_texture() const 

If use_texture_padding is false, returns texture. Otherwise, returns an internal ImageTexture created that includes the padding.

---

Rect2i get_runtime_tile_texture_region(atlas_coords: Vector2i, frame: int) const 

Returns the region of the tile at coordinates atlas_coords for the given frame inside the texture returned by get_runtime_texture().

Note: If use_texture_padding is false, returns the same as get_tile_texture_region().

---

int get_tile_animation_columns(atlas_coords: Vector2i) const 

Returns how many columns the tile at atlas_coords has in its animation layout.

---

float get_tile_animation_frame_duration(atlas_coords: Vector2i, frame_index: int) const 

Returns the animation frame duration of frame frame_index for the tile at coordinates atlas_coords.

---

int get_tile_animation_frames_count(atlas_coords: Vector2i) const 

Returns how many animation frames has the tile at coordinates atlas_coords.

---

TileAnimationMode get_tile_animation_mode(atlas_coords: Vector2i) const 

Returns the tile animation mode of the tile at atlas_coords. See also set_tile_animation_mode().

---

Vector2i get_tile_animation_separation(atlas_coords: Vector2i) const 

Returns the separation (as in the atlas grid) between each frame of an animated tile at coordinates atlas_coords.

---

float get_tile_animation_speed(atlas_coords: Vector2i) const 

Returns the animation speed of the tile at coordinates atlas_coords.

---

float get_tile_animation_total_duration(atlas_coords: Vector2i) const 

Returns the sum of the sum of the frame durations of the tile at coordinates atlas_coords. This value needs to be divided by the animation speed to get the actual animation loop duration.

---

Vector2i get_tile_at_coords(atlas_coords: Vector2i) const 

If there is a tile covering the atlas_coords coordinates, returns the top-left coordinates of the tile (thus its coordinate ID). Returns Vector2i(-1, -1) otherwise.

---

TileData get_tile_data(atlas_coords: Vector2i, alternative_tile: int) const 

Returns the TileData object for the given atlas coordinates and alternative ID.

---

Vector2i get_tile_size_in_atlas(atlas_coords: Vector2i) const 

Returns the size of the tile (in the grid coordinates system) at coordinates atlas_coords.

---

Rect2i get_tile_texture_region(atlas_coords: Vector2i, frame: int = 0) const 

Returns a tile's texture region in the atlas texture. For animated tiles, a frame argument might be provided for the different frames of the animation.

---

PackedVector2Array get_tiles_to_be_removed_on_change(texture: Texture2D, margins: Vector2i, separation: Vector2i, texture_region_size: Vector2i) 

Returns an array of tiles coordinates ID that will be automatically removed when modifying one or several of those properties: texture, margins, separation or texture_region_size. This can be used to undo changes that would have caused tiles data loss.

---

bool has_room_for_tile(atlas_coords: Vector2i, size: Vector2i, animation_columns: int, animation_separation: Vector2i, frames_count: int, ignored_tile: Vector2i = Vector2i(-1, -1)) const 

Returns whether there is enough room in an atlas to create/modify a tile with the given properties. If ignored_tile is provided, act as is the given tile was not present in the atlas. This may be used when you want to modify a tile's properties.

---

bool has_tiles_outside_texture() const 

Checks if the source has any tiles that don't fit the texture area (either partially or completely).

---

void move_tile_in_atlas(atlas_coords: Vector2i, new_atlas_coords: Vector2i = Vector2i(-1, -1), new_size: Vector2i = Vector2i(-1, -1)) 

Move the tile and its alternatives at the atlas_coords coordinates to the new_atlas_coords coordinates with the new_size size. This functions will fail if a tile is already present in the given area.

If new_atlas_coords is Vector2i(-1, -1), keeps the tile's coordinates. If new_size is Vector2i(-1, -1), keeps the tile's size.

To avoid an error, first check if a move is possible using has_room_for_tile().

---

void remove_alternative_tile(atlas_coords: Vector2i, alternative_tile: int) 

Remove a tile's alternative with alternative ID alternative_tile.

Calling this function with alternative_tile equals to 0 will fail, as the base tile alternative cannot be removed.

---

void remove_tile(atlas_coords: Vector2i) 

Remove a tile and its alternative at coordinates atlas_coords.

---

void set_alternative_tile_id(atlas_coords: Vector2i, alternative_tile: int, new_id: int) 

Change a tile's alternative ID from alternative_tile to new_id.

Calling this function with new_id of 0 will fail, as the base tile alternative cannot be moved.

---

void set_tile_animation_columns(atlas_coords: Vector2i, frame_columns: int) 

Sets the number of columns in the animation layout of the tile at coordinates atlas_coords. If set to 0, then the different frames of the animation are laid out as a single horizontal line in the atlas.

---

void set_tile_animation_frame_duration(atlas_coords: Vector2i, frame_index: int, duration: float) 

Sets the animation frame duration of frame frame_index for the tile at coordinates atlas_coords.

---

void set_tile_animation_frames_count(atlas_coords: Vector2i, frames_count: int) 

Sets how many animation frames the tile at coordinates atlas_coords has.

---

void set_tile_animation_mode(atlas_coords: Vector2i, mode: TileAnimationMode) 

Sets the tile animation mode of the tile at atlas_coords to mode. See also get_tile_animation_mode().

---

void set_tile_animation_separation(atlas_coords: Vector2i, separation: Vector2i) 

Sets the margin (in grid tiles) between each tile in the animation layout of the tile at coordinates atlas_coords has.

---

void set_tile_animation_speed(atlas_coords: Vector2i, speed: float) 

Sets the animation speed of the tile at coordinates atlas_coords has.
