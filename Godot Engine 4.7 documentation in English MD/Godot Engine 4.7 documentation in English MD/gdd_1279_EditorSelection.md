# EditorSelection

Inherits: Object

Manages the SceneTree selection in the editor.

## Description

This object manages the SceneTree selection in the editor.

Note: This class shouldn't be instantiated directly. Instead, access the singleton using EditorInterface.get_selection().

## Methods

void | add_node(node: Node)
void | clear()
Array[Node] | get_selected_nodes()
Array[Node] | get_top_selected_nodes()
Array[Node] | get_transformable_selected_nodes()
void | remove_node(node: Node)

---

## Signals

selection_changed() 

Emitted when the selection changes.

---

## Method Descriptions

void add_node(node: Node) 

Adds a node to the selection.

Note: The newly selected node will not be automatically edited in the inspector. If you want to edit a node, use EditorInterface.edit_node().

---

void clear() 

Clear the selection.

---

Array[Node] get_selected_nodes() 

Returns the list of selected nodes.

---

Array[Node] get_top_selected_nodes() 

Returns the list of top selected nodes only, excluding any children. This is useful for performing transform operations (moving them, rotating, etc.).

For example, if there is a node A with a child B and a sibling C, then selecting all three will cause this method to return only A and C. Changing the global transform of A will affect the global transform of B, so there is no need to change B separately.

---

Array[Node] get_transformable_selected_nodes() 

Deprecated: Use get_top_selected_nodes() instead.

Returns the list of top selected nodes only, excluding any children. This is useful for performing transform operations (moving them, rotating, etc.). See get_top_selected_nodes().

---

void remove_node(node: Node) 

Removes a node from the selection.
