# GraphElement

Inherits: Container < Control < CanvasItem < Node < Object

Inherited By: GraphFrame, GraphNode

A container that represents a basic element that can be placed inside a GraphEdit control.

## Description

GraphElement allows to create custom elements for a GraphEdit graph. By default such elements can be selected, resized, and repositioned, but they cannot be connected. For a graph element that allows for connections see GraphNode.

## Properties

bool | draggable | true
Vector2 | position_offset | Vector2(0, 0)
bool | resizable | false
bool | scaling_menus | false
bool | selectable | true
bool | selected | false

## Theme Properties

Texture2D | resizer

---

## Signals

delete_request() 

Emitted when removing the GraphElement is requested.

---

dragged(from: Vector2, to: Vector2) 

Emitted when the GraphElement is dragged.

---

node_deselected() 

Emitted when the GraphElement is deselected.

---

node_selected() 

Emitted when the GraphElement is selected.

---

position_offset_changed() 

Emitted when the GraphElement is moved.

---

raise_request() 

Emitted when displaying the GraphElement over other ones is requested. Happens on focusing (clicking into) the GraphElement.

---

resize_end(new_size: Vector2) 

Emitted when releasing the mouse button after dragging the resizer handle (see resizable).

---

resize_request(new_size: Vector2) 

Emitted when resizing the GraphElement is requested. Happens on dragging the resizer handle (see resizable).

---

## Property Descriptions

bool draggable = true 

- void set_draggable(value: bool)
- bool is_draggable()

If true, the user can drag the GraphElement.

---

Vector2 position_offset = Vector2(0, 0) 

- void set_position_offset(value: Vector2)
- Vector2 get_position_offset()

The offset of the GraphElement, relative to the scroll offset of the GraphEdit.

---

bool resizable = false 

- void set_resizable(value: bool)
- bool is_resizable()

If true, the user can resize the GraphElement.

Note: Dragging the handle will only emit the resize_request and resize_end signals, the GraphElement needs to be resized manually.

---

bool scaling_menus = false 

- void set_scaling_menus(value: bool)
- bool is_scaling_menus()

If true, PopupMenus that are descendants of the GraphElement are scaled with the GraphEdit zoom.

---

bool selectable = true 

- void set_selectable(value: bool)
- bool is_selectable()

If true, the user can select the GraphElement.

---

bool selected = false 

- void set_selected(value: bool)
- bool is_selected()

If true, the GraphElement is selected.

---

## Theme Property Descriptions

Texture2D resizer 

The icon used for the resizer, visible when resizable is enabled.
