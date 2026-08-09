# PackedVector3Array

A packed array of Vector3s.

## Description

An array specifically designed to hold Vector3. Packs data tightly, so it saves memory for large array sizes.

Differences between packed arrays, typed arrays, and untyped arrays: Packed arrays are generally faster to iterate on and modify compared to a typed array of the same type (e.g. PackedVector3Array versus Array[Vector3]). Also, packed arrays consume less memory. As a downside, packed arrays are less flexible as they don't offer as many convenience methods such as Array.map(). Typed arrays are in turn faster to iterate on and modify than untyped arrays.

Note: Packed arrays are always passed by reference. To get a copy of an array that can be modified independently of the original array, use duplicate(). This is not the case for built-in properties and methods. In these cases the returned packed array is a copy, and changing it will not affect the original value. To update a built-in property of this type, modify the returned array and then assign it to the property again.

Note: In a boolean context, a packed array will evaluate to false if it's empty. Otherwise, a packed array will always evaluate to true.

Note

There are notable differences when using this API with C#. See C# API differences to GDScript for more information.

## Constructors

PackedVector3Array | PackedVector3Array()
PackedVector3Array | PackedVector3Array(from: PackedVector3Array)
PackedVector3Array | PackedVector3Array(from: Array)

## Methods

bool | append(value: Vector3)
void | append_array(array: PackedVector3Array)
int | bsearch(value: Vector3, before: bool = true) const
void | clear()
int | count(value: Vector3) const
PackedVector3Array | duplicate() const
bool | erase(value: Vector3)
void | fill(value: Vector3)
int | find(value: Vector3, from: int = 0) const
Vector3 | get(index: int) const
bool | has(value: Vector3) const
int | insert(at_index: int, value: Vector3)
bool | is_empty() const
bool | push_back(value: Vector3)
void | remove_at(index: int)
int | resize(new_size: int)
void | reverse()
int | rfind(value: Vector3, from: int = -1) const
void | set(index: int, value: Vector3)
int | size() const
PackedVector3Array | slice(begin: int, end: int = 2147483647) const
void | sort()
PackedByteArray | to_byte_array() const

## Operators

bool | operator !=(right: PackedVector3Array)
PackedVector3Array | operator *(right: Transform3D)
PackedVector3Array | operator +(right: PackedVector3Array)
bool | operator ==(right: PackedVector3Array)
Vector3 | operator [](index: int)

---

## Constructor Descriptions

PackedVector3Array PackedVector3Array() 

Constructs an empty PackedVector3Array.

---

PackedVector3Array PackedVector3Array(from: PackedVector3Array)

Constructs a PackedVector3Array as a copy of the given PackedVector3Array.

---

PackedVector3Array PackedVector3Array(from: Array)

Constructs a new PackedVector3Array. Optionally, you can pass in a generic Array that will be converted.

Note: When initializing a PackedVector3Array with elements, it must be initialized with an Array of Vector3 values:

```gdscript
var array = PackedVector3Array([Vector3(12, 34, 56), Vector3(78, 90, 12)])
```

---

## Method Descriptions

bool append(value: Vector3) 

Appends an element at the end of the array (alias of push_back()).

---

void append_array(array: PackedVector3Array) 

Appends a PackedVector3Array at the end of this array.

---

int bsearch(value: Vector3, before: bool = true) const 

Finds the index of an existing value (or the insertion index that maintains sorting order, if the value is not yet present in the array) using binary search. Optionally, a before specifier can be passed. If false, the returned index comes after all existing entries of the value in the array.

Note: Calling bsearch() on an unsorted array results in unexpected behavior.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this method may not be accurate if NaNs are included.

---

void clear() 

Clears the array. This is equivalent to using resize() with a size of 0.

---

int count(value: Vector3) const 

Returns the number of times an element is in the array.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this method may not be accurate if NaNs are included.

---

PackedVector3Array duplicate() const 

Creates a copy of the array, and returns it.

---

bool erase(value: Vector3) 

Removes the first occurrence of a value from the array and returns true. If the value does not exist in the array, nothing happens and false is returned. To remove an element by index, use remove_at() instead.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this method may not be accurate if NaNs are included.

---

void fill(value: Vector3) 

Assigns the given value to all elements in the array. This can typically be used together with resize() to create an array with a given size and initialized elements.

---

int find(value: Vector3, from: int = 0) const 

Searches the array for a value and returns its index or -1 if not found. Optionally, the initial search index can be passed.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this method may not be accurate if NaNs are included.

---

Vector3 get(index: int) const 

Returns the Vector3 at the given index in the array. If index is out-of-bounds or negative, this method fails and returns Vector3(0, 0, 0).

This method is similar (but not identical) to the [] operator. Most notably, when this method fails, it doesn't pause project execution if run from the editor.

---

bool has(value: Vector3) const 

Returns true if the array contains value.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this method may not be accurate if NaNs are included.

---

int insert(at_index: int, value: Vector3) 

Inserts a new element at a given position in the array. The position must be valid, or at the end of the array (idx == size()).

---

bool is_empty() const 

Returns true if the array is empty.

---

bool push_back(value: Vector3) 

Inserts a Vector3 at the end.

---

void remove_at(index: int) 

Removes an element from the array by index.

---

int resize(new_size: int) 

Sets the size of the array. If the array is grown, reserves elements at the end of the array. If the array is shrunk, truncates the array to the new size. Calling resize() once and assigning the new values is faster than adding new elements one by one.

Returns @GlobalScope.OK on success, or one of the following Error constants if this method fails: @GlobalScope.ERR_INVALID_PARAMETER if the size is negative, or @GlobalScope.ERR_OUT_OF_MEMORY if allocations fail. Use size() to find the actual size of the array after resize.

---

void reverse() 

Reverses the order of the elements in the array.

---

int rfind(value: Vector3, from: int = -1) const 

Searches the array in reverse order. Optionally, a start search index can be passed. If negative, the start index is considered relative to the end of the array.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this method may not be accurate if NaNs are included.

---

void set(index: int, value: Vector3) 

Changes the Vector3 at the given index.

---

int size() const 

Returns the number of elements in the array.

---

PackedVector3Array slice(begin: int, end: int = 2147483647) const 

Returns the slice of the PackedVector3Array, from begin (inclusive) to end (exclusive), as a new PackedVector3Array.

The absolute value of begin and end will be clamped to the array size, so the default value for end makes it slice to the size of the array by default (i.e. arr.slice(1) is a shorthand for arr.slice(1, arr.size())).

If either begin or end are negative, they will be relative to the end of the array (i.e. arr.slice(0, -2) is a shorthand for arr.slice(0, arr.size() - 2)).

---

void sort() 

Sorts the elements of the array in ascending order.

Note: Vectors with @GDScript.NAN elements don't behave the same as other vectors. Therefore, the results from this method may not be accurate if NaNs are included.

---

PackedByteArray to_byte_array() const 

Returns a PackedByteArray with each vector encoded as bytes.

---

## Operator Descriptions

bool operator !=(right: PackedVector3Array) 

Returns true if contents of the arrays differ.

---

PackedVector3Array operator *(right: Transform3D) 

Returns a new PackedVector3Array with all vectors in this array inversely transformed (multiplied) by the given Transform3D transformation matrix, under the assumption that the transformation basis is orthonormal (i.e. rotation/reflection is fine, scaling/skew is not).

array * transform is equivalent to transform.inverse() * array. See Transform3D.inverse().

For transforming by inverse of an affine transformation (e.g. with scaling) transform.affine_inverse() * array can be used instead. See Transform3D.affine_inverse().

---

PackedVector3Array operator +(right: PackedVector3Array) 

Returns a new PackedVector3Array with contents of right added at the end of this array. For better performance, consider using append_array() instead.

---

bool operator ==(right: PackedVector3Array) 

Returns true if contents of both arrays are the same, i.e. they have all equal Vector3s at the corresponding indices.

---

Vector3 operator [](index: int) 

Returns the Vector3 at index index. Negative indices can be used to access the elements starting from the end. Using index out of array's bounds will result in an error.
