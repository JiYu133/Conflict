# GraphEdit

Inherits: Control < CanvasItem < Node < Object

An editor for graph-like structures, using GraphNodes.

## Description

GraphEdit provides tools for creation, manipulation, and display of various graphs. Its main purpose in the engine is to power the visual programming systems, such as visual shaders, but it is also available for use in user projects.

GraphEdit by itself is only an empty container, representing an infinite grid where GraphNodes can be placed. Each GraphNode represents a node in the graph, a single unit of data in the connected scheme. GraphEdit, in turn, helps to control various interactions with nodes and between nodes. When the user attempts to connect, disconnect, or delete a GraphNode, a signal is emitted in the GraphEdit, but no action is taken by default. It is the responsibility of the programmer utilizing this control to implement the necessary logic to determine how each request should be handled.

Performance: It is greatly advised to enable low-processor usage mode (see OS.low_processor_usage_mode) when using GraphEdits.

Note: Keep in mind that Node.get_children() will also return the connection layer node named _connection_layer due to technical limitations. This behavior may change in future releases.

## Properties

bool | clip_contents | true (overrides Control)
bool | connection_lines_antialiased | true
float | connection_lines_curvature | 0.5
float | connection_lines_thickness | 4.0
Array[Dictionary] | connections | []
FocusMode | focus_mode | 2 (overrides Control)
GridPattern | grid_pattern | 0
bool | minimap_enabled | true
float | minimap_opacity | 0.65
Vector2 | minimap_size | Vector2(240, 160)
PanningScheme | panning_scheme | 0
bool | right_disconnects | false
Vector2 | scroll_offset | Vector2(0, 0)
bool | show_arrange_button | true
bool | show_grid | true
bool | show_grid_buttons | true
bool | show_menu | true
bool | show_minimap_button | true
bool | show_zoom_buttons | true
bool | show_zoom_label | false
int | snapping_distance | 20
bool | snapping_enabled | true
Dictionary | type_names | {}
float | zoom | 1.0
float | zoom_max | 2.0736003
float | zoom_min | 0.23256795
float | zoom_step | 1.2

## Methods

PackedVector2Array | _get_connection_line(from_position: Vector2, to_position: Vector2) virtual const
bool | _is_in_input_hotzone(in_node: Object, in_port: int, mouse_position: Vector2) virtual
bool | _is_in_output_hotzone(in_node: Object, in_port: int, mouse_position: Vector2) virtual
bool | _is_node_hover_valid(from_node: StringName, from_port: int, to_node: StringName, to_port: int) virtual
void | add_valid_connection_type(from_type: int, to_type: int)
void | add_valid_left_disconnect_type(type: int)
void | add_valid_right_disconnect_type(type: int)
void | arrange_nodes()
void | attach_graph_element_to_frame(element: StringName, frame: StringName)
void | clear_connections()
Error | connect_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int, keep_alive: bool = false)
void | detach_graph_element_from_frame(element: StringName)
void | disconnect_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int)
void | force_connection_drag_end()
Array[StringName] | get_attached_nodes_of_frame(frame: StringName)
Dictionary | get_closest_connection_at_point(point: Vector2, max_distance: float = 4.0) const
int | get_connection_count(from_node: StringName, from_port: int)
PackedVector2Array | get_connection_line(from_node: Vector2, to_node: Vector2) const
Array[Dictionary] | get_connection_list_from_node(node: StringName) const
Array[Dictionary] | get_connections_intersecting_with_rect(rect: Rect2) const
GraphFrame | get_element_frame(element: StringName)
HBoxContainer | get_menu_hbox()
bool | is_node_connected(from_node: StringName, from_port: int, to_node: StringName, to_port: int)
bool | is_valid_connection_type(from_type: int, to_type: int) const
void | remove_valid_connection_type(from_type: int, to_type: int)
void | remove_valid_left_disconnect_type(type: int)
void | remove_valid_right_disconnect_type(type: int)
void | set_connection_activity(from_node: StringName, from_port: int, to_node: StringName, to_port: int, amount: float)
void | set_selected(node: Node)

## Theme Properties

Color | activity | Color(1, 1, 1, 1)
Color | connection_hover_tint_color | Color(0, 0, 0, 0.3)
Color | connection_rim_color | Color(0.1, 0.1, 0.1, 0.6)
Color | connection_valid_target_tint_color | Color(1, 1, 1, 0.4)
Color | grid_major | Color(1, 1, 1, 0.2)
Color | grid_minor | Color(1, 1, 1, 0.05)
Color | selection_fill | Color(1, 1, 1, 0.3)
Color | selection_stroke | Color(1, 1, 1, 0.8)
int | connection_hover_thickness | 0
int | port_hotzone_inner_extent | 22
int | port_hotzone_outer_extent | 26
Texture2D | grid_toggle |
Texture2D | layout |
Texture2D | minimap_toggle |
Texture2D | snapping_toggle |
Texture2D | zoom_in |
Texture2D | zoom_out |
Texture2D | zoom_reset |
StyleBox | menu_panel |
StyleBox | panel |
StyleBox | panel_focus |

---

## Signals

begin_node_move() 

Emitted at the beginning of a GraphElement's movement.

---

connection_drag_ended() 

Emitted at the end of a connection drag.

---

connection_drag_started(from_node: StringName, from_port: int, is_output: bool) 

Emitted at the beginning of a connection drag.

---

connection_from_empty(to_node: StringName, to_port: int, release_position: Vector2) 

Emitted when user drags a connection from an input port into the empty space of the graph.

---

connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) 

Emitted to the GraphEdit when the connection between the from_port of the from_node GraphNode and the to_port of the to_node GraphNode is attempted to be created.

---

connection_to_empty(from_node: StringName, from_port: int, release_position: Vector2) 

Emitted when user drags a connection from an output port into the empty space of the graph.

---

copy_nodes_request() 

Emitted when this GraphEdit captures a ui_copy action (Ctrl + C by default). In general, this signal indicates that the selected GraphElements should be copied.

---

cut_nodes_request() 

Emitted when this GraphEdit captures a ui_cut action (Ctrl + X by default). In general, this signal indicates that the selected GraphElements should be cut.

---

delete_nodes_request(nodes: Array[StringName]) 

Emitted when this GraphEdit captures a ui_graph_delete action (Delete by default).

nodes is an array of node names that should be removed. These usually include all selected nodes.

---

disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) 

Emitted to the GraphEdit when the connection between from_port of from_node GraphNode and to_port of to_node GraphNode is attempted to be removed.

---

duplicate_nodes_request() 

Emitted when this GraphEdit captures a ui_graph_duplicate action (Ctrl + D by default). In general, this signal indicates that the selected GraphElements should be duplicated.

---

end_node_move() 

Emitted at the end of a GraphElement's movement.

---

frame_rect_changed(frame: GraphFrame, new_rect: Rect2) 

Emitted when the GraphFrame frame is resized to new_rect.

---

graph_elements_linked_to_frame_request(elements: Array, frame: StringName) 

Emitted when one or more GraphElements are dropped onto the GraphFrame named frame, when they were not previously attached to any other one.

elements is an array of GraphElements to be attached.

---

node_deselected(node: Node) 

Emitted when the given GraphElement node is deselected.

---

node_selected(node: Node) 

Emitted when the given GraphElement node is selected.

---

paste_nodes_request() 

Emitted when this GraphEdit captures a ui_paste action (Ctrl + V by default). In general, this signal indicates that previously copied GraphElements should be pasted.

---

popup_request(at_position: Vector2) 

Emitted when a popup is requested. Happens on right-clicking in the GraphEdit. at_position is the position of the mouse pointer when the signal is sent.

---

scroll_offset_changed(offset: Vector2) 

Emitted when the scroll offset is changed by the user. It will not be emitted when changed in code.

---

## Enumerations

enum PanningScheme
PanningScheme SCROLL_ZOOMS = 0

Mouse Wheel will zoom, Ctrl + Mouse Wheel will move the view.

PanningScheme SCROLL_PANS = 1

Mouse Wheel will move the view, Ctrl + Mouse Wheel will zoom.

---

enum GridPattern
GridPattern GRID_PATTERN_LINES = 0

Draw the grid using solid lines.

GridPattern GRID_PATTERN_DOTS = 1

Draw the grid using dots.

---

## Property Descriptions

bool connection_lines_antialiased = true 

- void set_connection_lines_antialiased(value: bool)
- bool is_connection_lines_antialiased()

If true, the lines between nodes will use antialiasing.

---

float connection_lines_curvature = 0.5 

- void set_connection_lines_curvature(value: float)
- float get_connection_lines_curvature()

The curvature of the lines between the nodes. 0 results in straight lines.

---

float connection_lines_thickness = 4.0 

- void set_connection_lines_thickness(value: float)
- float get_connection_lines_thickness()

The thickness of the lines between the nodes.

---

Array[Dictionary] connections = [] 

- void set_connections(value: Array[Dictionary])
- Array[Dictionary] get_connection_list()

The connections between GraphNodes.

A connection is represented as a Dictionary in the form of:

```gdscript
{
    from_node: StringName,
    from_port: int,
    to_node: StringName,
    to_port: int,
    keep_alive: bool
}
```

Connections with keep_alive set to false may be deleted automatically if invalid during a redraw.

---

GridPattern grid_pattern = 0 

- void set_grid_pattern(value: GridPattern)
- GridPattern get_grid_pattern()

The pattern used for drawing the grid.

---

bool minimap_enabled = true 

- void set_minimap_enabled(value: bool)
- bool is_minimap_enabled()

If true, the minimap is visible.

---

float minimap_opacity = 0.65 

- void set_minimap_opacity(value: float)
- float get_minimap_opacity()

The opacity of the minimap rectangle.

---

Vector2 minimap_size = Vector2(240, 160) 

- void set_minimap_size(value: Vector2)
- Vector2 get_minimap_size()

The size of the minimap rectangle. The map itself is based on the size of the grid area and is scaled to fit this rectangle.

---

PanningScheme panning_scheme = 0 

- void set_panning_scheme(value: PanningScheme)
- PanningScheme get_panning_scheme()

Defines the control scheme for panning with mouse wheel.

---

bool right_disconnects = false 

- void set_right_disconnects(value: bool)
- bool is_right_disconnects_enabled()

If true, enables disconnection of existing connections in the GraphEdit by dragging the right end.

---

Vector2 scroll_offset = Vector2(0, 0) 

- void set_scroll_offset(value: Vector2)
- Vector2 get_scroll_offset()

The scroll offset.

---

bool show_arrange_button = true 

- void set_show_arrange_button(value: bool)
- bool is_showing_arrange_button()

If true, the button to automatically arrange graph nodes is visible.

---

bool show_grid = true 

- void set_show_grid(value: bool)
- bool is_showing_grid()

If true, the grid is visible.

---

bool show_grid_buttons = true 

- void set_show_grid_buttons(value: bool)
- bool is_showing_grid_buttons()

If true, buttons that allow to configure grid and snapping options are visible.

---

bool show_menu = true 

- void set_show_menu(value: bool)
- bool is_showing_menu()

If true, the menu toolbar is visible.

---

bool show_minimap_button = true 

- void set_show_minimap_button(value: bool)
- bool is_showing_minimap_button()

If true, the button to toggle the minimap is visible.

---

bool show_zoom_buttons = true 

- void set_show_zoom_buttons(value: bool)
- bool is_showing_zoom_buttons()

If true, buttons that allow to change and reset the zoom level are visible.

---

bool show_zoom_label = false 

- void set_show_zoom_label(value: bool)
- bool is_showing_zoom_label()

If true, the label with the current zoom level is visible. The zoom level is displayed in percents.

---

int snapping_distance = 20 

- void set_snapping_distance(value: int)
- int get_snapping_distance()

The snapping distance in pixels, also determines the grid line distance.

---

bool snapping_enabled = true 

- void set_snapping_enabled(value: bool)
- bool is_snapping_enabled()

If true, enables snapping.

---

Dictionary type_names = {} 

- void set_type_names(value: Dictionary)
- Dictionary get_type_names()

Dictionary of human-readable port type names.

---

float zoom = 1.0 

- void set_zoom(value: float)
- float get_zoom()

The current zoom value.

---

float zoom_max = 2.0736003 

- void set_zoom_max(value: float)
- float get_zoom_max()

The upper zoom limit.

---

float zoom_min = 0.23256795 

- void set_zoom_min(value: float)
- float get_zoom_min()

The lower zoom limit.

---

float zoom_step = 1.2 

- void set_zoom_step(value: float)
- float get_zoom_step()

The step of each zoom level.

---

## Method Descriptions

PackedVector2Array _get_connection_line(from_position: Vector2, to_position: Vector2) virtual const 

Virtual method which can be overridden to customize how connections are drawn.

---

bool _is_in_input_hotzone(in_node: Object, in_port: int, mouse_position: Vector2) virtual 

Returns whether the mouse_position is in the input hot zone.

By default, a hot zone is a Rect2 positioned such that its center is at in_node.GraphNode.get_input_port_position()(in_port) (For output's case, call GraphNode.get_output_port_position() instead). The hot zone's width is twice the Theme Property port_grab_distance_horizontal, and its height is twice the port_grab_distance_vertical.

Below is a sample code to help get started:

```gdscript
func _is_in_input_hotzone(in_node, in_port, mouse_position):
    var port_size = Vector2(get_theme_constant("port_grab_distance_horizontal"), get_theme_constant("port_grab_distance_vertical"))
    var port_pos = in_node.get_position() + in_node.get_input_port_position(in_port) - port_size / 2
    var rect = Rect2(port_pos, port_size)
    return rect.has_point(mouse_position)
```

---

bool _is_in_output_hotzone(in_node: Object, in_port: int, mouse_position: Vector2) virtual 

Returns whether the mouse_position is in the output hot zone. For more information on hot zones, see _is_in_input_hotzone().

Below is a sample code to help get started:

```gdscript
func _is_in_output_hotzone(in_node, in_port, mouse_position):
    var port_size = Vector2(get_theme_constant("port_grab_distance_horizontal"), get_theme_constant("port_grab_distance_vertical"))
    var port_pos = in_node.get_position() + in_node.get_output_port_position(in_port) - port_size / 2
    var rect = Rect2(port_pos, port_size)
    return rect.has_point(mouse_position)
```

---

bool _is_node_hover_valid(from_node: StringName, from_port: int, to_node: StringName, to_port: int) virtual 

This virtual method can be used to insert additional error detection while the user is dragging a connection over a valid port.

Return true if the connection is indeed valid or return false if the connection is impossible. If the connection is impossible, no snapping to the port and thus no connection request to that port will happen.

In this example a connection to same node is suppressed:

```
func _is_node_hover_valid(from, from_port, to, to_port):
    return from != to
```

```
public override bool _IsNodeHoverValid(StringName fromNode, int fromPort, StringName toNode, int toPort)
{
    return fromNode != toNode;
}
```

---

void add_valid_connection_type(from_type: int, to_type: int) 

Allows the connection between two different port types. The port type is defined individually for the left and the right port of each slot with the GraphNode.set_slot() method.

See also is_valid_connection_type() and remove_valid_connection_type().

---

void add_valid_left_disconnect_type(type: int) 

Allows to disconnect nodes when dragging from the left port of the GraphNode's slot if it has the specified type. See also remove_valid_left_disconnect_type().

---

void add_valid_right_disconnect_type(type: int) 

Allows to disconnect nodes when dragging from the right port of the GraphNode's slot if it has the specified type. See also remove_valid_right_disconnect_type().

---

void arrange_nodes() 

Rearranges selected nodes in a layout with minimum crossings between connections and uniform horizontal and vertical gap between nodes.

---

void attach_graph_element_to_frame(element: StringName, frame: StringName) 

Attaches the element GraphElement to the frame GraphFrame.

---

void clear_connections() 

Removes all connections between nodes.

---

Error connect_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int, keep_alive: bool = false) 

Create a connection between the from_port of the from_node GraphNode and the to_port of the to_node GraphNode. If the connection already exists, no connection is created.

Connections with keep_alive set to false may be deleted automatically if invalid during a redraw.

---

void detach_graph_element_from_frame(element: StringName) 

Detaches the element GraphElement from the GraphFrame it is currently attached to.

---

void disconnect_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int) 

Removes the connection between the from_port of the from_node GraphNode and the to_port of the to_node GraphNode. If the connection does not exist, no connection is removed.

---

void force_connection_drag_end() 

Ends the creation of the current connection. In other words, if you are dragging a connection you can use this method to abort the process and remove the line that followed your cursor.

This is best used together with connection_drag_started and connection_drag_ended to add custom behavior like node addition through shortcuts.

Note: This method suppresses any other connection request signals apart from connection_drag_ended.

---

Array[StringName] get_attached_nodes_of_frame(frame: StringName) 

Returns an array of node names that are attached to the GraphFrame with the given name.

---

Dictionary get_closest_connection_at_point(point: Vector2, max_distance: float = 4.0) const 

Returns the closest connection to the given point in screen space. If no connection is found within max_distance pixels, an empty Dictionary is returned.

A connection is represented as a Dictionary in the form of:

```gdscript
{
    from_node: StringName,
    from_port: int,
    to_node: StringName,
    to_port: int,
    keep_alive: bool
}
```

For example, getting a connection at a given mouse position can be achieved like this:

```
var connection = get_closest_connection_at_point(mouse_event.get_position())
```

---

int get_connection_count(from_node: StringName, from_port: int) 

Returns the number of connections from from_port of from_node.

---

PackedVector2Array get_connection_line(from_node: Vector2, to_node: Vector2) const 

Returns the points which would make up a connection between from_node and to_node.

---

Array[Dictionary] get_connection_list_from_node(node: StringName) const 

Returns an Array containing a list of all connections for node.

A connection is represented as a Dictionary in the form of:

```gdscript
{
    from_node: StringName,
    from_port: int,
    to_node: StringName,
    to_port: int,
    keep_alive: bool
}
```

Example: Get all connections on a specific port:

```gdscript
func get_connection_list_from_port(node, port):
    var connections = get_connection_list_from_node(node)
    var result = []
    for connection in connections:
        var dict = {}
        if connection["from_node"] == node and connection["from_port"] == port:
            dict["node"] = connection["to_node"]
            dict["port"] = connection["to_port"]
            dict["type"] = "left"
            result.push_back(dict)
        elif connection["to_node"] == node and connection["to_port"] == port:
            dict["node"] = connection["from_node"]
            dict["port"] = connection["from_port"]
            dict["type"] = "right"
            result.push_back(dict)
    return result
```

---

Array[Dictionary] get_connections_intersecting_with_rect(rect: Rect2) const 

Returns an Array containing the list of connections that intersect with the given Rect2.

A connection is represented as a Dictionary in the form of:

```gdscript
{
    from_node: StringName,
    from_port: int,
    to_node: StringName,
    to_port: int,
    keep_alive: bool
}
```

---

GraphFrame get_element_frame(element: StringName) 

Returns the GraphFrame that contains the GraphElement with the given name.

---

HBoxContainer get_menu_hbox() 

Gets the HBoxContainer that contains the zooming and grid snap controls in the top left of the graph. You can use this method to reposition the toolbar or to add your own custom controls to it.

Warning: This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their CanvasItem.visible property.

---

bool is_node_connected(from_node: StringName, from_port: int, to_node: StringName, to_port: int) 

Returns true if the from_port of the from_node GraphNode is connected to the to_port of the to_node GraphNode.

---

bool is_valid_connection_type(from_type: int, to_type: int) const 

Returns whether it's possible to make a connection between two different port types. The port type is defined individually for the left and the right port of each slot with the GraphNode.set_slot() method.

See also add_valid_connection_type() and remove_valid_connection_type().

---

void remove_valid_connection_type(from_type: int, to_type: int) 

Disallows the connection between two different port types previously allowed by add_valid_connection_type(). The port type is defined individually for the left and the right port of each slot with the GraphNode.set_slot() method.

See also is_valid_connection_type().

---

void remove_valid_left_disconnect_type(type: int) 

Disallows to disconnect nodes when dragging from the left port of the GraphNode's slot if it has the specified type. Use this to disable a disconnection previously allowed with add_valid_left_disconnect_type().

---

void remove_valid_right_disconnect_type(type: int) 

Disallows to disconnect nodes when dragging from the right port of the GraphNode's slot if it has the specified type. Use this to disable a disconnection previously allowed with add_valid_right_disconnect_type().

---

void set_connection_activity(from_node: StringName, from_port: int, to_node: StringName, to_port: int, amount: float) 

Sets the coloration of the connection between from_node's from_port and to_node's to_port with the color provided in the activity theme property. The color is linearly interpolated between the connection color and the activity color using amount as weight.

---

void set_selected(node: Node) 

Sets the specified node as the one selected.

---

## Theme Property Descriptions

Color activity = Color(1, 1, 1, 1) 

Color the connection line is interpolated to based on the activity value of a connection (see set_connection_activity()).

---

Color connection_hover_tint_color = Color(0, 0, 0, 0.3) 

Color which is blended with the connection line when the mouse is hovering over it.

---

Color connection_rim_color = Color(0.1, 0.1, 0.1, 0.6) 

Color of the rim around each connection line used for making intersecting lines more distinguishable.

---

Color connection_valid_target_tint_color = Color(1, 1, 1, 0.4) 

Color which is blended with the connection line when the currently dragged connection is hovering over a valid target port.

---

Color grid_major = Color(1, 1, 1, 0.2) 

Color of major grid lines/dots.

---

Color grid_minor = Color(1, 1, 1, 0.05) 

Color of minor grid lines/dots.

---

Color selection_fill = Color(1, 1, 1, 0.3) 

The fill color of the selection rectangle.

---

Color selection_stroke = Color(1, 1, 1, 0.8) 

The outline color of the selection rectangle.

---

int connection_hover_thickness = 0 

Widens the line of a connection when the mouse is hovering over it by a percentage factor. A value of 0 disables the highlight. A value of 100 doubles the line width.

---

int port_hotzone_inner_extent = 22 

The horizontal range within which a port can be grabbed (inner side).

---

int port_hotzone_outer_extent = 26 

The horizontal range within which a port can be grabbed (outer side).

---

Texture2D grid_toggle 

The icon for the grid toggle button.

---

Texture2D layout 

The icon for the layout button for auto-arranging the graph.

---

Texture2D minimap_toggle 

The icon for the minimap toggle button.

---

Texture2D snapping_toggle 

The icon for the snapping toggle button.

---

Texture2D zoom_in 

The icon for the zoom in button.

---

Texture2D zoom_out 

The icon for the zoom out button.

---

Texture2D zoom_reset 

The icon for the zoom reset button.

---

StyleBox menu_panel 

There is currently no description for this theme property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

StyleBox panel 

The background drawn under the grid.

---

StyleBox panel_focus 

StyleBox used when the GraphEdit is focused (when used with assistive apps).
