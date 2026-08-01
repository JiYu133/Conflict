# NavigationPathQueryParameters3D

Experimental: This class may be changed or removed in future versions.

Inherits: RefCounted < Object

Provides parameters for 3D navigation path queries.

## Description

By changing various properties of this object, such as the start and target position, you can configure path queries to the NavigationServer3D.

## Tutorials

- Using NavigationPathQueryObjects

## Properties

Array[RID] | excluded_regions | []
Array[RID] | included_regions | []
RID | map | RID()
BitField[PathMetadataFlags] | metadata_flags | 7
int | navigation_layers | 1
PathPostProcessing | path_postprocessing | 0
float | path_return_max_length | 0.0
float | path_return_max_radius | 0.0
float | path_search_max_distance | 0.0
int | path_search_max_polygons | 4096
PathfindingAlgorithm | pathfinding_algorithm | 0
float | simplify_epsilon | 0.0
bool | simplify_path | false
Vector3 | start_position | Vector3(0, 0, 0)
Vector3 | target_position | Vector3(0, 0, 0)

---

## Enumerations

enum PathfindingAlgorithm
PathfindingAlgorithm PATHFINDING_ALGORITHM_ASTAR = 0

The path query uses the default A* pathfinding algorithm.

---

enum PathPostProcessing
PathPostProcessing PATH_POSTPROCESSING_CORRIDORFUNNEL = 0

Applies a funnel algorithm to the raw path corridor found by the pathfinding algorithm. This will result in the shortest path possible inside the path corridor. This postprocessing very much depends on the navigation mesh polygon layout and the created corridor. Especially tile- or gridbased layouts can face artificial corners with diagonal movement due to a jagged path corridor imposed by the cell shapes.

PathPostProcessing PATH_POSTPROCESSING_EDGECENTERED = 1

Centers every path position in the middle of the traveled navigation mesh polygon edge. This creates better paths for tile- or gridbased layouts that restrict the movement to the cells center.

PathPostProcessing PATH_POSTPROCESSING_NONE = 2

Applies no postprocessing and returns the raw path corridor as found by the pathfinding algorithm.

---

flags PathMetadataFlags: 

PathMetadataFlags PATH_METADATA_INCLUDE_NONE = 0

Don't include any additional metadata about the returned path.

PathMetadataFlags PATH_METADATA_INCLUDE_TYPES = 1

Include the type of navigation primitive (region or link) that each point of the path goes through.

PathMetadataFlags PATH_METADATA_INCLUDE_RIDS = 2

Include the RIDs of the regions and links that each point of the path goes through.

PathMetadataFlags PATH_METADATA_INCLUDE_OWNERS = 4

Include the ObjectIDs of the Objects which manage the regions and links each point of the path goes through.

PathMetadataFlags PATH_METADATA_INCLUDE_ALL = 7

Include all available metadata about the returned path.

---

## Property Descriptions

Array[RID] excluded_regions = [] 

- void set_excluded_regions(value: Array[RID])
- Array[RID] get_excluded_regions()

The list of region RIDs that will be excluded from the path query. Use NavigationRegion3D.get_rid() to get the RID associated with a NavigationRegion3D node.

Note: The returned array is copied and any changes to it will not update the original property value. To update the value you need to modify the returned array, and then set it to the property again.

---

Array[RID] included_regions = [] 

- void set_included_regions(value: Array[RID])
- Array[RID] get_included_regions()

The list of region RIDs that will be included by the path query. Use NavigationRegion3D.get_rid() to get the RID associated with a NavigationRegion3D node. If left empty all regions are included. If a region ends up being both included and excluded at the same time it will be excluded.

Note: The returned array is copied and any changes to it will not update the original property value. To update the value you need to modify the returned array, and then set it to the property again.

---

RID map = RID() 

- void set_map(value: RID)
- RID get_map()

The navigation map RID used in the path query.

---

BitField[PathMetadataFlags] metadata_flags = 7 

- void set_metadata_flags(value: BitField[PathMetadataFlags])
- BitField[PathMetadataFlags] get_metadata_flags()

Additional information to include with the navigation path.

---

int navigation_layers = 1 

- void set_navigation_layers(value: int)
- int get_navigation_layers()

The navigation layers the query will use (as a bitmask).

---

PathPostProcessing path_postprocessing = 0 

- void set_path_postprocessing(value: PathPostProcessing)
- PathPostProcessing get_path_postprocessing()

The path postprocessing applied to the raw path corridor found by the pathfinding_algorithm.

---

float path_return_max_length = 0.0 

- void set_path_return_max_length(value: float)
- float get_path_return_max_length()

The maximum allowed length of the returned path in world units. A path will be clipped when going over this length. A value of 0 or below counts as disabled.

---

float path_return_max_radius = 0.0 

- void set_path_return_max_radius(value: float)
- float get_path_return_max_radius()

The maximum allowed radius in world units that the returned path can be from the path start. The path will be clipped when going over this radius. A value of 0 or below counts as disabled.

Note: This will perform a sphere shaped clip operation on the path with the first path position being the sphere's center position.

---

float path_search_max_distance = 0.0 

- void set_path_search_max_distance(value: float)
- float get_path_search_max_distance()

The maximum distance a searched polygon can be away from the start polygon before the pathfinding cancels the search for a path to the (possibly unreachable or very far away) target position polygon. In this case the pathfinding resets and builds a path from the start polygon to the polygon that was found closest to the target position so far. A value of 0 or below counts as unlimited. In case of unlimited the pathfinding will search all polygons connected with the start polygon until either the target position polygon is found or all available polygon search options are exhausted.

---

int path_search_max_polygons = 4096 

- void set_path_search_max_polygons(value: int)
- int get_path_search_max_polygons()

The maximum number of polygons that are searched before the pathfinding cancels the search for a path to the (possibly unreachable or very far away) target position polygon. In this case the pathfinding resets and builds a path from the start polygon to the polygon that was found closest to the target position so far. A value of 0 or below counts as unlimited. In case of unlimited the pathfinding will search all polygons connected with the start polygon until either the target position polygon is found or all available polygon search options are exhausted.

---

PathfindingAlgorithm pathfinding_algorithm = 0 

- void set_pathfinding_algorithm(value: PathfindingAlgorithm)
- PathfindingAlgorithm get_pathfinding_algorithm()

The pathfinding algorithm used in the path query.

---

float simplify_epsilon = 0.0 

- void set_simplify_epsilon(value: float)
- float get_simplify_epsilon()

The path simplification amount in worlds units.

---

bool simplify_path = false 

- void set_simplify_path(value: bool)
- bool get_simplify_path()

If true a simplified version of the path will be returned with less critical path points removed. The simplification amount is controlled by simplify_epsilon. The simplification uses a variant of Ramer-Douglas-Peucker algorithm for curve point decimation.

Path simplification can be helpful to mitigate various path following issues that can arise with certain agent types and script behaviors. E.g. "steering" agents or avoidance in "open fields".

---

Vector3 start_position = Vector3(0, 0, 0) 

- void set_start_position(value: Vector3)
- Vector3 get_start_position()

The pathfinding start position in global coordinates.

---

Vector3 target_position = Vector3(0, 0, 0) 

- void set_target_position(value: Vector3)
- Vector3 get_target_position()

The pathfinding target position in global coordinates.
