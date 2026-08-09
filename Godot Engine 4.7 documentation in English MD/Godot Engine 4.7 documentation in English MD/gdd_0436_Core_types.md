# Core types

Godot has a rich set of classes and templates that compose its core,
and everything is built upon them.

This reference will try to list them in order for their better
understanding.

## Allocating memory

Godot has many tricks for ensuring memory safety and tracking memory
usage. Because of this, the regular C and C++ library calls
should not be used. Instead, a few replacements are provided.

For C-style allocation, Godot provides a few macros:

```cpp
memalloc(size)
memrealloc(pointer)
memfree(pointer)
```

These are equivalent to the usual malloc(), realloc(), and free()
of the C standard library.

For C++-style allocation, special macros are provided:

```cpp
memnew(Class)
memnew(Class(args))
memdelete(instance)
memnew_arr(Class, amount)
memdelete_arr(pointer_to_array)
```

These are equivalent to new, delete, new[], and delete[]
respectively.

memnew/memdelete also use a little C++ magic to automatically call post-init
and pre-release functions. For example, this is used to notify Objects right after
they are created, and right before they are deleted.

- core/os/memory.h [https://github.com/godotengine/godot/blob/master/core/os/memory.h]

## Containers

Godot provides its own set of containers, which means STL containers like std::string
and std::vector are generally not used in the codebase. See Why does Godot not use STL (Standard Template Library)? for more information.

A 📜 icon denotes the type is part of Variant. This
means it can be used as a parameter or return value of a method exposed to the
scripting API.

Godot datatype | Closest C++ STL datatype | Comment
String [https://github.com/godotengine/godot/blob/master/core/string/ustring.h] 📜 | std::string | Use this as the "default" string type. String uses UTF-32 encoding
to simplify processing thanks to its fixed character size.
Vector [https://github.com/godotengine/godot/blob/master/core/templates/vector.h] | std::vector | Use this as the "default" vector type. Uses copy-on-write (COW) semantics.
This means it's generally slower but can be copied around almost for free.
Use LocalVector instead where COW isn't needed and performance matters.
HashSet [https://github.com/godotengine/godot/blob/master/core/templates/hash_set.h] | std::unordered_set | Use this as the "default" set type.
AHashMap [https://github.com/godotengine/godot/blob/master/core/templates/a_hash_map.h] | std::unordered_map | Use this as the "default" map type. Does not preserve insertion order.
Note that pointers into the map, as well as iterators, are not stable under mutations.
If either of these affordances are needed, use HashMap instead.
StringName [https://github.com/godotengine/godot/blob/master/core/string/string_name.h] 📜 | std::string | Uses string interning for fast comparisons. Use this for static strings that are
referenced frequently and used in multiple locations in the engine.
LocalVector [https://github.com/godotengine/godot/blob/master/core/templates/local_vector.h] | std::vector | Closer to std::vector in semantics, doesn't use copy-on-write (COW) thus it's
faster than Vector. Prefer it over Vector when copying it cheaply
is not needed.
Array [https://github.com/godotengine/godot/blob/master/core/variant/array.h] 📜 | std::vector | Values can be of any Variant type. No static typing is imposed.
Uses shared reference counting, similar to std::shared_ptr.
Uses Vector internally.
TypedArray [https://github.com/godotengine/godot/blob/master/core/variant/typed_array.h] 📜 | std::vector | Subclass of Array but with static typing for its elements.
Not to be confused with Packed*Array, which is internally a Vector.
Packed*Array [https://github.com/godotengine/godot/blob/master/core/variant/variant.h] 📜 | std::vector | Alias of Vector, e.g. PackedColorArray = Vector.
Only a limited list of packed array types are available
(use TypedArray otherwise).
List [https://github.com/godotengine/godot/blob/master/core/templates/list.h] | std::list | Linked list type. Generally slower than other array/vector types. Prefer using
other types in new code, unless using List avoids the need for type conversions.
FixedVector [https://github.com/godotengine/godot/blob/master/core/templates/fixed_vector.h] | std::array | Vector with a fixed capacity (more similar to boost::container::static_vector).
This container type is more efficient than other vector-like types because it makes
no heap allocations.
Span [https://github.com/godotengine/godot/blob/master/core/templates/span.h] | std::span | Represents read-only access to a contiguous array without needing to copy any data.
Note that Span is designed to be a high performance API: It does not perform
parameter correctness checks in the same way you might be used to with other Godot
containers. Use with care.
Span can be constructed from most array-like containers (e.g. vector.span()).
RBSet [https://github.com/godotengine/godot/blob/master/core/templates/rb_set.h] | std::set | Uses a red-black tree [https://en.wikipedia.org/wiki/Red-black_tree]
for faster access.
VSet [https://github.com/godotengine/godot/blob/master/core/templates/vset.h] | std::flat_set | Uses copy-on-write (COW) semantics.
This means it's generally slower but can be copied around almost for free.
The performance benefits of VSet aren't established, so prefer using other types.
HashMap [https://github.com/godotengine/godot/blob/master/core/templates/hash_map.h] | std::unordered_map | Defensive (robust but slow) map type. Preserves insertion order.
Pointers to keys and values, as well as iterators, are stable under mutation.
Use this map type when either of these affordances are needed. Use AHashMap
otherwise.
RBMap [https://github.com/godotengine/godot/blob/master/core/templates/rb_map.h] | std::map | Map type that uses a
red-black tree [https://en.wikipedia.org/wiki/Red-black_tree] to find keys.
The performance benefits of RBMap aren't established, so prefer using other types.
Dictionary [https://github.com/godotengine/godot/blob/master/core/variant/dictionary.h] 📜 | std::unordered_map | Keys and values can be of any Variant type. No static typing is imposed.
Uses shared reference counting, similar to std::shared_ptr.
Preserves insertion order. Uses HashMap internally.
TypedDictionary [https://github.com/godotengine/godot/blob/master/core/variant/typed_dictionary.h] 📜 | std::unordered_map | Subclass of Dictionary but with static typing for its keys and values.
Pair [https://github.com/godotengine/godot/blob/master/core/templates/pair.h] | std::pair | Stores a single pair. See also KeyValue in the same file, which uses read-only
keys.

### Relocation safety

Godot's containers assume their elements are trivially relocatable [https://open-std.org/JTC1/SC22/WG21/docs/papers/2020/p1144r5.html].

This means that, if you store data types in it that have pointers to themselves, or are otherwise
not trivially relocatable [https://open-std.org/JTC1/SC22/WG21/docs/papers/2020/p1144r5.html#non-trivial-samples],
Godot might crash. Note that storing pointers to objects that are not trivially relocatable, such as some Object
subclasses, is unproblematic and supported.

The reason to assume trivial relocatability is that it allows us to make use of important optimization techniques, such
as relocation by memcpy or realloc.

GH-100509 [https://github.com/godotengine/godot/issues/100509] tracks this decision.

## Multithreading / Concurrency

See also

You can find more information on multithreading strategies at Using multiple threads.

None of Godot's containers are thread-safe. When you expect multiple threads to access them, you must use multithread
protections.

Note that some of the types listed here are also available through the bindings, but the binding types are wrapped with
RefCounted (found in the CoreBind:: namespace). Prefer the primitives listed here when possible, for
efficiency reasons.

Godot datatype | Closest C++ STL datatype | Comment
Mutex [https://github.com/godotengine/godot/blob/master/core/os/mutex.h] | std::recursive_mutex | Recursive mutex type. Use MutexLock lock(mutex) to lock it.
BinaryMutex [https://github.com/godotengine/godot/blob/master/core/os/mutex.h] | std::mutex | Non-recursive mutex type. Use MutexLock lock(mutex) to lock it.
RWLock [https://github.com/godotengine/godot/blob/master/core/os/rw_lock.h] | std::shared_mutex | Read-write aware mutex type. Use RWLockRead lock(mutex) or
RWLockWrite lock(mutex) to lock it.
SafeBinaryMutex [https://github.com/godotengine/godot/blob/master/core/os/safe_binary_mutex.h] | std::mutex | Recursive mutex type that can be used with ConditionVariable.
Use MutexLock lock(mutex) to lock it.
ConditionVariable [https://github.com/godotengine/godot/blob/master/core/os/condition_variable.h] | std::condition_variable | Condition variable type, used with SafeBinaryMutex.
Semaphore [https://github.com/godotengine/godot/blob/master/core/os/semaphore.h] | std::counting_semaphore | Counting semaphore type.
SafeNumeric [https://github.com/godotengine/godot/blob/master/core/templates/safe_refcount.h] | std::atomic | Templated atomic type, designed for numbers.
SafeFlag [https://github.com/godotengine/godot/blob/master/core/templates/safe_refcount.h] | std::atomic_bool | Bool atomic type.
SafeRefCount [https://github.com/godotengine/godot/blob/master/core/templates/safe_refcount.h] | std::atomic | Atomic type designed for reference counting. Will refuse to increment the
reference count if it is 0.

## Math types

There are several linear math types available in the core/math
directory:

- core/math [https://github.com/godotengine/godot/tree/master/core/math]

## NodePath

This is a special datatype used for storing paths in a scene tree and
referencing them in an optimized manner:

- core/string/node_path.h [https://github.com/godotengine/godot/blob/master/core/string/node_path.h]

## RID

RIDs are Resource IDs. Servers use these to reference data stored in
them. RIDs are opaque, meaning that the data they reference can't be
accessed directly. RIDs are unique, even for different types of
referenced data:

- core/templates/rid.h [https://github.com/godotengine/godot/blob/master/core/templates/rid.h]
