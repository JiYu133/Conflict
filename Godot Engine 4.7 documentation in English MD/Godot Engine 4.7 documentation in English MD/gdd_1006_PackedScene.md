# PackedScene

Inherits: Resource < RefCounted < Object

An abstraction of a serialized scene.

## Description

A simplified interface to a scene file. Provides access to operations and checks that can be performed on the scene resource itself.

Can be used to save a node to a file. When saving, the node as well as all the nodes it owns get saved (see Node.owner property).

Note: The node doesn't need to own itself.

Example: Load a saved scene:

```
# Use load() instead of preload() if the path isn't known at compile-time.
var scene = preload("res://scene.tscn").instantiate()
# Add the node as a child of the node the script is attached to.
add_child(scene)
```

```
// C# has no preload, so you have to always use ResourceLoader.Load().
var scene = ResourceLoader.Load("res://scene.tscn").Instantiate();
// Add the node as a child of the node the script is attached to.
AddChild(scene);
```

Example: Save a node with different owners. The following example creates 3 objects: Node2D (node), RigidBody2D (body) and CollisionObject2D (collision). collision is a child of body which is a child of node. Only body is owned by node and pack() will therefore only save those two nodes, but not collision.

```
# Create the objects.
var node = Node2D.new()
var body = RigidBody2D.new()
var collision = CollisionShape2D.new()
# Create the object hierarchy.
body.add_child(collision)
node.add_child(body)
# Change owner of `body`, but not of `collision`.
body.owner = node
var scene = PackedScene.new()
# Only `node` and `body` are now packed.
var result = scene.pack(node)
if result == OK:
    var error = ResourceSaver.save(scene, "res://path/name.tscn")  # Or "user://..."
    if error != OK:
        push_error("An error occurred while saving the scene to disk.")
```

```
// Create the objects.
var node = new Node2D();
var body = new RigidBody2D();
var collision = new CollisionShape2D();
// Create the object hierarchy.
body.AddChild(collision);
node.AddChild(body);
// Change owner of `body`, but not of `collision`.
body.Owner = node;
var scene = new PackedScene();
// Only `node` and `body` are now packed.
Error result = scene.Pack(node);
if (result == Error.Ok)
{
    Error error = ResourceSaver.Save(scene, "res://path/name.tscn"); // Or "user://..."
    if (error != Error.Ok)
    {
        GD.PushError("An error occurred while saving the scene to disk.");
    }
}
```

## Tutorials

- 2D Role Playing Game (RPG) Demo [https://godotengine.org/asset-library/asset/2729]

## Methods

bool | can_instantiate() const
SceneState | get_state() const
Node | instantiate(edit_state: GenEditState = 0) const
Error | pack(path: Node)

---

## Enumerations

enum GenEditState
GenEditState GEN_EDIT_STATE_DISABLED = 0

If passed to instantiate(), blocks edits to the scene state.

GenEditState GEN_EDIT_STATE_INSTANCE = 1

If passed to instantiate(), provides local scene resources to the local scene.

Note: Only available in editor builds.

GenEditState GEN_EDIT_STATE_MAIN = 2

If passed to instantiate(), provides local scene resources to the local scene. Only the main scene should receive the main edit state.

Note: Only available in editor builds.

GenEditState GEN_EDIT_STATE_MAIN_INHERITED = 3

It's similar to GEN_EDIT_STATE_MAIN, but for the case where the scene is being instantiated to be the base of another one.

Note: Only available in editor builds.

---

## Method Descriptions

bool can_instantiate() const 

Returns true if the scene file has nodes.

---

SceneState get_state() const 

Returns the SceneState representing the scene file contents.

---

Node instantiate(edit_state: GenEditState = 0) const 

Instantiates the scene's node hierarchy. Triggers child scene instantiation(s). Triggers a Node.NOTIFICATION_SCENE_INSTANTIATED notification on the root node.

---

Error pack(path: Node) 

Packs the path node, and all owned sub-nodes, into this PackedScene. Any existing data will be cleared. See Node.owner.
