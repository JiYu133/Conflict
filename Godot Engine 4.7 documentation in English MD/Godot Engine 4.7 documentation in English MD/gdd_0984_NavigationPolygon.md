# NavigationPolygon

Experimental: This class may be changed or removed in future versions.

Inherits: Resource < RefCounted < Object

A 2D navigation mesh that describes a traversable surface for pathfinding.

## Description

A navigation mesh can be created either by baking it with the help of the NavigationServer2D, or by adding vertices and convex polygon indices arrays manually.

To bake a navigation mesh at least one outline needs to be added that defines the outer bounds of the baked area.

```
var new_navigation_mesh = NavigationPolygon.new()
var bounding_outline = PackedVector2Array([Vector2(0, 0), Vector2(0, 50), Vector2(50, 50), Vector2(50, 0)])
new_navigation_mesh.add_outline(bounding_outline)
NavigationServer2D.bake_from_source_geometry_data(new_navigation_mesh, NavigationMeshSourceGeometryData2D.new());
$NavigationRegion2D.navigation_polygon = new_navigation_mesh
```

```
var newNavigationMesh = new NavigationPolygon();
Vector2[] boundingOutline = [new Vector2(0, 0), new Vector2(0, 50), new Vector2(50, 50), new Vector2(50, 0)];
newNavigationMesh.AddOutline(boundingOutline);
NavigationServer2D.BakeFromSourceGeometryData(newNavigationMesh, new NavigationMeshSourceGeometryData2D());
GetNode("NavigationRegion2D").NavigationPolygon = newNavigationMesh;
```

Adding vertices and polygon indices manually.

```
var new_navigation_mesh = NavigationPolygon.new()
var new_vertices = PackedVector2Array([Vector2(0, 0), Vector2(0, 50), Vector2(50, 50), Vector2(50, 0)])
new_navigation_mesh.vertices = new_vertices
var new_polygon_indices = PackedInt32Array([0, 1, 2, 3])
new_navigation_mesh.add_polygon(new_polygon_indices)
$NavigationRegion2D.navigation_polygon = new_navigation_mesh
```

```
var newNavigationMesh = new NavigationPolygon();
Vector2[] newVertices = [new Vector2(0, 0), new Vector2(0, 50), new Vector2(50, 50), new Vector2(50, 0)];
newNavigationMesh.Vertices = newVertices;
int[] newPolygonIndices = [0, 1, 2, 3];
newNavigationMesh.AddPolygon(newPolygonIndices);
GetNode("NavigationRegion2D").NavigationPolygon = newNavigationMesh;
```

## Tutorials

- Using NavigationMeshes
- Navigation Polygon 2D Demo [https://godotengine.org/asset-library/asset/2722]

## Properties

float | agent_radius | 10.0
Rect2 | baking_rect | Rect2(0, 0, 0, 0)
Vector2 | baking_rect_offset | Vector2(0, 0)
float | border_size | 0.0
float | cell_size | 1.0
int | parsed_collision_mask | 4294967295
ParsedGeometryType | parsed_geometry_type | 2
SamplePartitionType | sample_partition_type | 0
StringName | source_geometry_group_name | &"navigation_polygon_source_geometry_group"
SourceGeometryMode | source_geometry_mode | 0

## Methods

void | add_outline(outline: PackedVector2Array)
void | add_outline_at_index(outline: PackedVector2Array, index: int)
void | add_polygon(polygon: PackedInt32Array)
void | clear()
void | clear_outlines()
void | clear_polygons()
NavigationMesh | get_navigation_mesh()
PackedVector2Array | get_outline(idx: int) const
int | get_outline_count() const
bool | get_parsed_collision_mask_value(layer_number: int) const
PackedInt32Array | get_polygon(idx: int)
int | get_polygon_count() const
PackedVector2Array | get_vertices() const
void | make_polygons_from_outlines()
void | remove_outline(idx: int)
void | set_outline(idx: int, outline: PackedVector2Array)
void | set_parsed_collision_mask_value(layer_number: int, value: bool)
void | set_vertices(vertices: PackedVector2Array)

---

## Enumerations

enum SamplePartitionType
SamplePartitionType SAMPLE_PARTITION_CONVEX_PARTITION = 0

Convex partitioning that results in a navigation mesh with convex polygons.

SamplePartitionType SAMPLE_PARTITION_TRIANGULATE = 1

Triangulation partitioning that results in a navigation mesh with triangle polygons.

SamplePartitionType SAMPLE_PARTITION_MAX = 2

Represents the size of the SamplePartitionType enum.

---

enum ParsedGeometryType
ParsedGeometryType PARSED_GEOMETRY_MESH_INSTANCES = 0

Parses mesh instances as obstruction geometry. This includes Polygon2D, MeshInstance2D, MultiMeshInstance2D, and TileMap nodes.

Meshes are only parsed when they use a 2D vertices surface format.

ParsedGeometryType PARSED_GEOMETRY_STATIC_COLLIDERS = 1

Parses StaticBody2D and TileMap colliders as obstruction geometry. The collider should be in any of the layers specified by parsed_collision_mask.

ParsedGeometryType PARSED_GEOMETRY_BOTH = 2

Both PARSED_GEOMETRY_MESH_INSTANCES and PARSED_GEOMETRY_STATIC_COLLIDERS.

ParsedGeometryType PARSED_GEOMETRY_MAX = 3

Represents the size of the ParsedGeometryType enum.

---

enum SourceGeometryMode
SourceGeometryMode SOURCE_GEOMETRY_ROOT_NODE_CHILDREN = 0

Scans the child nodes of the root node recursively for geometry.

SourceGeometryMode SOURCE_GEOMETRY_GROUPS_WITH_CHILDREN = 1

Scans nodes in a group and their child nodes recursively for geometry. The group is specified by source_geometry_group_name.

SourceGeometryMode SOURCE_GEOMETRY_GROUPS_EXPLICIT = 2

Uses nodes in a group for geometry. The group is specified by source_geometry_group_name.

SourceGeometryMode SOURCE_GEOMETRY_MAX = 3

Represents the size of the SourceGeometryMode enum.

---

## Property Descriptions

float agent_radius = 10.0 

- void set_agent_radius(value: float)
- float get_agent_radius()

The distance to erode/shrink the walkable surface when baking the navigation mesh.

Note: The radius must be equal or higher than 0.0. If the radius is 0.0, it won't be possible to fix invalid outline overlaps and other precision errors during the baking process. As a result, some obstacles may be excluded incorrectly from the final navigation mesh, or may delete the navigation mesh's polygons.

---

Rect2 baking_rect = Rect2(0, 0, 0, 0) 

- void set_baking_rect(value: Rect2)
- Rect2 get_baking_rect()

If the baking Rect2 has an area the navigation mesh baking will be restricted to its enclosing area.

---

Vector2 baking_rect_offset = Vector2(0, 0) 

- void set_baking_rect_offset(value: Vector2)
- Vector2 get_baking_rect_offset()

The position offset applied to the baking_rect Rect2.

---

float border_size = 0.0 

- void set_border_size(value: float)
- float get_border_size()

The size of the non-navigable border around the bake bounding area defined by the baking_rect Rect2.

In conjunction with the baking_rect the border size can be used to bake tile aligned navigation meshes without the tile edges being shrunk by agent_radius.

---

float cell_size = 1.0 

- void set_cell_size(value: float)
- float get_cell_size()

The cell size used to rasterize the navigation mesh vertices. Must match with the cell size on the navigation map.

---

int parsed_collision_mask = 4294967295 

- void set_parsed_collision_mask(value: int)
- int get_parsed_collision_mask()

The physics layers to scan for static colliders.

Only used when parsed_geometry_type is PARSED_GEOMETRY_STATIC_COLLIDERS or PARSED_GEOMETRY_BOTH.

---

ParsedGeometryType parsed_geometry_type = 2 

- void set_parsed_geometry_type(value: ParsedGeometryType)
- ParsedGeometryType get_parsed_geometry_type()

Determines which type of nodes will be parsed as geometry.

---

SamplePartitionType sample_partition_type = 0 

- void set_sample_partition_type(value: SamplePartitionType)
- SamplePartitionType get_sample_partition_type()

Partitioning algorithm for creating the navigation mesh polys.

---

StringName source_geometry_group_name = &"navigation_polygon_source_geometry_group" 

- void set_source_geometry_group_name(value: StringName)
- StringName get_source_geometry_group_name()

The group name of nodes that should be parsed for baking source geometry.

Only used when source_geometry_mode is SOURCE_GEOMETRY_GROUPS_WITH_CHILDREN or SOURCE_GEOMETRY_GROUPS_EXPLICIT.

---

SourceGeometryMode source_geometry_mode = 0 

- void set_source_geometry_mode(value: SourceGeometryMode)
- SourceGeometryMode get_source_geometry_mode()

The source of the geometry used when baking.

---

## Method Descriptions

void add_outline(outline: PackedVector2Array) 

Appends a PackedVector2Array that contains the vertices of an outline to the internal array that contains all the outlines.

---

void add_outline_at_index(outline: PackedVector2Array, index: int) 

Adds a PackedVector2Array that contains the vertices of an outline to the internal array that contains all the outlines at a fixed position.

---

void add_polygon(polygon: PackedInt32Array) 

Adds a polygon using the indices of the vertices you get when calling get_vertices().

---

void clear() 

Clears the internal arrays for vertices and polygon indices.

---

void clear_outlines() 

Clears the array of the outlines, but it doesn't clear the vertices and the polygons that were created by them.

---

void clear_polygons() 

Clears the array of polygons, but it doesn't clear the array of outlines and vertices.

---

NavigationMesh get_navigation_mesh() 

Returns the NavigationMesh resulting from this navigation polygon. This navigation mesh can be used to update the navigation mesh of a region with the NavigationServer3D.region_set_navigation_mesh() API directly.

---

PackedVector2Array get_outline(idx: int) const 

Returns a PackedVector2Array containing the vertices of an outline that was created in the editor or by script.

---

int get_outline_count() const 

Returns the number of outlines that were created in the editor or by script.

---

bool get_parsed_collision_mask_value(layer_number: int) const 

Returns whether or not the specified layer of the parsed_collision_mask is enabled, given a layer_number between 1 and 32.

---

PackedInt32Array get_polygon(idx: int) 

Returns a PackedInt32Array containing the indices of the vertices of a created polygon.

---

int get_polygon_count() const 

Returns the count of all polygons.

---

PackedVector2Array get_vertices() const 

Returns a PackedVector2Array containing all the vertices being used to create the polygons.

---

void make_polygons_from_outlines() 

Deprecated: Use NavigationServer2D.parse_source_geometry_data() and NavigationServer2D.bake_from_source_geometry_data() instead.

Creates polygons from the outlines added in the editor or by script.

---

void remove_outline(idx: int) 

Removes an outline created in the editor or by script. You have to call make_polygons_from_outlines() for the polygons to update.

---

void set_outline(idx: int, outline: PackedVector2Array) 

Changes an outline created in the editor or by script. You have to call make_polygons_from_outlines() for the polygons to update.

---

void set_parsed_collision_mask_value(layer_number: int, value: bool) 

Based on value, enables or disables the specified layer in the parsed_collision_mask, given a layer_number between 1 and 32.

---

void set_vertices(vertices: PackedVector2Array) 

Sets the vertices that can be then indexed to create polygons with the add_polygon() method.
