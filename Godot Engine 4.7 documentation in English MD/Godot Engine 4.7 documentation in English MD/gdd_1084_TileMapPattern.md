# TileMapPattern

Inherits: Resource < RefCounted < Object

Holds a pattern to be copied from or pasted into TileMaps.

## Description

This resource holds a set of cells to help bulk manipulations of TileMap.

A pattern always starts at the (0, 0) coordinates and cannot have cells with negative coordinates.

## Methods

int | get_cell_alternative_tile(coords: Vector2i) const
Vector2i | get_cell_atlas_coords(coords: Vector2i) const
int | get_cell_source_id(coords: Vector2i) const
Vector2i | get_size() const
Array[Vector2i] | get_used_cells() const
bool | has_cell(coords: Vector2i) const
bool | is_empty() const
void | remove_cell(coords: Vector2i, update_size: bool)
void | set_cell(coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = -1)
void | set_size(size: Vector2i)

---

## Method Descriptions

int get_cell_alternative_tile(coords: Vector2i) const 

Returns the tile alternative ID of the cell at coords.

---

Vector2i get_cell_atlas_coords(coords: Vector2i) const 

Returns the tile atlas coordinates ID of the cell at coords.

---

int get_cell_source_id(coords: Vector2i) const 

Returns the tile source ID of the cell at coords.

---

Vector2i get_size() const 

Returns the size, in cells, of the pattern.

---

Array[Vector2i] get_used_cells() const 

Returns the list of used cell coordinates in the pattern.

---

bool has_cell(coords: Vector2i) const 

Returns whether the pattern has a tile at the given coordinates.

---

bool is_empty() const 

Returns whether the pattern is empty or not.

---

void remove_cell(coords: Vector2i, update_size: bool) 

Remove the cell at the given coordinates.

---

void set_cell(coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = -1) 

Sets the tile identifiers for the cell at coordinates coords. See TileMap.set_cell().

---

void set_size(size: Vector2i) 

Sets the size of the pattern.
