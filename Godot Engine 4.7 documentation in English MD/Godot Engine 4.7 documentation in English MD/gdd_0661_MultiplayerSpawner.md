# MultiplayerSpawner

Inherits: Node < Object

Automatically replicates spawnable nodes from the authority to other multiplayer peers.

## Description

Spawnable scenes can be configured in the editor or through code (see add_spawnable_scene()).

Also supports custom node spawns through spawn(), calling spawn_function on all peers.

Internally, MultiplayerSpawner uses MultiplayerAPI.object_configuration_add() to notify spawns passing the spawned node as the object and itself as the configuration, and MultiplayerAPI.object_configuration_remove() to notify despawns in a similar way.

## Properties

Callable | spawn_function |
int | spawn_limit | 0
NodePath | spawn_path | NodePath("")

## Methods

void | add_spawnable_scene(path: String)
void | clear_spawnable_scenes()
String | get_spawnable_scene(index: int) const
int | get_spawnable_scene_count() const
Node | spawn(data: Variant = null)

---

## Signals

despawned(node: Node) 

Emitted when a spawnable scene or custom spawn was despawned by the multiplayer authority. Only called on remote peers.

---

spawned(node: Node) 

Emitted when a spawnable scene or custom spawn was spawned by the multiplayer authority. Only called on remote peers.

---

## Property Descriptions

Callable spawn_function 

- void set_spawn_function(value: Callable)
- Callable get_spawn_function()

Method called on all peers when a custom spawn() is requested by the authority. Will receive the data parameter, and should return a Node that is not in the scene tree.

Note: The returned node should not be added to the scene with Node.add_child(). This is done automatically.

---

int spawn_limit = 0 

- void set_spawn_limit(value: int)
- int get_spawn_limit()

Maximum number of nodes allowed to be spawned by this spawner. Includes both spawnable scenes and custom spawns.

When set to 0 (the default), there is no limit.

---

NodePath spawn_path = NodePath("") 

- void set_spawn_path(value: NodePath)
- NodePath get_spawn_path()

Path to the spawn root. Spawnable scenes that are added as direct children are replicated to other peers.

---

## Method Descriptions

void add_spawnable_scene(path: String) 

Adds a scene path to spawnable scenes, making it automatically replicated from the multiplayer authority to other peers when added as children of the node pointed by spawn_path.

---

void clear_spawnable_scenes() 

Clears all spawnable scenes. Does not despawn existing instances on remote peers.

---

String get_spawnable_scene(index: int) const 

Returns the spawnable scene path by index.

---

int get_spawnable_scene_count() const 

Returns the count of spawnable scene paths.

---

Node spawn(data: Variant = null) 

Requests a custom spawn, with data passed to spawn_function on all peers. Returns the locally spawned node instance already inside the scene tree, and added as a child of the node pointed by spawn_path.

Note: Spawnable scenes are spawned automatically. spawn() is only needed for custom spawns.
