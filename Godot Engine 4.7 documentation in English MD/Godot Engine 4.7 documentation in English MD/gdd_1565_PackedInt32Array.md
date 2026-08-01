# PackedInt32Array

A packed array of 32-bit integers.

## Description

An array specifically designed to hold 32-bit integer values. Packs data tightly, so it saves memory for large array sizes.

Note: This type stores signed 32-bit integers, which means it can take values in the interval [-2^31, 2^31 - 1], i.e. [-2147483648, 2147483647]. Exceeding those bounds will wrap around. In comparison, int uses signed 64-bit integers which can hold much larger values. If you need to pack 64-bit integers tightly, see PackedInt64Array.

Note: Packed arrays are always passed by reference. To get a copy of an array that can be modified independently of the original array, use duplicate(). This is not the case for built-in properties and methods. In these cases the returned packed array is a copy, and changing it will not affect the original value. To update a built-in property of this type, modify the returned array and then assign it to the property again.

Note: In a boolean context, a packed array will evaluate to false if it's empty. Otherwise, a packed array will always evaluate to true.

Note

There are notable differences when using this API with C#. See C# API differences to GDScript for more information.

## Constructors

PackedInt32Array | PackedInt32Array()
PackedInt32Array | PackedInt32Array(from: PackedInt32Array)
PackedInt32Array | PackedInt32Array(from: Array)

## Methods

bool | append(value: int)
void | append_array(array: PackedInt32Array)
int | bsearch(value: int, before: bool = true) const
void | clear()
int | count(value: int) const
PackedInt32Array | duplicate() const
bool | erase(value: int)
void | fill(value: int)
int | find(value: int, from: int = 0) const
int | get(index: int) const
bool | has(value: int) const
int | insert(at_index: int, value: int)
bool | is_empty() const
bool | push_back(value: int)
void | remove_at(index: int)
int | resize(new_size: int)
void | reverse()
int | rfind(value: int, from: int = -1) const
void | set(index: int, value: int)
int | size() const
PackedInt32Array | slice(begin: int, end: int = 2147483647) const
void | sort()
PackedByteArray | to_byte_array() const

## Operators

bool | operator !=(right: PackedInt32Array)
PackedInt32Array | operator +(right: PackedInt32Array)
bool | operator ==(right: PackedInt32Array)
int | operator [](index: int)

---

## Constructor Descriptions

PackedInt32Array PackedInt32Array() 

Constructs an empty PackedInt32Array.

---

PackedInt32Array PackedInt32Array(from: PackedInt32Array)

Constructs a PackedInt32Array as a copy of the given PackedInt32Array.

---

PackedInt32Array PackedInt32Array(from: Array)

Constructs a new PackedInt32Array. Optionally, you can pass in a generic Array that will be converted.

---

## Method Descriptions

bool append(value: int) 

Appends an element at the end of the array (alias of push_back()).

---

void append_array(array: PackedInt32Array) 

Appends a PackedInt32Array at the end of this array.

---

int bsearch(value: int, before: bool = true) const 

Finds the index of an existing value (or the insertion index that maintains sorting order, if the value is not yet present in the array) using binary search. Optionally, a before specifier can be passed. If false, the returned index comes after all existing entries of the value in the array.

Note: Calling bsearch() on an unsorted array results in unexpected behavior.

---

void clear() 

Clears the array. This is equivalent to using resize() with a size of 0.

---

int count(value: int) const 

Returns the number of times an element is in the array.

---

PackedInt32Array duplicate() const 

Creates a copy of the array, and returns it.

---

bool erase(value: int) 

Removes the first occurrence of a value from the array and returns true. If the value does not exist in the array, nothing happens and false is returned. To remove an element by index, use remove_at() instead.

---

void fill(value: int) 

Assigns the given value to all elements in the array. This can typically be used together with resize() to create an array with a given size and initialized elements.

---

int find(value: int, from: int = 0) const 

Searches the array for a value and returns its index or -1 if not found. Optionally, the initial search index can be passed.

---

int get(index: int) const 

Returns the 32-bit integer at the given index in the array. If index is out-of-bounds or negative, this method fails and returns 0.

This method is similar (but not identical) to the [] operator. Most notably, when this method fails, it doesn't pause project execution if run from the editor.

---

bool has(value: int) const 

Returns true if the array contains value.

---

int insert(at_index: int, value: int) 

Inserts a new integer at a given position in the array. The position must be valid, or at the end of the array (idx == size()).

---

bool is_empty() const 

Returns true if the array is empty.

---

bool push_back(value: int) 

Appends a value to the array.

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

int rfind(value: int, from: int = -1) const 

Searches the array in reverse order. Optionally, a start search index can be passed. If negative, the start index is considered relative to the end of the array.

---

void set(index: int, value: int) 

Changes the integer at the given index.

---

int size() const 

Returns the number of elements in the array.

---

PackedInt32Array slice(begin: int, end: int = 2147483647) const 

Returns the slice of the PackedInt32Array, from begin (inclusive) to end (exclusive), as a new PackedInt32Array.

The absolute value of begin and end will be clamped to the array size, so the default value for end makes it slice to the size of the array by default (i.e. arr.slice(1) is a shorthand for arr.slice(1, arr.size())).

If either begin or end are negative, they will be relative to the end of the array (i.e. arr.slice(0, -2) is a shorthand for arr.slice(0, arr.size() - 2)).

---

void sort() 

Sorts the elements of the array in ascending order.

---

PackedByteArray to_byte_array() const 

Returns a copy of the data converted to a PackedByteArray, where each element has been encoded as 4 bytes.

The size of the new array will be int32_array.size() * 4.

---

## Operator Descriptions

bool operator !=(right: PackedInt32Array) 

Returns true if contents of the arrays differ.

---

PackedInt32Array operator +(right: PackedInt32Array) 

Returns a new PackedInt32Array with contents of right added at the end of this array. For better performance, consider using append_array() instead.

---

bool operator ==(right: PackedInt32Array) 

Returns true if contents of both arrays are the same, i.e. they have all equal ints at the corresponding indices.

---

int operator [](index: int) 

Returns the int at index index. Negative indices can be used to access the elements starting from the end. Using index out of array's bounds will result in an error.

Note that int type is 64-bit, unlike the values stored in the array.
