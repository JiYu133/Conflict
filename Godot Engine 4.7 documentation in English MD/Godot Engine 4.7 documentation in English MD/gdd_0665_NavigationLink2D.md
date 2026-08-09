# NavigationLink2D

Experimental: This class may be changed or removed in future versions.

Inherits: Node2D < CanvasItem < Node < Object

A link between two positions on NavigationRegion2Ds that agents can be routed through.

## Description

A link between two positions on NavigationRegion2Ds that agents can be routed through. These positions can be on the same NavigationRegion2D or on two different ones. Links are useful to express navigation methods other than traveling along the surface of the navigation polygon, such as ziplines, teleporters, or gaps that can be jumped across.

## Tutorials

- Using NavigationLinks

## Properties

bool | bidirectional | true
bool | enabled | true
Vector2 | end_position | Vector2(0, 0)
float | enter_cost | 0.0
int | navigation_layers | 1
Vector2 | start_position | Vector2(0, 0)
float | travel_cost | 1.0

## Methods

Vector2 | get_global_end_position() const
Vector2 | get_global_start_position() const
bool | get_navigation_layer_value(layer_number: int) const
RID | get_navigation_map() const
RID | get_rid() const
void | set_global_end_position(position: Vector2)
void | set_global_start_position(position: Vector2)
void | set_navigation_layer_value(layer_number: int, value: bool)
void | set_navigation_map(navigation_map: RID)

---

## Property Descriptions

bool bidirectional = true 

- void set_bidirectional(value: bool)
- bool is_bidirectional()

Whether this link can be traveled in both directions or only from start_position to end_position.

---

bool enabled = true 

- void set_enabled(value: bool)
- bool is_enabled()

Whether this link is currently active. If false, NavigationServer2D.map_get_path() will ignore this link.

---

Vector2 end_position = Vector2(0, 0) 

- void set_end_position(value: Vector2)
- Vector2 get_end_position()

Ending position of the link.

This position will search out the nearest polygon in the navigation mesh to attach to.

The distance the link will search is controlled by NavigationServer2D.map_set_link_connection_radius().

---

float enter_cost = 0.0 

- void set_enter_cost(value: float)
- float get_enter_cost()

When pathfinding enters this link from another regions navigation mesh the enter_cost value is added to the path distance for determining the shortest path.

---

int navigation_layers = 1 

- void set_navigation_layers(value: int)
- int get_navigation_layers()

A bitfield determining all navigation layers the link belongs to. These navigation layers will be checked when requesting a path with NavigationServer2D.map_get_path().

---

Vector2 start_position = Vector2(0, 0) 

- void set_start_position(value: Vector2)
- Vector2 get_start_position()

Starting position of the link.

This position will search out the nearest polygon in the navigation mesh to attach to.

The distance the link will search is controlled by NavigationServer2D.map_set_link_connection_radius().

---

float travel_cost = 1.0 

- void set_travel_cost(value: float)
- float get_travel_cost()

When pathfinding moves along the link the traveled distance is multiplied with travel_cost for determining the shortest path.

---

## Method Descriptions

Vector2 get_global_end_position() const 

Returns the end_position that is relative to the link as a global position.

---

Vector2 get_global_start_position() const 

Returns the start_position that is relative to the link as a global position.

---

bool get_navigation_layer_value(layer_number: int) const 

Returns whether or not the specified layer of the navigation_layers bitmask is enabled, given a layer_number between 1 and 32.

---

RID get_navigation_map() const 

Returns the current navigation map RID used by this link.

---

RID get_rid() const 

Returns the RID of this link on the NavigationServer2D.

---

void set_global_end_position(position: Vector2) 

Sets the end_position that is relative to the link from a global position.

---

void set_global_start_position(position: Vector2) 

Sets the start_position that is relative to the link from a global position.

---

void set_navigation_layer_value(layer_number: int, value: bool) 

Based on value, enables or disables the specified layer in the navigation_layers bitmask, given a layer_number between 1 and 32.

---

void set_navigation_map(navigation_map: RID) 

Sets the RID of the navigation map this link should use. By default the link will automatically join the World2D default navigation map so this function is only required to override the default map.
