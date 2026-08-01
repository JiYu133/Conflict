# SceneState

Inherits: RefCounted < Object

Provides access to a scene file's information.

## Description

Maintains a list of resources, nodes, exported and overridden properties, and built-in scripts associated with a scene. They cannot be modified from a SceneState, only accessed. Useful for peeking into what a PackedScene contains without instantiating it.

This class cannot be instantiated directly, it is retrieved for a given scene as the result of PackedScene.get_state().

## Methods

SceneState | get_base_scene_state() const
Array | get_connection_binds(idx: int) const
int | get_connection_count() const
int | get_connection_flags(idx: int) const
StringName | get_connection_method(idx: int) const
StringName | get_connection_signal(idx: int) const
NodePath | get_connection_source(idx: int) const
NodePath | get_connection_target(idx: int) const
int | get_connection_unbinds(idx: int) const
int | get_node_count() const
PackedStringArray | get_node_groups(idx: int) const
int | get_node_index(idx: int) const
PackedScene | get_node_instance(idx: int) const
String | get_node_instance_placeholder(idx: int) const
StringName | get_node_name(idx: int) const
NodePath | get_node_owner_path(idx: int) const
NodePath | get_node_path(idx: int, for_parent: bool = false) const
int | get_node_property_count(idx: int) const
StringName | get_node_property_name(idx: int, prop_idx: int) const
Variant | get_node_property_value(idx: int, prop_idx: int) const
StringName | get_node_type(idx: int) const
String | get_path() const
bool | is_node_instance_placeholder(idx: int) const

---

## Enumerations

enum GenEditState
GenEditState GEN_EDIT_STATE_DISABLED = 0

If passed to PackedScene.instantiate(), blocks edits to the scene state.

GenEditState GEN_EDIT_STATE_INSTANCE = 1

If passed to PackedScene.instantiate(), provides inherited scene resources to the local scene.

Note: Only available in editor builds.

GenEditState GEN_EDIT_STATE_MAIN = 2

If passed to PackedScene.instantiate(), provides local scene resources to the local scene. Only the main scene should receive the main edit state.

Note: Only available in editor builds.

GenEditState GEN_EDIT_STATE_MAIN_INHERITED = 3

If passed to PackedScene.instantiate(), it's similar to GEN_EDIT_STATE_MAIN, but for the case where the scene is being instantiated to be the base of another one.

Note: Only available in editor builds.

---

## Method Descriptions

SceneState get_base_scene_state() const 

Returns the SceneState of the scene that this scene inherits from, or null if it doesn't inherit from any scene.

---

Array get_connection_binds(idx: int) const 

Returns the list of bound parameters for the signal at idx.

---

int get_connection_count() const 

Returns the number of signal connections in the scene.

The idx argument used to query connection metadata in other get_connection_* methods in the interval [0, get_connection_count() - 1].

---

int get_connection_flags(idx: int) const 

Returns the connection flags for the signal at idx. See ConnectFlags constants.

---

StringName get_connection_method(idx: int) const 

Returns the method connected to the signal at idx.

---

StringName get_connection_signal(idx: int) const 

Returns the name of the signal at idx.

---

NodePath get_connection_source(idx: int) const 

Returns the path to the node that owns the signal at idx, relative to the root node.

---

NodePath get_connection_target(idx: int) const 

Returns the path to the node that owns the method connected to the signal at idx, relative to the root node.

---

int get_connection_unbinds(idx: int) const 

Returns the number of unbound parameters for the signal at idx.

---

int get_node_count() const 

Returns the number of nodes in the scene.

The idx argument used to query node data in other get_node_* methods in the interval [0, get_node_count() - 1].

---

PackedStringArray get_node_groups(idx: int) const 

Returns the list of group names associated with the node at idx.

---

int get_node_index(idx: int) const 

Returns the node's index, which is its position relative to its siblings. This is only relevant and saved in scenes for cases where new nodes are added to an instantiated or inherited scene among siblings from the base scene. Despite the name, this index is not related to the idx argument used here and in other methods.

---

PackedScene get_node_instance(idx: int) const 

Returns a PackedScene for the node at idx (i.e. the whole branch starting at this node, with its child nodes and resources), or null if the node is not an instance.

---

String get_node_instance_placeholder(idx: int) const 

Returns the path to the represented scene file if the node at idx is an InstancePlaceholder.

---

StringName get_node_name(idx: int) const 

Returns the name of the node at idx.

---

NodePath get_node_owner_path(idx: int) const 

Returns the path to the owner of the node at idx, relative to the root node.

---

NodePath get_node_path(idx: int, for_parent: bool = false) const 

Returns the path to the node at idx.

If for_parent is true, returns the path of the idx node's parent instead.

---

int get_node_property_count(idx: int) const 

Returns the number of exported or overridden properties for the node at idx.

The prop_idx argument used to query node property data in other get_node_property_* methods in the interval [0, get_node_property_count() - 1].

---

StringName get_node_property_name(idx: int, prop_idx: int) const 

Returns the name of the property at prop_idx for the node at idx.

---

Variant get_node_property_value(idx: int, prop_idx: int) const 

Returns the value of the property at prop_idx for the node at idx.

---

StringName get_node_type(idx: int) const 

Returns the type of the node at idx.

---

String get_path() const 

Returns the resource path to the represented PackedScene.

---

bool is_node_instance_placeholder(idx: int) const 

Returns true if the node at idx is an InstancePlaceholder.
