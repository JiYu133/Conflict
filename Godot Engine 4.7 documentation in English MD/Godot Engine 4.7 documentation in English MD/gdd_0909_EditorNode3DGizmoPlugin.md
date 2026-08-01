# EditorNode3DGizmoPlugin

Inherits: Resource < RefCounted < Object

A class used by the editor to define Node3D gizmo types.

## Description

EditorNode3DGizmoPlugin allows you to define a new type of Gizmo. There are two main ways to do so: extending EditorNode3DGizmoPlugin for the simpler gizmos, or creating a new EditorNode3DGizmo type. See the tutorial in the documentation for more info.

To use EditorNode3DGizmoPlugin, register it using the EditorPlugin.add_node_3d_gizmo_plugin() method first.

## Tutorials

- Node3D gizmo plugins

## Methods

void | _begin_handle_action(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool) virtual
bool | _can_be_hidden() virtual const
bool | _can_commit_handle_on_click() virtual const
void | _commit_handle(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool, restore: Variant, cancel: bool) virtual
void | _commit_subgizmos(gizmo: EditorNode3DGizmo, ids: PackedInt32Array, restores: Array[Transform3D], cancel: bool) virtual
EditorNode3DGizmo | _create_gizmo(for_node_3d: Node3D) virtual const
String | _get_gizmo_name() virtual const
String | _get_handle_name(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool) virtual const
Variant | _get_handle_value(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool) virtual const
int | _get_priority() virtual const
Transform3D | _get_subgizmo_transform(gizmo: EditorNode3DGizmo, subgizmo_id: int) virtual const
bool | _has_gizmo(for_node_3d: Node3D) virtual const
bool | _is_handle_highlighted(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool) virtual const
bool | _is_selectable_when_hidden() virtual const
void | _redraw(gizmo: EditorNode3DGizmo) virtual
void | _set_handle(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool, camera: Camera3D, screen_pos: Vector2) virtual
void | _set_subgizmo_transform(gizmo: EditorNode3DGizmo, subgizmo_id: int, transform: Transform3D) virtual
PackedInt32Array | _subgizmos_intersect_frustum(gizmo: EditorNode3DGizmo, camera: Camera3D, frustum_planes: Array[Plane]) virtual const
int | _subgizmos_intersect_ray(gizmo: EditorNode3DGizmo, camera: Camera3D, screen_pos: Vector2) virtual const
void | add_material(name: String, material: StandardMaterial3D)
void | create_handle_material(name: String, billboard: bool = false, texture: Texture2D = null)
void | create_icon_material(name: String, texture: Texture2D, on_top: bool = false, color: Color = Color(1, 1, 1, 1))
void | create_material(name: String, color: Color, billboard: bool = false, on_top: bool = false, use_vertex_color: bool = false)
StandardMaterial3D | get_material(name: String, gizmo: EditorNode3DGizmo = null)

---

## Method Descriptions

void _begin_handle_action(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool) virtual 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _can_be_hidden() virtual const 

Override this method to define whether the gizmos handled by this plugin can be hidden or not. Returns true if not overridden.

---

bool _can_commit_handle_on_click() virtual const 

Override this method to define whether the gizmos should commit when the final handle position is the same as the initial one. Returns false if not overridden.

---

void _commit_handle(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool, restore: Variant, cancel: bool) virtual 

Override this method to commit a handle being edited (handles must have been previously added by EditorNode3DGizmo.add_handles() during _redraw()). This usually means creating an UndoRedo action for the change, using the current handle value as "do" and the restore argument as "undo".

If the cancel argument is true, the restore value should be directly set, without any UndoRedo action.

The secondary argument is true when the committed handle is secondary (see EditorNode3DGizmo.add_handles() for more information).

Called for this plugin's active gizmos.

---

void _commit_subgizmos(gizmo: EditorNode3DGizmo, ids: PackedInt32Array, restores: Array[Transform3D], cancel: bool) virtual 

Override this method to commit a group of subgizmos being edited (see _subgizmos_intersect_ray() and _subgizmos_intersect_frustum()). This usually means creating an UndoRedo action for the change, using the current transforms as "do" and the restores transforms as "undo".

If the cancel argument is true, the restores transforms should be directly set, without any UndoRedo action. As with all subgizmo methods, transforms are given in local space respect to the gizmo's Node3D. Called for this plugin's active gizmos.

---

EditorNode3DGizmo _create_gizmo(for_node_3d: Node3D) virtual const 

Override this method to return a custom EditorNode3DGizmo for the 3D nodes of your choice, return null for the rest of nodes. See also _has_gizmo().

---

String _get_gizmo_name() virtual const 

Override this method to provide the name that will appear in the gizmo visibility menu.

---

String _get_handle_name(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool) virtual const 

Override this method to provide gizmo's handle names. The secondary argument is true when the requested handle is secondary (see EditorNode3DGizmo.add_handles() for more information). Called for this plugin's active gizmos.

---

Variant _get_handle_value(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool) virtual const 

Override this method to return the current value of a handle. This value will be requested at the start of an edit and used as the restore argument in _commit_handle().

The secondary argument is true when the requested handle is secondary (see EditorNode3DGizmo.add_handles() for more information).

Called for this plugin's active gizmos.

---

int _get_priority() virtual const 

Override this method to set the gizmo's priority. Gizmos with higher priority will have precedence when processing inputs like handles or subgizmos selection.

All built-in editor gizmos return a priority of -1. If not overridden, this method will return 0, which means custom gizmos will automatically get higher priority than built-in gizmos.

---

Transform3D _get_subgizmo_transform(gizmo: EditorNode3DGizmo, subgizmo_id: int) virtual const 

Override this method to return the current transform of a subgizmo. As with all subgizmo methods, the transform should be in local space respect to the gizmo's Node3D. This transform will be requested at the start of an edit and used in the restore argument in _commit_subgizmos(). Called for this plugin's active gizmos.

---

bool _has_gizmo(for_node_3d: Node3D) virtual const 

Override this method to define which Node3D nodes have a gizmo from this plugin. Whenever a Node3D node is added to a scene this method is called, if it returns true the node gets a generic EditorNode3DGizmo assigned and is added to this plugin's list of active gizmos.

---

bool _is_handle_highlighted(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool) virtual const 

Override this method to return true whenever to given handle should be highlighted in the editor. The secondary argument is true when the requested handle is secondary (see EditorNode3DGizmo.add_handles() for more information). Called for this plugin's active gizmos.

---

bool _is_selectable_when_hidden() virtual const 

Override this method to define whether Node3D with this gizmo should be selectable even when the gizmo is hidden.

---

void _redraw(gizmo: EditorNode3DGizmo) virtual 

Override this method to add all the gizmo elements whenever a gizmo update is requested. It's common to call EditorNode3DGizmo.clear() at the beginning of this method and then add visual elements depending on the node's properties.

---

void _set_handle(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool, camera: Camera3D, screen_pos: Vector2) virtual 

Override this method to update the node's properties when the user drags a gizmo handle (previously added with EditorNode3DGizmo.add_handles()). The provided screen_pos is the mouse position in screen coordinates and the camera can be used to convert it to raycasts.

The secondary argument is true when the edited handle is secondary (see EditorNode3DGizmo.add_handles() for more information).

Called for this plugin's active gizmos.

---

void _set_subgizmo_transform(gizmo: EditorNode3DGizmo, subgizmo_id: int, transform: Transform3D) virtual 

Override this method to update the node properties during subgizmo editing (see _subgizmos_intersect_ray() and _subgizmos_intersect_frustum()). The transform is given in the Node3D's local coordinate system. Called for this plugin's active gizmos.

---

PackedInt32Array _subgizmos_intersect_frustum(gizmo: EditorNode3DGizmo, camera: Camera3D, frustum_planes: Array[Plane]) virtual const 

Override this method to allow selecting subgizmos using mouse drag box selection. Given a camera and frustum_planes, this method should return which subgizmos are contained within the frustums. The frustum_planes argument consists of an array with all the Planes that make up the selection frustum. The returned value should contain a list of unique subgizmo identifiers, these identifiers can have any non-negative value and will be used in other virtual methods like _get_subgizmo_transform() or _commit_subgizmos(). Called for this plugin's active gizmos.

---

int _subgizmos_intersect_ray(gizmo: EditorNode3DGizmo, camera: Camera3D, screen_pos: Vector2) virtual const 

Override this method to allow selecting subgizmos using mouse clicks. Given a camera and a screen_pos in screen coordinates, this method should return which subgizmo should be selected. The returned value should be a unique subgizmo identifier, which can have any non-negative value and will be used in other virtual methods like _get_subgizmo_transform() or _commit_subgizmos(). Called for this plugin's active gizmos.

---

void add_material(name: String, material: StandardMaterial3D) 

Adds a new material to the internal material list for the plugin. It can then be accessed with get_material(). Should not be overridden.

---

void create_handle_material(name: String, billboard: bool = false, texture: Texture2D = null) 

Creates a handle material with its variants (selected and/or editable) and adds them to the internal material list. They can then be accessed with get_material() and used in EditorNode3DGizmo.add_handles(). Should not be overridden.

You can optionally provide a texture to use instead of the default icon.

---

void create_icon_material(name: String, texture: Texture2D, on_top: bool = false, color: Color = Color(1, 1, 1, 1)) 

Creates an icon material with its variants (selected and/or editable) and adds them to the internal material list. They can then be accessed with get_material() and used in EditorNode3DGizmo.add_unscaled_billboard(). Should not be overridden.

---

void create_material(name: String, color: Color, billboard: bool = false, on_top: bool = false, use_vertex_color: bool = false) 

Creates an unshaded material with its variants (selected and/or editable) and adds them to the internal material list. They can then be accessed with get_material() and used in EditorNode3DGizmo.add_mesh() and EditorNode3DGizmo.add_lines(). Should not be overridden.

---

StandardMaterial3D get_material(name: String, gizmo: EditorNode3DGizmo = null) 

Gets material from the internal list of materials. If an EditorNode3DGizmo is provided, it will try to get the corresponding variant (selected and/or editable).
