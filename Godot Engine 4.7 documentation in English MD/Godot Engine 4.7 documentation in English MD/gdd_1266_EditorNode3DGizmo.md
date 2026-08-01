# EditorNode3DGizmo

Inherits: Node3DGizmo < RefCounted < Object

Gizmo for editing Node3D objects.

## Description

Gizmo that is used for providing custom visualization and editing (handles and subgizmos) for Node3D objects. Can be overridden to create custom gizmos, but for simple gizmos creating an EditorNode3DGizmoPlugin is usually recommended.

## Methods

void | _begin_handle_action(id: int, secondary: bool) virtual
void | _commit_handle(id: int, secondary: bool, restore: Variant, cancel: bool) virtual
void | _commit_subgizmos(ids: PackedInt32Array, restores: Array[Transform3D], cancel: bool) virtual
String | _get_handle_name(id: int, secondary: bool) virtual const
Variant | _get_handle_value(id: int, secondary: bool) virtual const
Transform3D | _get_subgizmo_transform(id: int) virtual const
bool | _is_handle_highlighted(id: int, secondary: bool) virtual const
void | _redraw() virtual
void | _set_handle(id: int, secondary: bool, camera: Camera3D, point: Vector2) virtual
void | _set_subgizmo_transform(id: int, transform: Transform3D) virtual
PackedInt32Array | _subgizmos_intersect_frustum(camera: Camera3D, frustum: Array[Plane]) virtual const
int | _subgizmos_intersect_ray(camera: Camera3D, point: Vector2) virtual const
void | add_collision_segments(segments: PackedVector3Array)
void | add_collision_triangles(triangles: TriangleMesh)
void | add_handles(handles: PackedVector3Array, material: Material, ids: PackedInt32Array, billboard: bool = false, secondary: bool = false)
void | add_lines(lines: PackedVector3Array, material: Material, billboard: bool = false, modulate: Color = Color(1, 1, 1, 1))
void | add_mesh(mesh: Mesh, material: Material = null, transform: Transform3D = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0), skeleton: SkinReference = null)
void | add_unscaled_billboard(material: Material, default_scale: float = 1, modulate: Color = Color(1, 1, 1, 1))
void | clear()
Node3D | get_node_3d() const
EditorNode3DGizmoPlugin | get_plugin() const
PackedInt32Array | get_subgizmo_selection() const
bool | is_subgizmo_selected(id: int) const
void | set_hidden(hidden: bool)
void | set_node_3d(node: Node)

---

## Method Descriptions

void _begin_handle_action(id: int, secondary: bool) virtual 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _commit_handle(id: int, secondary: bool, restore: Variant, cancel: bool) virtual 

Override this method to commit a handle being edited (handles must have been previously added by add_handles()). This usually means creating an UndoRedo action for the change, using the current handle value as "do" and the restore argument as "undo".

If the cancel argument is true, the restore value should be directly set, without any UndoRedo action.

The secondary argument is true when the committed handle is secondary (see add_handles() for more information).

---

void _commit_subgizmos(ids: PackedInt32Array, restores: Array[Transform3D], cancel: bool) virtual 

Override this method to commit a group of subgizmos being edited (see _subgizmos_intersect_ray() and _subgizmos_intersect_frustum()). This usually means creating an UndoRedo action for the change, using the current transforms as "do" and the restores transforms as "undo".

If the cancel argument is true, the restores transforms should be directly set, without any UndoRedo action.

---

String _get_handle_name(id: int, secondary: bool) virtual const 

Override this method to return the name of an edited handle (handles must have been previously added by add_handles()). Handles can be named for reference to the user when editing.

The secondary argument is true when the requested handle is secondary (see add_handles() for more information).

---

Variant _get_handle_value(id: int, secondary: bool) virtual const 

Override this method to return the current value of a handle. This value will be requested at the start of an edit and used as the restore argument in _commit_handle().

The secondary argument is true when the requested handle is secondary (see add_handles() for more information).

---

Transform3D _get_subgizmo_transform(id: int) virtual const 

Override this method to return the current transform of a subgizmo. This transform will be requested at the start of an edit and used as the restore argument in _commit_subgizmos().

---

bool _is_handle_highlighted(id: int, secondary: bool) virtual const 

Override this method to return true whenever the given handle should be highlighted in the editor.

The secondary argument is true when the requested handle is secondary (see add_handles() for more information).

---

void _redraw() virtual 

Override this method to add all the gizmo elements whenever a gizmo update is requested. It's common to call clear() at the beginning of this method and then add visual elements depending on the node's properties.

---

void _set_handle(id: int, secondary: bool, camera: Camera3D, point: Vector2) virtual 

Override this method to update the node properties when the user drags a gizmo handle (previously added with add_handles()). The provided point is the mouse position in screen coordinates and the camera can be used to convert it to raycasts.

The secondary argument is true when the edited handle is secondary (see add_handles() for more information).

---

void _set_subgizmo_transform(id: int, transform: Transform3D) virtual 

Override this method to update the node properties during subgizmo editing (see _subgizmos_intersect_ray() and _subgizmos_intersect_frustum()). The transform is given in the Node3D's local coordinate system.

---

PackedInt32Array _subgizmos_intersect_frustum(camera: Camera3D, frustum: Array[Plane]) virtual const 

Override this method to allow selecting subgizmos using mouse drag box selection. Given a camera and a frustum, this method should return which subgizmos are contained within the frustum. The frustum argument consists of an array with all the Planes that make up the selection frustum. The returned value should contain a list of unique subgizmo identifiers, which can have any non-negative value and will be used in other virtual methods like _get_subgizmo_transform() or _commit_subgizmos().

---

int _subgizmos_intersect_ray(camera: Camera3D, point: Vector2) virtual const 

Override this method to allow selecting subgizmos using mouse clicks. Given a camera and a point in screen coordinates, this method should return which subgizmo should be selected. The returned value should be a unique subgizmo identifier, which can have any non-negative value and will be used in other virtual methods like _get_subgizmo_transform() or _commit_subgizmos().

---

void add_collision_segments(segments: PackedVector3Array) 

Adds the specified segments to the gizmo's collision shape for picking. Call this method during _redraw().

---

void add_collision_triangles(triangles: TriangleMesh) 

Adds collision triangles to the gizmo for picking. A TriangleMesh can be generated from a regular Mesh too. Call this method during _redraw().

---

void add_handles(handles: PackedVector3Array, material: Material, ids: PackedInt32Array, billboard: bool = false, secondary: bool = false) 

Adds a list of handles (points) which can be used to edit the properties of the gizmo's Node3D. The ids argument can be used to specify a custom identifier for each handle, if an empty array is passed, the ids will be assigned automatically from the handles argument order.

The secondary argument marks the added handles as secondary, meaning they will normally have lower selection priority than regular handles. When the user is holding the shift key secondary handles will switch to have higher priority than regular handles. This change in priority can be used to place multiple handles at the same point while still giving the user control on their selection.

There are virtual methods which will be called upon editing of these handles. Call this method during _redraw().

---

void add_lines(lines: PackedVector3Array, material: Material, billboard: bool = false, modulate: Color = Color(1, 1, 1, 1)) 

Adds lines to the gizmo (as sets of 2 points), with a given material. The lines are used for visualizing the gizmo. Call this method during _redraw().

---

void add_mesh(mesh: Mesh, material: Material = null, transform: Transform3D = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0), skeleton: SkinReference = null) 

Adds a mesh to the gizmo with the specified material, local transform and skeleton. Call this method during _redraw().

---

void add_unscaled_billboard(material: Material, default_scale: float = 1, modulate: Color = Color(1, 1, 1, 1)) 

Adds an unscaled billboard for visualization and selection. Call this method during _redraw().

---

void clear() 

Removes everything in the gizmo including meshes, collisions and handles.

---

Node3D get_node_3d() const 

Returns the Node3D node associated with this gizmo.

---

EditorNode3DGizmoPlugin get_plugin() const 

Returns the EditorNode3DGizmoPlugin that owns this gizmo. It's useful to retrieve materials using EditorNode3DGizmoPlugin.get_material().

---

PackedInt32Array get_subgizmo_selection() const 

Returns a list of the currently selected subgizmos. Can be used to highlight selected elements during _redraw().

---

bool is_subgizmo_selected(id: int) const 

Returns true if the given subgizmo is currently selected. Can be used to highlight selected elements during _redraw().

---

void set_hidden(hidden: bool) 

Sets the gizmo's hidden state. If true, the gizmo will be hidden. If false, it will be shown.

---

void set_node_3d(node: Node) 

Sets the reference Node3D node for the gizmo. node must inherit from Node3D.
