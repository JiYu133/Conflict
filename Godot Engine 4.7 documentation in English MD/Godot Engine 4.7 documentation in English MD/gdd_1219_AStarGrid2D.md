# AStarGrid2D

Inherits: RefCounted < Object

An implementation of A* for finding the shortest path between two points on a partial 2D grid.

## Description

AStarGrid2D is a variant of AStar2D that is specialized for partial 2D grids. It is simpler to use because it doesn't require you to manually create points and connect them together. This class also supports multiple types of heuristics, modes for diagonal movement, and a jumping mode to speed up calculations.

To use AStarGrid2D, you only need to set the region of the grid, optionally set the cell_size, and then call the update() method:

```
var astar_grid = AStarGrid2D.new()
astar_grid.region = Rect2i(0, 0, 32, 32)
astar_grid.cell_size = Vector2(16, 16)
astar_grid.update()
print(astar_grid.get_id_path(Vector2i(0, 0), Vector2i(3, 4))) # Prints [(0, 0), (1, 1), (2, 2), (3, 3), (3, 4)]
print(astar_grid.get_point_path(Vector2i(0, 0), Vector2i(3, 4))) # Prints [(0, 0), (16, 16), (32, 32), (48, 48), (48, 64)]
```

```
AStarGrid2D astarGrid = new AStarGrid2D();
astarGrid.Region = new Rect2I(0, 0, 32, 32);
astarGrid.CellSize = new Vector2I(16, 16);
astarGrid.Update();
GD.Print(astarGrid.GetIdPath(Vector2I.Zero, new Vector2I(3, 4))); // Prints [(0, 0), (1, 1), (2, 2), (3, 3), (3, 4)]
GD.Print(astarGrid.GetPointPath(Vector2I.Zero, new Vector2I(3, 4))); // Prints [(0, 0), (16, 16), (32, 32), (48, 48), (48, 64)]
```

To remove a point from the pathfinding grid, it must be set as "solid" with set_point_solid().

## Tutorials

- Grid-based Navigation with AStarGrid2D Demo [https://godotengine.org/asset-library/asset/2723]

## Properties

CellShape | cell_shape | 0
Vector2 | cell_size | Vector2(1, 1)
Heuristic | default_compute_heuristic | 0
Heuristic | default_estimate_heuristic | 0
DiagonalMode | diagonal_mode | 0
bool | jumping_enabled | false
Vector2 | offset | Vector2(0, 0)
Rect2i | region | Rect2i(0, 0, 0, 0)
Vector2i | size | Vector2i(0, 0)

## Methods

float | _compute_cost(from_id: Vector2i, to_id: Vector2i) virtual const
float | _estimate_cost(from_id: Vector2i, end_id: Vector2i) virtual const
void | clear()
void | fill_solid_region(region: Rect2i, solid: bool = true)
void | fill_weight_scale_region(region: Rect2i, weight_scale: float)
Array[Vector2i] | get_id_path(from_id: Vector2i, to_id: Vector2i, allow_partial_path: bool = false)
Array[Dictionary] | get_point_data_in_region(region: Rect2i) const
PackedVector2Array | get_point_path(from_id: Vector2i, to_id: Vector2i, allow_partial_path: bool = false)
Vector2 | get_point_position(id: Vector2i) const
float | get_point_weight_scale(id: Vector2i) const
bool | is_dirty() const
bool | is_in_bounds(x: int, y: int) const
bool | is_in_boundsv(id: Vector2i) const
bool | is_point_solid(id: Vector2i) const
void | set_point_solid(id: Vector2i, solid: bool = true)
void | set_point_weight_scale(id: Vector2i, weight_scale: float)
void | update()

---

## Enumerations

enum Heuristic
Heuristic HEURISTIC_EUCLIDEAN = 0

The Euclidean heuristic [https://en.wikipedia.org/wiki/Euclidean_distance] to be used for the pathfinding using the following formula:

```gdscript
dx = abs(to_id.x - from_id.x)
dy = abs(to_id.y - from_id.y)
result = sqrt(dx * dx + dy * dy)
```

Note: This is also the internal heuristic used in AStar3D and AStar2D by default (with the inclusion of possible z-axis coordinate).

Heuristic HEURISTIC_MANHATTAN = 1

The Manhattan heuristic [https://en.wikipedia.org/wiki/Taxicab_geometry] to be used for the pathfinding using the following formula:

```gdscript
dx = abs(to_id.x - from_id.x)
dy = abs(to_id.y - from_id.y)
result = dx + dy
```

Note: This heuristic is intended to be used with 4-side orthogonal movements, provided by setting the diagonal_mode to DIAGONAL_MODE_NEVER.

Heuristic HEURISTIC_OCTILE = 2

The Octile heuristic to be used for the pathfinding using the following formula:

```gdscript
dx = abs(to_id.x - from_id.x)
dy = abs(to_id.y - from_id.y)
f = sqrt(2) - 1
result = (dx < dy) ? f * dx + dy : f * dy + dx;
```

Heuristic HEURISTIC_CHEBYSHEV = 3

The Chebyshev heuristic [https://en.wikipedia.org/wiki/Chebyshev_distance] to be used for the pathfinding using the following formula:

```gdscript
dx = abs(to_id.x - from_id.x)
dy = abs(to_id.y - from_id.y)
result = max(dx, dy)
```

Heuristic HEURISTIC_MAX = 4

Represents the size of the Heuristic enum.

---

enum DiagonalMode
DiagonalMode DIAGONAL_MODE_ALWAYS = 0

The pathfinding algorithm will ignore solid neighbors around the target cell and allow passing using diagonals.

DiagonalMode DIAGONAL_MODE_NEVER = 1

The pathfinding algorithm will ignore all diagonals and the way will be always orthogonal.

DiagonalMode DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE = 2

The pathfinding algorithm will avoid using diagonals if at least two obstacles have been placed around the neighboring cells of the specific path segment.

DiagonalMode DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES = 3

The pathfinding algorithm will avoid using diagonals if any obstacle has been placed around the neighboring cells of the specific path segment.

DiagonalMode DIAGONAL_MODE_MAX = 4

Represents the size of the DiagonalMode enum.

---

enum CellShape
CellShape CELL_SHAPE_SQUARE = 0

Rectangular cell shape.

CellShape CELL_SHAPE_ISOMETRIC_RIGHT = 1

Diamond cell shape (for isometric look). Cell coordinates layout where the horizontal axis goes up-right, and the vertical one goes down-right.

CellShape CELL_SHAPE_ISOMETRIC_DOWN = 2

Diamond cell shape (for isometric look). Cell coordinates layout where the horizontal axis goes down-right, and the vertical one goes down-left.

CellShape CELL_SHAPE_MAX = 3

Represents the size of the CellShape enum.

---

## Property Descriptions

CellShape cell_shape = 0 

- void set_cell_shape(value: CellShape)
- CellShape get_cell_shape()

The cell shape. Affects how the positions are placed in the grid. If changed, update() needs to be called before finding the next path.

---

Vector2 cell_size = Vector2(1, 1) 

- void set_cell_size(value: Vector2)
- Vector2 get_cell_size()

The size of the point cell which will be applied to calculate the resulting point position returned by get_point_path(). If changed, update() needs to be called before finding the next path.

---

Heuristic default_compute_heuristic = 0 

- void set_default_compute_heuristic(value: Heuristic)
- Heuristic get_default_compute_heuristic()

The default Heuristic which will be used to calculate the cost between two points if _compute_cost() was not overridden.

---

Heuristic default_estimate_heuristic = 0 

- void set_default_estimate_heuristic(value: Heuristic)
- Heuristic get_default_estimate_heuristic()

The default Heuristic which will be used to calculate the cost between the point and the end point if _estimate_cost() was not overridden.

---

DiagonalMode diagonal_mode = 0 

- void set_diagonal_mode(value: DiagonalMode)
- DiagonalMode get_diagonal_mode()

A specific DiagonalMode mode which will force the path to avoid or accept the specified diagonals.

---

bool jumping_enabled = false 

- void set_jumping_enabled(value: bool)
- bool is_jumping_enabled()

Enables or disables jumping to skip up the intermediate points and speeds up the searching algorithm.

Note: Currently, toggling it on disables the consideration of weight scaling in pathfinding.

---

Vector2 offset = Vector2(0, 0) 

- void set_offset(value: Vector2)
- Vector2 get_offset()

The offset of the grid which will be applied to calculate the resulting point position returned by get_point_path(). If changed, update() needs to be called before finding the next path.

---

Rect2i region = Rect2i(0, 0, 0, 0) 

- void set_region(value: Rect2i)
- Rect2i get_region()

The region of grid cells available for pathfinding. If changed, update() needs to be called before finding the next path.

---

Vector2i size = Vector2i(0, 0) 

- void set_size(value: Vector2i)
- Vector2i get_size()

Deprecated: Use region instead.

The size of the grid (number of cells of size cell_size on each axis). If changed, update() needs to be called before finding the next path.

---

## Method Descriptions

float _compute_cost(from_id: Vector2i, to_id: Vector2i) virtual const 

Called when computing the cost between two connected points.

Note that this function is hidden in the default AStarGrid2D class.

---

float _estimate_cost(from_id: Vector2i, end_id: Vector2i) virtual const 

Called when estimating the cost between a point and the path's ending point.

Note that this function is hidden in the default AStarGrid2D class.

---

void clear() 

Clears the grid and sets the region to Rect2i(0, 0, 0, 0).

---

void fill_solid_region(region: Rect2i, solid: bool = true) 

Fills the given region on the grid with the specified value for the solid flag.

Note: Calling update() is not needed after the call of this function.

---

void fill_weight_scale_region(region: Rect2i, weight_scale: float) 

Fills the given region on the grid with the specified value for the weight scale.

Note: Calling update() is not needed after the call of this function.

---

Array[Vector2i] get_id_path(from_id: Vector2i, to_id: Vector2i, allow_partial_path: bool = false) 

Returns an array with the IDs of the points that form the path found by AStar2D between the given points. The array is ordered from the starting point to the ending point of the path.

If from_id point is disabled, returns an empty array (even if from_id == to_id).

If from_id point is not disabled, there is no valid path to the target, and allow_partial_path is true, returns a path to the point closest to the target that can be reached.

Note: When allow_partial_path is true and to_id is solid the search may take an unusually long time to finish.

---

Array[Dictionary] get_point_data_in_region(region: Rect2i) const 

Returns an array of dictionaries with point data (id: Vector2i, position: Vector2, solid: bool, weight_scale: float) within a region.

---

PackedVector2Array get_point_path(from_id: Vector2i, to_id: Vector2i, allow_partial_path: bool = false) 

Returns an array with the points that are in the path found by AStarGrid2D between the given points. The array is ordered from the starting point to the ending point of the path.

If from_id point is disabled, returns an empty array (even if from_id == to_id).

If from_id point is not disabled, there is no valid path to the target, and allow_partial_path is true, returns a path to the point closest to the target that can be reached.

Note: This method is not thread-safe; it can only be used from a single Thread at a given time. Consider using Mutex to ensure exclusive access to one thread to avoid race conditions.

Additionally, when allow_partial_path is true and to_id is solid the search may take an unusually long time to finish.

---

Vector2 get_point_position(id: Vector2i) const 

Returns the position of the point associated with the given id.

---

float get_point_weight_scale(id: Vector2i) const 

Returns the weight scale of the point associated with the given id.

---

bool is_dirty() const 

Indicates that the grid parameters were changed and update() needs to be called.

---

bool is_in_bounds(x: int, y: int) const 

Returns true if the x and y is a valid grid coordinate (id), i.e. if it is inside region. Equivalent to region.has_point(Vector2i(x, y)).

---

bool is_in_boundsv(id: Vector2i) const 

Returns true if the id vector is a valid grid coordinate, i.e. if it is inside region. Equivalent to region.has_point(id).

---

bool is_point_solid(id: Vector2i) const 

Returns true if a point is disabled for pathfinding. By default, all points are enabled.

---

void set_point_solid(id: Vector2i, solid: bool = true) 

Disables or enables the specified point for pathfinding. Useful for making an obstacle. By default, all points are enabled.

Note: Calling update() is not needed after the call of this function.

---

void set_point_weight_scale(id: Vector2i, weight_scale: float) 

Sets the weight_scale for the point with the given id. The weight_scale is multiplied by the result of _compute_cost() when determining the overall cost of traveling across a segment from a neighboring point to this point.

Note: Calling update() is not needed after the call of this function.

---

void update() 

Updates the internal state of the grid according to the parameters to prepare it to search the path. Needs to be called if parameters like region, cell_size or offset are changed. is_dirty() will return true if this is the case and this needs to be called.

Note: All point data (solidity and weight scale) will be cleared.
