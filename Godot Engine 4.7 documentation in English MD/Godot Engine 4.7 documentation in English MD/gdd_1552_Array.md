# Array

A built-in data structure that holds a sequence of elements.

## Description

An array data structure that can contain a sequence of elements of any Variant type by default. Values can optionally be constrained to a specific type by creating a typed array. Elements are accessed by a numerical index starting at 0. Negative indices are used to count from the back (-1 is the last element, -2 is the second to last, etc.).

```
var array = ["First", 2, 3, "Last"]
print(array[0])  # Prints "First"
print(array[2])  # Prints 3
print(array[-1]) # Prints "Last"
array[1] = "Second"
print(array[1])  # Prints "Second"
print(array[-3]) # Prints "Second"
# This typed array can only contain integers.
# Attempting to add any other type will result in an error.
var typed_array: Array[int] = [1, 2, 3]
```

```
Godot.Collections.Array array = ["First", 2, 3, "Last"];
GD.Print(array[0]); // Prints "First"
GD.Print(array[2]); // Prints 3
GD.Print(array[^1]); // Prints "Last"
array[1] = "Second";
GD.Print(array[1]); // Prints "Second"
GD.Print(array[^3]); // Prints "Second"
// This typed array can only contain integers.
// Attempting to add any other type will result in an error.
Godot.Collections.Array typedArray = [1, 2, 3];
```

Note: Arrays are always passed by reference. To get a copy of an array that can be modified independently of the original array, use duplicate().

Note: Erasing elements while iterating over arrays is not supported and will result in unpredictable behavior.

Note: In a boolean context, an array will evaluate to false if it's empty ([]). Otherwise, an array will always evaluate to true.

Differences between packed arrays, typed arrays, and untyped arrays: Packed arrays are generally faster to iterate on and modify compared to a typed array of the same type (e.g. PackedInt64Array versus Array[int]). Also, packed arrays consume less memory. As a downside, packed arrays are less flexible as they don't offer as many convenience methods such as map(). Typed arrays are in turn faster to iterate on and modify than untyped arrays.

Note

There are notable differences when using this API with C#. See C# API differences to GDScript for more information.

## Constructors

Array | Array()
Array | Array(base: Array, type: int, class_name: StringName, script: Variant)
Array | Array(from: Array)
Array | Array(from: PackedByteArray)
Array | Array(from: PackedColorArray)
Array | Array(from: PackedFloat32Array)
Array | Array(from: PackedFloat64Array)
Array | Array(from: PackedInt32Array)
Array | Array(from: PackedInt64Array)
Array | Array(from: PackedStringArray)
Array | Array(from: PackedVector2Array)
Array | Array(from: PackedVector3Array)
Array | Array(from: PackedVector4Array)

## Methods

bool | all(method: Callable) const
bool | any(method: Callable) const
void | append(value: Variant)
void | append_array(array: Array)
void | assign(array: Array)
Variant | back() const
int | bsearch(value: Variant, before: bool = true) const
int | bsearch_custom(value: Variant, func: Callable, before: bool = true) const
void | clear()
int | count(value: Variant) const
Array | duplicate(deep: bool = false) const
Array | duplicate_deep(deep_subresources_mode: int = 1) const
void | erase(value: Variant)
void | fill(value: Variant)
Array | filter(method: Callable) const
int | find(what: Variant, from: int = 0) const
int | find_custom(method: Callable, from: int = 0) const
Variant | front() const
Variant | get(index: int) const
int | get_typed_builtin() const
StringName | get_typed_class_name() const
Variant | get_typed_script() const
bool | has(value: Variant) const
int | hash() const
int | insert(position: int, value: Variant)
bool | is_empty() const
bool | is_read_only() const
bool | is_same_typed(array: Array) const
bool | is_typed() const
void | make_read_only()
Array | map(method: Callable) const
Variant | max() const
Variant | min() const
Variant | pick_random() const
Variant | pop_at(position: int)
Variant | pop_back()
Variant | pop_front()
void | push_back(value: Variant)
void | push_front(value: Variant)
Variant | reduce(method: Callable, accum: Variant = null) const
void | remove_at(position: int)
int | resize(size: int)
void | reverse()
int | rfind(what: Variant, from: int = -1) const
int | rfind_custom(method: Callable, from: int = -1) const
void | set(index: int, value: Variant)
void | shuffle()
int | size() const
Array | slice(begin: int, end: int = 2147483647, step: int = 1, deep: bool = false) const
void | sort()
void | sort_custom(func: Callable)

## Operators

bool | operator !=(right: Array)
Array | operator +(right: Array)
bool | operator <(right: Array)
bool | operator <=(right: Array)
bool | operator ==(right: Array)
bool | operator >(right: Array)
bool | operator >=(right: Array)
Variant | operator [](index: int)

---

## Constructor Descriptions

Array Array() 

Constructs an empty Array.

---

Array Array(base: Array, type: int, class_name: StringName, script: Variant)

Creates a typed array from the base array. A typed array can only contain elements of the given type, or that inherit from the given class, as described by this constructor's parameters:

- type is the built-in Variant type, as one the Variant.Type constants.
- class_name is the built-in class name (see Object.get_class()).
- script is the associated script. It must be a Script instance or null.

If type is not @GlobalScope.TYPE_OBJECT, class_name must be an empty StringName and script must be null.

```gdscript
class_name Sword
extends Node
class Stats:
    pass
func _ready():
    var a = Array([], TYPE_INT, "", null)               # Array[int]
    var b = Array([], TYPE_OBJECT, "Node", null)        # Array[Node]
    var c = Array([], TYPE_OBJECT, "Node", Sword)       # Array[Sword]
    var d = Array([], TYPE_OBJECT, "RefCounted", Stats) # Array[Stats]
```

The base array's elements are converted when necessary. If this is not possible or base is already typed, this constructor fails and returns an empty Array.

In GDScript, this constructor is usually not necessary, as it is possible to create a typed array through static typing:

```gdscript
var numbers: Array[float] = []
var children: Array[Node] = [$Node, $Sprite2D, $RigidBody3D]
var integers: Array[int] = [0.2, 4.5, -2.0]
print(integers) # Prints [0, 4, -2]
```

---

Array Array(from: Array)

Returns the same array as from. If you need a copy of the array, use duplicate().

---

Array Array(from: PackedByteArray)

Constructs an array from a PackedByteArray.

---

Array Array(from: PackedColorArray)

Constructs an array from a PackedColorArray.

---

Array Array(from: PackedFloat32Array)

Constructs an array from a PackedFloat32Array.

---

Array Array(from: PackedFloat64Array)

Constructs an array from a PackedFloat64Array.

---

Array Array(from: PackedInt32Array)

Constructs an array from a PackedInt32Array.

---

Array Array(from: PackedInt64Array)

Constructs an array from a PackedInt64Array.

---

Array Array(from: PackedStringArray)

Constructs an array from a PackedStringArray.

---

Array Array(from: PackedVector2Array)

Constructs an array from a PackedVector2Array.

---

Array Array(from: PackedVector3Array)

Constructs an array from a PackedVector3Array.

---

Array Array(from: PackedVector4Array)

Constructs an array from a PackedVector4Array.

---

## Method Descriptions

bool all(method: Callable) const 

Calls the given Callable on each element in the array and returns true if the Callable returns true for all elements in the array. If the Callable returns false for one array element or more, this method returns false.

The method should take one Variant parameter (the current array element) and return a bool.

```
func greater_than_5(number):
    return number > 5
func _ready():
    print([6, 10, 6].all(greater_than_5)) # Prints true (3/3 elements evaluate to true).
    print([4, 10, 4].all(greater_than_5)) # Prints false (1/3 elements evaluate to true).
    print([4, 4, 4].all(greater_than_5))  # Prints false (0/3 elements evaluate to true).
    print([].all(greater_than_5))         # Prints true (0/0 elements evaluate to true).
    # Same as the first line above, but using a lambda function.
    print([6, 10, 6].all(func(element): return element > 5)) # Prints true
```

```
private static bool GreaterThan5(int number)
{
    return number > 5;
}
public override void _Ready()
{
    // Prints True (3/3 elements evaluate to true).
    GD.Print(new Godot.Collections.Array { 6, 10, 6 }.All(GreaterThan5));
    // Prints False (1/3 elements evaluate to true).
    GD.Print(new Godot.Collections.Array { 4, 10, 4 }.All(GreaterThan5));
    // Prints False (0/3 elements evaluate to true).
    GD.Print(new Godot.Collections.Array { 4, 4, 4 }.All(GreaterThan5));
    // Prints True (0/0 elements evaluate to true).
    GD.Print(new Godot.Collections.Array { }.All(GreaterThan5));
    // Same as the first line above, but using a lambda function.
    GD.Print(new Godot.Collections.Array { 6, 10, 6 }.All(element => element > 5)); // Prints True
}
```

See also any(), filter(), map() and reduce().

Note: Unlike relying on the size of an array returned by filter(), this method will return as early as possible to improve performance (especially with large arrays).

Note: For an empty array, this method always [https://en.wikipedia.org/wiki/Vacuous_truth] returns true.

---

bool any(method: Callable) const 

Calls the given Callable on each element in the array and returns true if the Callable returns true for one or more elements in the array. If the Callable returns false for all elements in the array, this method returns false.

The method should take one Variant parameter (the current array element) and return a bool.

```gdscript
func greater_than_5(number):
    return number > 5
func _ready():
    print([6, 10, 6].any(greater_than_5)) # Prints true (3 elements evaluate to true).
    print([4, 10, 4].any(greater_than_5)) # Prints true (1 elements evaluate to true).
    print([4, 4, 4].any(greater_than_5))  # Prints false (0 elements evaluate to true).
    print([].any(greater_than_5))         # Prints false (0 elements evaluate to true).
    # Same as the first line above, but using a lambda function.
    print([6, 10, 6].any(func(number): return number > 5)) # Prints true
```

See also all(), filter(), map() and reduce().

Note: Unlike relying on the size of an array returned by filter(), this method will return as early as possible to improve performance (especially with large arrays).

Note: For an empty array, this method always returns false.

---

void append(value: Variant) 

Appends value at the end of the array (alias of push_back()).

---

void append_array(array: Array) 

Appends another array at the end of this array.

```gdscript
var numbers = [1, 2, 3]
var extra = [4, 5, 6]
numbers.append_array(extra)
print(numbers) # Prints [1, 2, 3, 4, 5, 6]
```

---

void assign(array: Array) 

Assigns elements of another array into the array. Resizes the array to match array. Performs type conversions if the array is typed.

---

Variant back() const 

Returns the last element of the array. If the array is empty, fails and returns null. See also front().

Note: Unlike with the [] operator (array[-1]), an error is generated without stopping project execution.

---

int bsearch(value: Variant, before: bool = true) const 

Returns the index of value in the sorted array. If it cannot be found, returns where value should be inserted to keep the array sorted. The algorithm used is binary search [https://en.wikipedia.org/wiki/Binary_search_algorithm].

If before is true (as by default), the returned index comes before all existing elements equal to value in the array.

```gdscript
var numbers = [2, 4, 8, 10]
var idx = numbers.bsearch(7)
numbers.insert(idx, 7)
print(numbers) # Prints [2, 4, 7, 8, 10]
var fruits = ["Apple", "Lemon", "Lemon", "Orange"]
print(fruits.bsearch("Lemon", true))  # Prints 1, points at the first "Lemon".
print(fruits.bsearch("Lemon", false)) # Prints 3, points at "Orange".
```

Note: Calling bsearch() on an unsorted array will result in unexpected behavior. Use sort() before calling this method.

---

int bsearch_custom(value: Variant, func: Callable, before: bool = true) const 

Returns the index of value in the sorted array. If it cannot be found, returns where value should be inserted to keep the array sorted (using func for the comparisons). The algorithm used is binary search [https://en.wikipedia.org/wiki/Binary_search_algorithm].

Similar to sort_custom(), func is called as many times as necessary, receiving one array element and value as arguments. The function should return true if the array element should be behind value, otherwise it should return false.

If before is true (as by default), the returned index comes before all existing elements equal to value in the array.

```gdscript
func sort_by_amount(a, b):
    if a[1] < b[1]:
        return true
    return false
func _ready():
    var my_items = [["Tomato", 2], ["Kiwi", 5], ["Rice", 9]]
    var apple = ["Apple", 5]
    # "Apple" is inserted before "Kiwi".
    my_items.insert(my_items.bsearch_custom(apple, sort_by_amount, true), apple)
    var banana = ["Banana", 5]
    # "Banana" is inserted after "Kiwi".
    my_items.insert(my_items.bsearch_custom(banana, sort_by_amount, false), banana)
    # Prints [["Tomato", 2], ["Apple", 5], ["Kiwi", 5], ["Banana", 5], ["Rice", 9]]
    print(my_items)
```

Note: Calling bsearch_custom() on an unsorted array will result in unexpected behavior. Use sort_custom() with func before calling this method.

---

void clear() 

Removes all elements from the array. This is equivalent to using resize() with a size of 0.

---

int count(value: Variant) const 

Returns the number of times an element is in the array.

To count how many elements in an array satisfy a condition, see reduce().

---

Array duplicate(deep: bool = false) const 

Returns a new copy of the array.

By default, a shallow copy is returned: all nested Array, Dictionary, and Resource elements are shared with the original array. Modifying any of those in one array will also affect them in the other.

If deep is true, a deep copy is returned: all nested arrays and dictionaries are also duplicated (recursively). Any Resource is still shared with the original array, though.

---

Array duplicate_deep(deep_subresources_mode: int = 1) const 

Duplicates this array, deeply, like duplicate() when passing true, with extra control over how subresources are handled.

deep_subresources_mode must be one of the values from DeepDuplicateMode. By default, only internal resources will be duplicated (recursively).

---

void erase(value: Variant) 

Finds and removes the first occurrence of value from the array. If value does not exist in the array, nothing happens. To remove an element by index, use remove_at() instead.

Note: This method shifts every element's index after the removed value back, which may have a noticeable performance cost, especially on larger arrays.

Note: Erasing elements while iterating over arrays is not supported and will result in unpredictable behavior.

---

void fill(value: Variant) 

Assigns the given value to all elements in the array.

This method can often be combined with resize() to create an array with a given size and initialized elements:

```
var array = []
array.resize(5)
array.fill(2)
print(array) # Prints [2, 2, 2, 2, 2]
```

```
Godot.Collections.Array array = [];
array.Resize(5);
array.Fill(2);
GD.Print(array); // Prints [2, 2, 2, 2, 2]
```

Note: If value is a Variant passed by reference (Object-derived, Array, Dictionary, etc.), the array will be filled with references to the same value, which are not duplicates.

---

Array filter(method: Callable) const 

Calls the given Callable on each element in the array and returns a new, filtered Array.

The method receives one of the array elements as an argument, and should return true to add the element to the filtered array, or false to exclude it.

```gdscript
func is_even(number):
    return number % 2 == 0
func _ready():
    print([1, 4, 5, 8].filter(is_even)) # Prints [4, 8]
    # Same as above, but using a lambda function.
    print([1, 4, 5, 8].filter(func(number): return number % 2 == 0))
```

See also any(), all(), map() and reduce().

---

int find(what: Variant, from: int = 0) const 

Returns the index of the first occurrence of what in this array, or -1 if there are none. The search's start can be specified with from, continuing to the end of the array.

Note: If you just want to know whether the array contains what, use has() (Contains in C#). In GDScript, you may also use the in operator.

Note: For performance reasons, the search is affected by what's Variant.Type. For example, 7 (int) and 7.0 (float) are not considered equal for this method.

---

int find_custom(method: Callable, from: int = 0) const 

Returns the index of the first element in the array that causes method to return true, or -1 if there are none. The search's start can be specified with from, continuing to the end of the array.

method is a callable that takes an element of the array, and returns a bool.

Note: If you just want to know whether the array contains anything that satisfies method, use any().

```
func is_even(number):
    return number % 2 == 0
func _ready():
    print([1, 3, 4, 7].find_custom(is_even.bind())) # Prints 2
# Another example using `bind()` to pass an additional parameter:
func is_specific_number(number, expected):
    return number == expected
func _ready():
    print([1, 3, 4, 7].find_custom(is_specific_number.bind(4))) # Prints 2
```

---

Variant front() const 

Returns the first element of the array. If the array is empty, fails and returns null. See also back().

Note: Unlike with the [] operator (array[0]), an error is generated without stopping project execution.

---

Variant get(index: int) const 

Returns the element at the given index in the array. If index is out-of-bounds or negative, this method fails and returns null.

This method is similar (but not identical) to the [] operator. Most notably, when this method fails, it doesn't pause project execution if run from the editor.

---

int get_typed_builtin() const 

Returns the built-in Variant type of the typed array as a Variant.Type constant. If the array is not typed, returns @GlobalScope.TYPE_NIL. See also is_typed().

---

StringName get_typed_class_name() const 

Returns the built-in class name of the typed array, if the built-in Variant type @GlobalScope.TYPE_OBJECT. Otherwise, returns an empty StringName. See also is_typed() and Object.get_class().

---

Variant get_typed_script() const 

Returns the Script instance associated with this typed array, or null if it does not exist. See also is_typed().

---

bool has(value: Variant) const 

Returns true if the array contains the given value.

```
print(["inside", 7].has("inside"))  # Prints true
print(["inside", 7].has("outside")) # Prints false
print(["inside", 7].has(7))         # Prints true
print(["inside", 7].has("7"))       # Prints false
```

```
Godot.Collections.Array arr = ["inside", 7];
// By C# convention, this method is renamed to `Contains`.
GD.Print(arr.Contains("inside"));  // Prints True
GD.Print(arr.Contains("outside")); // Prints False
GD.Print(arr.Contains(7));         // Prints True
GD.Print(arr.Contains("7"));       // Prints False
```

In GDScript, this is equivalent to the in operator:

```gdscript
if 4 in [2, 4, 6, 8]:
    print("4 is here!") # Will be printed.
```

Note: For performance reasons, the search is affected by the value's Variant.Type. For example, 7 (int) and 7.0 (float) are not considered equal for this method.

---

int hash() const 

Returns a hashed 32-bit integer value representing the array and its contents.

Note: Arrays with equal hash values are not guaranteed to be the same, as a result of hash collisions. On the contrary, arrays with different hash values are guaranteed to be different.

---

int insert(position: int, value: Variant) 

Inserts a new element (value) at a given index (position) in the array. position should be between 0 and the array's size(). If negative, position is considered relative to the end of the array.

Returns @GlobalScope.OK on success, or one of the other Error constants if this method fails.

Note: Every element's index after position needs to be shifted forward, which may have a noticeable performance cost, especially on larger arrays.

---

bool is_empty() const 

Returns true if the array is empty ([]). See also size().

---

bool is_read_only() const 

Returns true if the array is read-only. See make_read_only().

In GDScript, arrays are automatically read-only if declared with the const keyword.

---

bool is_same_typed(array: Array) const 

Returns true if this array is typed the same as the given array. See also is_typed().

---

bool is_typed() const 

Returns true if the array is typed. Typed arrays can only contain elements of a specific type, as defined by the typed array constructor. The methods of a typed array are still expected to return a generic Variant.

In GDScript, it is possible to define a typed array with static typing:

```gdscript
var numbers: Array[float] = [0.2, 4.2, -2.0]
print(numbers.is_typed()) # Prints true
```

---

void make_read_only() 

Makes the array read-only. The array's elements cannot be overridden with different values, and their order cannot change. Does not apply to nested elements, such as dictionaries.

In GDScript, arrays are automatically read-only if declared with the const keyword.

---

Array map(method: Callable) const 

Calls the given Callable for each element in the array and returns a new array filled with values returned by the method.

The method should take one Variant parameter (the current array element) and can return any Variant.

```gdscript
func double(number):
    return number * 2
func _ready():
    print([1, 2, 3].map(double)) # Prints [2, 4, 6]
    # Same as above, but using a lambda function.
    print([1, 2, 3].map(func(element): return element * 2))
```

See also filter(), reduce(), any() and all().

---

Variant max() const 

Returns the maximum value contained in the array, if all elements can be compared. Otherwise, returns null. See also min().

To find the maximum value using a custom comparator, you can use reduce().

---

Variant min() const 

Returns the minimum value contained in the array, if all elements can be compared. Otherwise, returns null. See also max().

---

Variant pick_random() const 

Returns a random element from the array. Generates an error and returns null if the array is empty.

```
# May print 1, 2, 3.25, or "Hi".
print([1, 2, 3.25, "Hi"].pick_random())
```

```
Godot.Collections.Array array = [1, 2, 3.25f, "Hi"];
GD.Print(array.PickRandom()); // May print 1, 2, 3.25, or "Hi".
```

Note: Like many similar functions in the engine (such as @GlobalScope.randi() or shuffle()), this method uses a common, global random seed. To get a predictable outcome from this method, see @GlobalScope.seed().

---

Variant pop_at(position: int) 

Removes and returns the element of the array at index position. If negative, position is considered relative to the end of the array. Returns null if the array is empty. If position is out of bounds, an error message is also generated.

Note: This method shifts every element's index after position back, which may have a noticeable performance cost, especially on larger arrays.

---

Variant pop_back() 

Removes and returns the last element of the array. Returns null if the array is empty, without generating an error. See also pop_front().

---

Variant pop_front() 

Removes and returns the first element of the array. Returns null if the array is empty, without generating an error. See also pop_back().

Note: This method shifts every other element's index back, which may have a noticeable performance cost, especially on larger arrays.

---

void push_back(value: Variant) 

Appends an element at the end of the array. See also push_front().

---

void push_front(value: Variant) 

Adds an element at the beginning of the array. See also push_back().

Note: This method shifts every other element's index forward, which may have a noticeable performance cost, especially on larger arrays.

---

Variant reduce(method: Callable, accum: Variant = null) const 

Calls the given Callable for each element in array, accumulates the result in accum, then returns it.

The method takes two arguments: the current value of accum and the current array element. If accum is null (as by default), the iteration will start from the second element, with the first one used as initial value of accum.

```gdscript
func sum(accum, number):
    return accum + number
func _ready():
    print([1, 2, 3].reduce(sum, 0))  # Prints 6
    print([1, 2, 3].reduce(sum, 10)) # Prints 16
    # Same as above, but using a lambda function.
    print([1, 2, 3].reduce(func(accum, number): return accum + number, 10))
```

If max() is not desirable, this method may also be used to implement a custom comparator:

```gdscript
func _ready():
    var arr = [Vector2i(5, 0), Vector2i(3, 4), Vector2i(1, 2)]
    var longest_vec = arr.reduce(func(max, vec): return vec if is_length_greater(vec, max) else max)
    print(longest_vec) # Prints (3, 4)
func is_length_greater(a, b):
    return a.length() > b.length()
```

This method can also be used to count how many elements in an array satisfy a certain condition, similar to count():

```gdscript
func is_even(number):
    return number % 2 == 0
func _ready():
    var arr = [1, 2, 3, 4, 5]
    # If the current element is even, increment count, otherwise leave count the same.
    var even_count = arr.reduce(func(count, next): return count + 1 if is_even(next) else count, 0)
    print(even_count) # Prints 2
```

See also map(), filter(), any(), and all().

---

void remove_at(position: int) 

Removes the element from the array at the given index (position). If the index is out of bounds, this method fails. If the index is negative, position is considered relative to the end of the array.

If you need to return the removed element, use pop_at(). To remove an element by value, use erase() instead.

Note: This method shifts every element's index after position back, which may have a noticeable performance cost, especially on larger arrays.

---

int resize(size: int) 

Sets the array's number of elements to size. If size is smaller than the array's current size, the elements at the end are removed. If size is greater, new default elements (usually null) are added, depending on the array's type.

Returns @GlobalScope.OK on success, or one of the following Error constants if this method fails: @GlobalScope.ERR_LOCKED if the array is read-only, @GlobalScope.ERR_INVALID_PARAMETER if the size is negative, or @GlobalScope.ERR_OUT_OF_MEMORY if allocations fail. Use size() to find the actual size of the array after resize.

Note: Calling this method once and assigning the new values is faster than calling append() for every new element.

---

void reverse() 

Reverses the order of all elements in the array.

---

int rfind(what: Variant, from: int = -1) const 

Returns the index of the last occurrence of what in this array, or -1 if there are none. The search's start can be specified with from, continuing to the beginning of the array. This method is the reverse of find().

---

int rfind_custom(method: Callable, from: int = -1) const 

Returns the index of the last element of the array that causes method to return true, or -1 if there are none. The search's start can be specified with from, continuing to the beginning of the array. This method is the reverse of find_custom().

---

void set(index: int, value: Variant) 

Sets the value of the element at the given index to the given value. This will not change the size of the array, it only changes the value at an index already in the array. This is the same as using the [] operator (array[index] = value).

---

void shuffle() 

Shuffles all elements of the array in a random order.

Note: Like many similar functions in the engine (such as @GlobalScope.randi() or pick_random()), this method uses a common, global random seed. To get a predictable outcome from this method, see @GlobalScope.seed().

---

int size() const 

Returns the number of elements in the array. Empty arrays ([]) always return 0. See also is_empty().

---

Array slice(begin: int, end: int = 2147483647, step: int = 1, deep: bool = false) const 

Returns a new Array containing this array's elements, from index begin (inclusive) to end (exclusive), every step elements.

If either begin or end are negative, their value is relative to the end of the array.

If step is negative, this method iterates through the array in reverse, returning a slice ordered backwards. For this to work, begin must be greater than end.

If deep is true, all nested Array and Dictionary elements in the slice are duplicated from the original, recursively. See also duplicate().

```gdscript
var letters = ["A", "B", "C", "D", "E", "F"]
print(letters.slice(0, 2))  # Prints ["A", "B"]
print(letters.slice(2, -2)) # Prints ["C", "D"]
print(letters.slice(-2, 6)) # Prints ["E", "F"]
print(letters.slice(0, 6, 2))  # Prints ["A", "C", "E"]
print(letters.slice(4, 1, -1)) # Prints ["E", "D", "C"]
```

---

void sort() 

Sorts the array in ascending order. The final order is dependent on the "less than" (<) comparison between elements.

```
var numbers = [10, 5, 2.5, 8]
numbers.sort()
print(numbers) # Prints [2.5, 5, 8, 10]
```

```
Godot.Collections.Array numbers = [10, 5, 2.5, 8];
numbers.Sort();
GD.Print(numbers); // Prints [2.5, 5, 8, 10]
```

Note: The sorting algorithm used is not stable [https://en.wikipedia.org/wiki/Sorting_algorithm#Stability]. This means that equivalent elements (such as 2 and 2.0) may have their order changed when calling sort().

---

void sort_custom(func: Callable) 

Sorts the array using a custom Callable.

func is called as many times as necessary, receiving two array elements as arguments. The function should return true if the first element should be moved before the second one, otherwise it should return false.

```gdscript
func sort_ascending(a, b):
    if a[1] < b[1]:
        return true
    return false
func _ready():
    var my_items = [["Tomato", 5], ["Apple", 9], ["Rice", 4]]
    my_items.sort_custom(sort_ascending)
    print(my_items) # Prints [["Rice", 4], ["Tomato", 5], ["Apple", 9]]
    # Sort descending, using a lambda function.
    my_items.sort_custom(func(a, b): return a[1] > b[1])
    print(my_items) # Prints [["Apple", 9], ["Tomato", 5], ["Rice", 4]]
```

It may also be necessary to use this method to sort strings by natural order, with String.naturalnocasecmp_to(), as in the following example:

```gdscript
var files = ["newfile1", "newfile2", "newfile10", "newfile11"]
files.sort_custom(func(a, b): return a.naturalnocasecmp_to(b) < 0)
print(files) # Prints ["newfile1", "newfile2", "newfile10", "newfile11"]
```

Note: In C#, this method is not supported.

Note: The sorting algorithm used is not stable [https://en.wikipedia.org/wiki/Sorting_algorithm#Stability]. This means that values considered equal may have their order changed when calling this method.

Note: You should not randomize the return value of func, as the heapsort algorithm expects a consistent result. Randomizing the return value will result in unexpected behavior.

---

## Operator Descriptions

bool operator !=(right: Array) 

Returns true if the array's size or its elements are different than right's.

---

Array operator +(right: Array) 

Appends the right array to the left operand, creating a new Array. This is also known as an array concatenation.

```
var array1 = ["One", 2]
var array2 = [3, "Four"]
print(array1 + array2) # Prints ["One", 2, 3, "Four"]
```

```
// Note that concatenation is not possible with C#'s native Array type.
Godot.Collections.Array array1 = ["One", 2];
Godot.Collections.Array array2 = [3, "Four"];
GD.Print(array1 + array2); // Prints ["One", 2, 3, "Four"]
```

Note: For existing arrays, append_array() is much more efficient than concatenation and assignment with the += operator.

---

bool operator <(right: Array) 

Compares the elements of both arrays in order, starting from index 0 and ending on the last index in common between both arrays. For each pair of elements, returns true if this array's element is less than right's, false if this element is greater. Otherwise, continues to the next pair.

If all searched elements are equal, returns true if this array's size is less than right's, otherwise returns false.

---

bool operator <=(right: Array) 

Compares the elements of both arrays in order, starting from index 0 and ending on the last index in common between both arrays. For each pair of elements, returns true if this array's element is less than right's, false if this element is greater. Otherwise, continues to the next pair.

If all searched elements are equal, returns true if this array's size is less or equal to right's, otherwise returns false.

---

bool operator ==(right: Array) 

Compares the left operand Array against the right Array. Returns true if the sizes and contents of the arrays are equal, false otherwise.

---

bool operator >(right: Array) 

Compares the elements of both arrays in order, starting from index 0 and ending on the last index in common between both arrays. For each pair of elements, returns true if this array's element is greater than right's, false if this element is less. Otherwise, continues to the next pair.

If all searched elements are equal, returns true if this array's size is greater than right's, otherwise returns false.

---

bool operator >=(right: Array) 

Compares the elements of both arrays in order, starting from index 0 and ending on the last index in common between both arrays. For each pair of elements, returns true if this array's element is greater than right's, false if this element is less. Otherwise, continues to the next pair.

If all searched elements are equal, returns true if this array's size is greater or equal to right's, otherwise returns false.

---

Variant operator [](index: int) 

Returns the Variant element at the specified index. Arrays start at index 0. If index is greater or equal to 0, the element is fetched starting from the beginning of the array. If index is a negative value, the element is fetched starting from the end. Accessing an array out-of-bounds will cause a run-time error, pausing the project execution if run from the editor.
