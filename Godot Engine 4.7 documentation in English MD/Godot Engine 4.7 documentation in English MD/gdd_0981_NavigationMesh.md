# NavigationMesh

Experimental: This class may be changed or removed in future versions.

Inherits: Resource < RefCounted < Object

A navigation mesh that defines traversable areas and obstacles.

## Description

A navigation mesh is a collection of polygons that define which areas of an environment are traversable to aid agents in pathfinding through complicated spaces.

## Tutorials

- Using NavigationMeshes
- 3D Navigation Demo [https://godotengine.org/asset-library/asset/2743]

## Properties

float | agent_height | 1.5
float | agent_max_climb | 0.25
float | agent_max_slope | 45.0
float | agent_radius | 0.5
float | border_size | 0.0
float | cell_height | 0.25
float | cell_size | 0.25
float | detail_sample_distance | 6.0
float | detail_sample_max_error | 1.0
float | edge_max_error | 1.3
float | edge_max_length | 0.0
AABB | filter_baking_aabb | AABB(0, 0, 0, 0, 0, 0)
Vector3 | filter_baking_aabb_offset | Vector3(0, 0, 0)
bool | filter_ledge_spans | false
bool | filter_low_hanging_obstacles | false
bool | filter_walkable_low_height_spans | false
int | geometry_collision_mask | 4294967295
ParsedGeometryType | geometry_parsed_geometry_type | 2
SourceGeometryMode | geometry_source_geometry_mode | 0
StringName | geometry_source_group_name | &"navigation_mesh_source_group"
float | region_merge_size | 20.0
float | region_min_size | 2.0
SamplePartitionType | sample_partition_type | 0
float | vertices_per_polygon | 6.0

## Methods

void | add_polygon(polygon: PackedInt32Array)
void | clear()
void | clear_polygons()
void | create_from_mesh(mesh: Mesh)
bool | get_collision_mask_value(layer_number: int) const
PackedInt32Array | get_polygon(idx: int)
int | get_polygon_count() const
PackedVector3Array | get_vertices() const
void | set_collision_mask_value(layer_number: int, value: bool)
void | set_vertices(vertices: PackedVector3Array)

---

## Enumerations

enum SamplePartitionType
SamplePartitionType SAMPLE_PARTITION_WATERSHED = 0

Watershed partitioning. Generally the best choice if you precompute the navigation mesh, use this if you have large open areas.

SamplePartitionType SAMPLE_PARTITION_MONOTONE = 1

Monotone partitioning. Use this if you want fast navigation mesh generation.

SamplePartitionType SAMPLE_PARTITION_LAYERS = 2

Layer partitioning. Good choice to use for tiled navigation mesh with medium and small sized tiles.

SamplePartitionType SAMPLE_PARTITION_MAX = 3

Represents the size of the SamplePartitionType enum.

---

enum ParsedGeometryType
ParsedGeometryType PARSED_GEOMETRY_MESH_INSTANCES = 0

Parses mesh instances as geometry. This includes MeshInstance3D, CSGShape3D, and GridMap nodes.

ParsedGeometryType PARSED_GEOMETRY_STATIC_COLLIDERS = 1

Parses StaticBody3D colliders as geometry. The collider should be in any of the layers specified by geometry_collision_mask.

ParsedGeometryType PARSED_GEOMETRY_BOTH = 2

Both PARSED_GEOMETRY_MESH_INSTANCES and PARSED_GEOMETRY_STATIC_COLLIDERS.

ParsedGeometryType PARSED_GEOMETRY_MAX = 3

Represents the size of the ParsedGeometryType enum.

---

enum SourceGeometryMode
SourceGeometryMode SOURCE_GEOMETRY_ROOT_NODE_CHILDREN = 0

Scans the child nodes of the root node recursively for geometry.

SourceGeometryMode SOURCE_GEOMETRY_GROUPS_WITH_CHILDREN = 1

Scans nodes in a group and their child nodes recursively for geometry. The group is specified by geometry_source_group_name.

SourceGeometryMode SOURCE_GEOMETRY_GROUPS_EXPLICIT = 2

Uses nodes in a group for geometry. The group is specified by geometry_source_group_name.

SourceGeometryMode SOURCE_GEOMETRY_MAX = 3

Represents the size of the SourceGeometryMode enum.

---

## Property Descriptions

float agent_height = 1.5 

- void set_agent_height(value: float)
- float get_agent_height()

The minimum floor to ceiling height that will still allow the floor area to be considered walkable.

Note: While baking, this value will be rounded up to the nearest multiple of cell_height.

---

float agent_max_climb = 0.25 

- void set_agent_max_climb(value: float)
- float get_agent_max_climb()

The minimum ledge height that is considered to still be traversable.

Note: While baking, this value will be rounded down to the nearest multiple of cell_height.

---

float agent_max_slope = 45.0 

- void set_agent_max_slope(value: float)
- float get_agent_max_slope()

The maximum slope that is considered walkable, in degrees.

---

float agent_radius = 0.5 

- void set_agent_radius(value: float)
- float get_agent_radius()

The distance to erode/shrink the walkable area of the heightfield away from obstructions.

Note: While baking, this value will be rounded up to the nearest multiple of cell_size.

Note: The radius must be equal or higher than 0.0. If the radius is 0.0, it won't be possible to fix invalid outline overlaps and other precision errors during the baking process. As a result, some obstacles may be excluded incorrectly from the final navigation mesh, or may delete the navigation mesh's polygons.

---

float border_size = 0.0 

- void set_border_size(value: float)
- float get_border_size()

The size of the non-navigable border around the bake bounding area.

In conjunction with the filter_baking_aabb and a edge_max_error value at 1.0 or below the border size can be used to bake tile aligned navigation meshes without the tile edges being shrunk by agent_radius.

Note: If this value is not 0.0, it will be rounded up to the nearest multiple of cell_size during baking.

---

float cell_height = 0.25 

- void set_cell_height(value: float)
- float get_cell_height()

The cell height used to rasterize the navigation mesh vertices on the Y axis. Must match with the cell height on the navigation map.

---

float cell_size = 0.25 

- void set_cell_size(value: float)
- float get_cell_size()

The cell size used to rasterize the navigation mesh vertices on the XZ plane. Must match with the cell size on the navigation map.

---

float detail_sample_distance = 6.0 

- void set_detail_sample_distance(value: float)
- float get_detail_sample_distance()

The sampling distance to use when generating the detail mesh, in cell unit.

---

float detail_sample_max_error = 1.0 

- void set_detail_sample_max_error(value: float)
- float get_detail_sample_max_error()

The maximum distance the detail mesh surface should deviate from heightfield, in cell unit.

---

float edge_max_error = 1.3 

- void set_edge_max_error(value: float)
- float get_edge_max_error()

The maximum distance a simplified contour's border edges should deviate the original raw contour.

---

float edge_max_length = 0.0 

- void set_edge_max_length(value: float)
- float get_edge_max_length()

The maximum allowed length for contour edges along the border of the mesh. A value of 0.0 disables this feature.

Note: While baking, this value will be rounded up to the nearest multiple of cell_size.

---

AABB filter_baking_aabb = AABB(0, 0, 0, 0, 0, 0) 

- void set_filter_baking_aabb(value: AABB)
- AABB get_filter_baking_aabb()

If the baking AABB has a volume the navigation mesh baking will be restricted to its enclosing area.

---

Vector3 filter_baking_aabb_offset = Vector3(0, 0, 0) 

- void set_filter_baking_aabb_offset(value: Vector3)
- Vector3 get_filter_baking_aabb_offset()

The position offset applied to the filter_baking_aabb AABB.

---

bool filter_ledge_spans = false 

- void set_filter_ledge_spans(value: bool)
- bool get_filter_ledge_spans()

If true, marks spans that are ledges as non-walkable.

---

bool filter_low_hanging_obstacles = false 

- void set_filter_low_hanging_obstacles(value: bool)
- bool get_filter_low_hanging_obstacles()

If true, marks non-walkable spans as walkable if their maximum is within agent_max_climb of a walkable neighbor.

---

bool filter_walkable_low_height_spans = false 

- void set_filter_walkable_low_height_spans(value: bool)
- bool get_filter_walkable_low_height_spans()

If true, marks walkable spans as not walkable if the clearance above the span is less than agent_height.

---

int geometry_collision_mask = 4294967295 

- void set_collision_mask(value: int)
- int get_collision_mask()

The physics layers to scan for static colliders.

Only used when geometry_parsed_geometry_type is PARSED_GEOMETRY_STATIC_COLLIDERS or PARSED_GEOMETRY_BOTH.

---

ParsedGeometryType geometry_parsed_geometry_type = 2 

- void set_parsed_geometry_type(value: ParsedGeometryType)
- ParsedGeometryType get_parsed_geometry_type()

Determines which type of nodes will be parsed as geometry.

---

SourceGeometryMode geometry_source_geometry_mode = 0 

- void set_source_geometry_mode(value: SourceGeometryMode)
- SourceGeometryMode get_source_geometry_mode()

The source of the geometry used when baking.

---

StringName geometry_source_group_name = &"navigation_mesh_source_group" 

- void set_source_group_name(value: StringName)
- StringName get_source_group_name()

The name of the group to scan for geometry.

Only used when geometry_source_geometry_mode is SOURCE_GEOMETRY_GROUPS_WITH_CHILDREN or SOURCE_GEOMETRY_GROUPS_EXPLICIT.

---

float region_merge_size = 20.0 

- void set_region_merge_size(value: float)
- float get_region_merge_size()

Any regions with a size smaller than this will be merged with larger regions if possible.

Note: This value will be squared to calculate the number of cells. For example, a value of 20 will set the number of cells to 400.

---

float region_min_size = 2.0 

- void set_region_min_size(value: float)
- float get_region_min_size()

The minimum size of a region for it to be created.

Note: This value will be squared to calculate the minimum number of cells allowed to form isolated island areas. For example, a value of 8 will set the number of cells to 64.

---

SamplePartitionType sample_partition_type = 0 

- void set_sample_partition_type(value: SamplePartitionType)
- SamplePartitionType get_sample_partition_type()

Partitioning algorithm for creating the navigation mesh polys.

---

float vertices_per_polygon = 6.0 

- void set_vertices_per_polygon(value: float)
- float get_vertices_per_polygon()

The maximum number of vertices allowed for polygons generated during the contour to polygon conversion process.

---

## Method Descriptions

void add_polygon(polygon: PackedInt32Array) 

Adds a polygon using the indices of the vertices you get when calling get_vertices().

---

void clear() 

Clears the internal arrays for vertices and polygon indices.

---

void clear_polygons() 

Clears the array of polygons, but it doesn't clear the array of vertices.

---

void create_from_mesh(mesh: Mesh) 

Initializes the navigation mesh by setting the vertices and indices according to a Mesh.

Note: The given mesh must be of type Mesh.PRIMITIVE_TRIANGLES and have an index array.

---

bool get_collision_mask_value(layer_number: int) const 

Returns whether or not the specified layer of the geometry_collision_mask is enabled, given a layer_number between 1 and 32.

---

PackedInt32Array get_polygon(idx: int) 

Returns a PackedInt32Array containing the indices of the vertices of a created polygon.

---

int get_polygon_count() const 

Returns the number of polygons in the navigation mesh.

---

PackedVector3Array get_vertices() const 

Returns a PackedVector3Array containing all the vertices being used to create the polygons.

---

void set_collision_mask_value(layer_number: int, value: bool) 

Based on value, enables or disables the specified layer in the geometry_collision_mask, given a layer_number between 1 and 32.

---

void set_vertices(vertices: PackedVector3Array) 

Sets the vertices that can be then indexed to create polygons with the add_polygon() method.
