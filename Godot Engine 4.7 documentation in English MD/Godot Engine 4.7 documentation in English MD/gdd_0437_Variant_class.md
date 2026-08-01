# Variant class

## About

Variant is the most important datatype in Godot. A Variant takes up only 24
bytes on 64-bit platforms (20 bytes on 32-bit platforms) and can store almost
any engine datatype inside of it. Variants are rarely used to hold information
for long periods of time, instead they are used mainly for communication,
editing, serialization and generally moving data around.

A Variant can:

- Store almost any datatype.
- Perform operations between many variants (GDScript uses Variant as
its atomic/native datatype).
- Be hashed, so it can be compared quickly to other variants.
- Be used to convert safely between datatypes.
- Be used to abstract calling methods and their arguments (Godot
exports all its functions through variants).
- Be used to defer calls or move data between threads.
- Be serialized as binary and stored to disk, or transferred via
network.
- Be serialized to text and use it for printing values and editable
settings.
- Work as an exported property, so the editor can edit it universally.
- Be used for dictionaries, arrays, parsers, etc.

Basically, thanks to the Variant class, writing Godot itself was a much,
much easier task, as it allows for highly dynamic constructs not common
of C++ with little effort. Become a friend of Variant today.

Note

All types within Variant except Nil and Object cannot be null and
must always store a valid value. These types within Variant are therefore
called non-nullable types.

One of the Variant types is Nil which can only store the value null.
Therefore, it is possible for a Variant to contain the value null, even
though all Variant types excluding Nil and Object are non-nullable.

### References

- core/variant/variant.h [https://github.com/godotengine/godot/blob/master/core/variant/variant.h]

## List of variant types

These types are available in Variant:

Type | Notes
Nil (can only store null) | Nullable type
bool |
int |
float |
String |
Vector2 |
Vector2i |
Rect2 | 2D counterpart of AABB
Rect2i |
Vector3 |
Vector3i |
Transform2D |
Vector4 |
Vector4i |
Plane |
Quaternion |
AABB | 3D counterpart of Rect2
Basis |
Transform3D |
Projection |
Color |
StringName |
NodePath |
RID |
Object | Nullable type
Callable |
Signal |
Dictionary |
Array |
PackedByteArray |
PackedInt32Array |
PackedInt64Array |
PackedFloat32Array |
PackedFloat64Array |
PackedStringArray |
PackedVector2Array |
PackedVector3Array |
PackedColorArray |
PackedVector4Array |

## Containers: Array and Dictionary

Both Array and Dictionary are implemented using
variants. A Dictionary can match any datatype used as key to any other datatype.
An Array just holds an array of Variants. Of course, a Variant can also hold a
Dictionary or an Array inside, making it even more flexible.

Modifications to a container will modify all references to
it. A Mutex should be created to lock it if
multi-threaded access is desired.

### References

- core/variant/dictionary.h [https://github.com/godotengine/godot/blob/master/core/variant/dictionary.h]
- core/variant/array.h [https://github.com/godotengine/godot/blob/master/core/variant/array.h]
