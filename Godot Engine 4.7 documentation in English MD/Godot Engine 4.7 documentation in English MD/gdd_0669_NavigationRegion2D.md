# NavigationRegion2D

Experimental: This class may be changed or removed in future versions.

Inherits: Node2D < CanvasItem < Node < Object

A traversable 2D region that NavigationAgent2Ds can use for pathfinding.

## Description

A traversable 2D region based on a NavigationPolygon that NavigationAgent2Ds can use for pathfinding.

Two regions can be connected to each other if they share a similar edge. You can set the minimum distance between two vertices required to connect two edges by using NavigationServer2D.map_set_edge_connection_margin().

Note: Overlapping two regions' navigation polygons is not enough for connecting two regions. They must share a similar edge.

The pathfinding cost of entering a region from another region can be controlled with the enter_cost value.

Note: This value is not added to the path cost when the start position is already inside this region.

The pathfinding cost of traveling distances inside this region can be controlled with the travel_cost multiplier.

Note: This node caches changes to its properties, so if you make changes to the underlying region RID in NavigationServer2D, they will not be reflected in this node's properties.

## Tutorials

- Using NavigationRegions

## Properties

bool | enabled | true
float | enter_cost | 0.0
int | navigation_layers | 1
NavigationPolygon | navigation_polygon |
float | travel_cost | 1.0
bool | use_edge_connections | true

## Methods

void | bake_navigation_polygon(on_thread: bool = true)
Rect2 | get_bounds() const
bool | get_navigation_layer_value(layer_number: int) const
RID | get_navigation_map() const
RID | get_region_rid() const
RID | get_rid() const
bool | is_baking() const
void | set_navigation_layer_value(layer_number: int, value: bool)
void | set_navigation_map(navigation_map: RID)

---

## Signals

bake_finished() 

Emitted when a navigation polygon bake operation is completed.

---

navigation_polygon_changed() 

Emitted when the used navigation polygon is replaced or changes to the internals of the current navigation polygon are committed.

---

## Property Descriptions

bool enabled = true 

- void set_enabled(value: bool)
- bool is_enabled()

Determines if the NavigationRegion2D is enabled or disabled.

---

float enter_cost = 0.0 

- void set_enter_cost(value: float)
- float get_enter_cost()

When pathfinding enters this region's navigation mesh from another regions navigation mesh the enter_cost value is added to the path distance for determining the shortest path.

---

int navigation_layers = 1 

- void set_navigation_layers(value: int)
- int get_navigation_layers()

A bitfield determining all navigation layers the region belongs to. These navigation layers can be checked upon when requesting a path with NavigationServer2D.map_get_path().

---

NavigationPolygon navigation_polygon 

- void set_navigation_polygon(value: NavigationPolygon)
- NavigationPolygon get_navigation_polygon()

The NavigationPolygon resource to use.

---

float travel_cost = 1.0 

- void set_travel_cost(value: float)
- float get_travel_cost()

When pathfinding moves inside this region's navigation mesh the traveled distances are multiplied with travel_cost for determining the shortest path.

---

bool use_edge_connections = true 

- void set_use_edge_connections(value: bool)
- bool get_use_edge_connections()

If enabled the navigation region will use edge connections to connect with other navigation regions within proximity of the navigation map edge connection margin.

---

## Method Descriptions

void bake_navigation_polygon(on_thread: bool = true) 

Bakes the NavigationPolygon. If on_thread is set to true (default), the baking is done on a separate thread.

---

Rect2 get_bounds() const 

Returns the axis-aligned rectangle for the region's transformed navigation mesh.

---

bool get_navigation_layer_value(layer_number: int) const 

Returns whether or not the specified layer of the navigation_layers bitmask is enabled, given a layer_number between 1 and 32.

---

RID get_navigation_map() const 

Returns the current navigation map RID used by this region.

---

RID get_region_rid() const 

Deprecated: Use get_rid() instead.

Returns the RID of this region on the NavigationServer2D.

---

RID get_rid() const 

Returns the RID of this region on the NavigationServer2D. Combined with NavigationServer2D.map_get_closest_point_owner() can be used to identify the NavigationRegion2D closest to a point on the merged navigation map.

---

bool is_baking() const 

Returns true when the NavigationPolygon is being baked on a background thread.

---

void set_navigation_layer_value(layer_number: int, value: bool) 

Based on value, enables or disables the specified layer in the navigation_layers bitmask, given a layer_number between 1 and 32.

---

void set_navigation_map(navigation_map: RID) 

Sets the RID of the navigation map this region should use. By default the region will automatically join the World2D default navigation map so this function is only required to override the default map.
