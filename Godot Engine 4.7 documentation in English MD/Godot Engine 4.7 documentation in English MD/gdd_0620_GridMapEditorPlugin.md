# GridMapEditorPlugin

Inherits: EditorPlugin < Node < Object

Editor for GridMap nodes.

## Description

GridMapEditorPlugin provides access to the GridMap editor functionality.

## Methods

void | clear_selection()
GridMap | get_current_grid_map() const
Array | get_selected_cells() const
int | get_selected_palette_item() const
AABB | get_selection() const
bool | has_selection() const
void | set_selected_palette_item(item: int) const
void | set_selection(begin: Vector3i, end: Vector3i)

---

## Method Descriptions

void clear_selection() 

Deselects any currently selected cells.

---

GridMap get_current_grid_map() const 

Returns the GridMap node currently edited by the grid map editor.

---

Array get_selected_cells() const 

Returns an array of Vector3is with the selected cells' coordinates.

---

int get_selected_palette_item() const 

Returns the index of the selected MeshLibrary item in the grid map editor's palette or -1 if no item is selected.

Note: The indices might not be in the same order as they appear in the editor's interface.

---

AABB get_selection() const 

Returns the cell coordinate bounds of the current selection. Use has_selection() to check if there is an active selection.

---

bool has_selection() const 

Returns true if there are selected cells.

---

void set_selected_palette_item(item: int) const 

Selects the MeshLibrary item with the given index in the grid map editor's palette. If a negative index is given, no item will be selected. If a value greater than the last index is given, the last item will be selected.

Note: The indices might not be in the same order as they appear in the editor's interface.

---

void set_selection(begin: Vector3i, end: Vector3i) 

Selects the cells inside the given bounds from begin to end.
