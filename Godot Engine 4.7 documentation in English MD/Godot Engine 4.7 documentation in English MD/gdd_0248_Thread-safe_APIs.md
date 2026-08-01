# Thread-safe APIs

## Threads

Threads are used to balance processing power across CPUs and cores.
Godot supports multithreading, but not in the whole engine.

Below is a list of ways multithreading can be used in different areas of Godot.

## Global scope

Most Global Scope singletons are thread-safe by default.
Accessing servers from threads is supported. However, for the
rendering and
physics servers,
thread-safe operation must be enabled in the project settings first.

This makes singletons ideal for code that creates dozens of thousands of instances
in servers and controls them from threads. Of course, it requires a bit more
code, as this is used directly and not within the scene tree.

## Scene tree

Interacting with the active scene tree is not thread-safe. Make sure
to use mutexes when sending data between threads. If you want to call
functions or set properties from a thread, you may use
call_deferred or set_deferred:

```
# Unsafe:
node.add_child(child_node)
# Safe:
node.add_child.call_deferred(child_node)
```

```
// Unsafe:
node.AddChild(childNode);
// Safe:
node.CallDeferred(Node.MethodName.AddChild, childNode);
```

However, creating scene chunks (nodes in tree arrangement) outside the active
tree is fine. This way, parts of a scene can be built or instantiated
in a thread, then added in the main thread:

```
var enemy_scene = load("res://enemy_scene.scn")
var enemy = enemy_scene.instantiate()
enemy.add_child(weapon) # Set a weapon.
world.add_child.call_deferred(enemy)
```

```
PackedScene enemyScene = GD.Load("res://EnemyScene.scn");
Node enemy = enemyScene.Instantiate();
enemy.AddChild(weapon);
world.CallDeferred(Node.MethodName.AddChild, enemy);
```

Still, this is only really useful if you have one thread loading data.
Attempting to load or create scene chunks from multiple threads may work,
but you risk resources (which are only loaded once in Godot) being tweaked
by the multiple threads, resulting in unexpected behaviors or crashes.

Only use more than one thread to generate scene data if you really know what
you are doing and you are sure that a single resource is not being used or
set in multiple ones. Otherwise, you are safer just using the servers API
(which is fully thread-safe) directly and not touching scene or resources.

## Rendering

Instancing nodes that render anything in 2D or 3D (such as Sprite2D
or MeshInstance3D) is not thread-safe by default. To run the
rendering driver on a separate thread, set the
Rendering > Driver > Thread Model
project setting to Separate.

Note that the Separate thread model has several known bugs, so it may not be usable
in all scenarios.

Warning

You should avoid calling functions involving direct interaction with the GPU
on other threads, such as creating new textures or modifying and retrieving
image data. These operations can lead to performance stalls because they require
synchronization with the RenderingServer,
as data needs to be transmitted to or updated on the GPU.

## Physics

Physics simulation is not thread-safe by default. To run the physics servers
on separate threads (making them thread-safe), enable the following project settings:

- PhysicsServer2D: Physics > 2D > Run on Separate Thread.
- PhysicsServer3D: Physics > 3D > Run on Separate Thread.

## Navigation

NavigationServer2D and NavigationServer3D are both thread-safe and thread-friendly.

The navigation-related query functions can be called by threads and run in true parallel.

By default, a conservative number of threads is supported running in true parallel on navigation maps before
additional threads have to wait for map data access at a semaphore.
To increase the number of threads that can run simultaneously on map data,
set Navigation > Pathfinding > Max Threads.

The navigation server-related resources like NavigationSourceGeometryData, NavigationMesh, and NavigationPolygon are all thread-safe but not necessarily thread-friendly.
They use internal read-write locks for thread-safety so editing the same resource (e.g. a single big navmesh) on multiple threads at the same time can cause thread congestion.

The navigation-related helper classes like AStar2D, AStar3D, and AStarGrid2D are not thread-safe.
They can be used with threads to some limited capacity, but using two or more threads on the same AStar object causes corruption.
For example, using a dedicated background thread per AStar object to populate points or do queries works,
but two threads using the same AStar object would corrupt each other's data.

## GDScript arrays and dictionaries

In GDScript, reading and writing elements from multiple threads is OK, but anything
that changes the container size (resizing, adding, or removing elements) requires
locking a mutex.

## Resources

Modifying a unique resource from multiple threads is not supported. However,
handling references on multiple threads is supported. Hence loading resources
on a thread is as well - scenes, textures, meshes, etc - can be loaded and manipulated
on a thread and then added to the active scene on the main thread. The limitation here
is as described above: one must be careful not to load the same resource from
multiple threads at once. Therefore, it's easiest to use one thread for loading
and modifying resources, and then the main thread for adding them.
