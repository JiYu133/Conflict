# NodePath

A pre-parsed scene tree path.

## Description

The NodePath built-in Variant type represents a path to a node or property in a hierarchy of nodes. It is designed to be efficiently passed into many built-in methods (such as Node.get_node(), Object.set_indexed(), Tween.tween_property(), etc.) without a hard dependence on the node or property they point to.

A node path is represented as a String composed of slash-separated (/) node names and colon-separated (:) property names (also called "subnames"). Similar to a filesystem path, ".." and "." are special node names. They refer to the parent node and the current node, respectively.

The following examples are paths relative to the current node:

```gdscript
^"A"     # Points to the direct child A.
^"A/B"   # Points to A's child B.
^"."     # Points to the current node.
^".."    # Points to the parent node.
^"../C"  # Points to the sibling node C.
^"../.." # Points to the grandparent node.
```

A leading slash means the path is absolute, and begins from the SceneTree:

```gdscript
^"/root"            # Points to the SceneTree's root Window.
^"/root/Title"      # May point to the main scene's root node named "Title".
^"/root/Global"     # May point to an autoloaded node or scene named "Global".
```

Despite their name, node paths may also point to a property:

```gdscript
^":position"           # Points to this object's position.
^":position:x"         # Points to this object's position in the x axis.
^"Camera3D:rotation:y" # Points to the child Camera3D and its y rotation.
^"/root:size:x"        # Points to the root Window and its width.
```

In some situations, it's possible to omit the leading : when pointing to an object's property. As an example, this is the case with Object.set_indexed() and Tween.tween_property(), as those methods call get_as_property_path() under the hood. However, it's generally recommended to keep the : prefix.

Node paths cannot check whether they are valid and may point to nodes or properties that do not exist. Their meaning depends entirely on the context in which they're used.

You usually do not have to worry about the NodePath type, as strings are automatically converted to the type when necessary. There are still times when defining node paths is useful. For example, exported NodePath properties allow you to easily select any node within the currently edited scene. They are also automatically updated when moving, renaming or deleting nodes in the scene tree editor. See also @GDScript.@export_node_path.

See also StringName, which is a similar type designed for optimized strings.

Note: In a boolean context, a NodePath will evaluate to false if it is empty (NodePath("")). Otherwise, a NodePath will always evaluate to true.

Note

There are notable differences when using this API with C#. See C# API differences to GDScript for more information.

## Tutorials

- 2D Role Playing Game (RPG) Demo [https://godotengine.org/asset-library/asset/2729]

## Constructors

NodePath | NodePath()
NodePath | NodePath(from: NodePath)
NodePath | NodePath(from: String)

## Methods

NodePath | get_as_property_path() const
StringName | get_concatenated_names() const
StringName | get_concatenated_subnames() const
StringName | get_name(idx: int) const
int | get_name_count() const
StringName | get_subname(idx: int) const
int | get_subname_count() const
int | hash() const
bool | is_absolute() const
bool | is_empty() const
NodePath | slice(begin: int, end: int = 2147483647) const

## Operators

bool | operator !=(right: NodePath)
bool | operator ==(right: NodePath)

---

## Constructor Descriptions

NodePath NodePath() 

Constructs an empty NodePath.

---

NodePath NodePath(from: NodePath)

Constructs a NodePath as a copy of the given NodePath.

---

NodePath NodePath(from: String)

Constructs a NodePath from a String. The created path is absolute if prefixed with a slash (see is_absolute()).

The "subnames" optionally included after the path to the target node can point to properties, and can also be nested.

The following strings can be valid node paths:

```gdscript
# Points to the Sprite2D node.
"Level/RigidBody2D/Sprite2D"
# Points to the Sprite2D node and its "texture" resource.
# get_node() would retrieve the Sprite2D, while get_node_and_resource()
# would retrieve both the Sprite2D node and the "texture" resource.
"Level/RigidBody2D/Sprite2D:texture"
# Points to the Sprite2D node and its "position" property.
"Level/RigidBody2D/Sprite2D:position"
# Points to the Sprite2D node and the "x" component of its "position" property.
"Level/RigidBody2D/Sprite2D:position:x"
# Points to the RigidBody2D node as an absolute path beginning from the SceneTree.
"/root/Level/RigidBody2D"
```

Note: In GDScript, it's also possible to convert a constant string into a node path by prefixing it with ^. ^"path/to/node" is equivalent to NodePath("path/to/node").

---

## Method Descriptions

NodePath get_as_property_path() const 

Returns a copy of this node path with a colon character (:) prefixed, transforming it to a pure property path with no node names (relative to the current node).

```
# node_path points to the "x" property of the child node named "position".
var node_path = ^"position:x"
# property_path points to the "position" in the "x" axis of this node.
var property_path = node_path.get_as_property_path()
print(property_path) # Prints ":position:x"
```

```
// nodePath points to the "x" property of the child node named "position".
var nodePath = new NodePath("position:x");
// propertyPath points to the "position" in the "x" axis of this node.
NodePath propertyPath = nodePath.GetAsPropertyPath();
GD.Print(propertyPath); // Prints ":position:x"
```

---

StringName get_concatenated_names() const 

Returns all node names concatenated with a slash character (/) as a single StringName.

---

StringName get_concatenated_subnames() const 

Returns all property subnames concatenated with a colon character (:) as a single StringName.

```
var node_path = ^"Sprite2D:texture:resource_name"
print(node_path.get_concatenated_subnames()) # Prints "texture:resource_name"
```

```
var nodePath = new NodePath("Sprite2D:texture:resource_name");
GD.Print(nodePath.GetConcatenatedSubnames()); // Prints "texture:resource_name"
```

---

StringName get_name(idx: int) const 

Returns the node name indicated by idx, starting from 0. If idx is out of bounds, an error is generated. See also get_subname_count() and get_name_count().

```
var sprite_path = NodePath("../RigidBody2D/Sprite2D")
print(sprite_path.get_name(0)) # Prints ".."
print(sprite_path.get_name(1)) # Prints "RigidBody2D"
print(sprite_path.get_name(2)) # Prints "Sprite"
```

```
var spritePath = new NodePath("../RigidBody2D/Sprite2D");
GD.Print(spritePath.GetName(0)); // Prints ".."
GD.Print(spritePath.GetName(1)); // Prints "PathFollow2D"
GD.Print(spritePath.GetName(2)); // Prints "Sprite"
```

---

int get_name_count() const 

Returns the number of node names in the path. Property subnames are not included.

For example, "../RigidBody2D/Sprite2D:texture" contains 3 node names.

---

StringName get_subname(idx: int) const 

Returns the property name indicated by idx, starting from 0. If idx is out of bounds, an error is generated. See also get_subname_count().

```
var path_to_name = NodePath("Sprite2D:texture:resource_name")
print(path_to_name.get_subname(0)) # Prints "texture"
print(path_to_name.get_subname(1)) # Prints "resource_name"
```

```
var pathToName = new NodePath("Sprite2D:texture:resource_name");
GD.Print(pathToName.GetSubname(0)); // Prints "texture"
GD.Print(pathToName.GetSubname(1)); // Prints "resource_name"
```

---

int get_subname_count() const 

Returns the number of property names ("subnames") in the path. Each subname in the node path is listed after a colon character (:).

For example, "Level/RigidBody2D/Sprite2D:texture:resource_name" contains 2 subnames.

---

int hash() const 

Returns the 32-bit hash value representing the node path's contents.

Note: Node paths with equal hash values are not guaranteed to be the same, as a result of hash collisions. Node paths with different hash values are guaranteed to be different.

---

bool is_absolute() const 

Returns true if the node path is absolute. Unlike a relative path, an absolute path is represented by a leading slash character (/) and always begins from the SceneTree. It can be used to reliably access nodes from the root node (e.g. "/root/Global" if an autoload named "Global" exists).

---

bool is_empty() const 

Returns true if the node path has been constructed from an empty String ("").

---

NodePath slice(begin: int, end: int = 2147483647) const 

Returns the slice of the NodePath, from begin (inclusive) to end (exclusive), as a new NodePath.

The absolute value of begin and end will be clamped to the sum of get_name_count() and get_subname_count(), so the default value for end makes it slice to the end of the NodePath by default (i.e. path.slice(1) is a shorthand for path.slice(1, path.get_name_count() + path.get_subname_count())).

If either begin or end are negative, they will be relative to the end of the NodePath (i.e. path.slice(0, -2) is a shorthand for path.slice(0, path.get_name_count() + path.get_subname_count() - 2)).

---

## Operator Descriptions

bool operator !=(right: NodePath) 

Returns true if two node paths are not equal.

---

bool operator ==(right: NodePath) 

Returns true if two node paths are equal, that is, they are composed of the same node names and subnames in the same order.
