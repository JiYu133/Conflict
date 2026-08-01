# ClassDB

Inherits: Object

A class information repository.

## Description

Provides access to metadata stored for every available engine class.

Note: Script-defined classes with class_name are not part of ClassDB, so they will not return reflection data such as a method or property list. However, GDExtension-defined classes are part of ClassDB, so they will return reflection data.

## Methods

bool | can_instantiate(class: StringName) const
Variant | class_call_static(class: StringName, method: StringName, ...) vararg
bool | class_exists(class: StringName) const
APIType | class_get_api_type(class: StringName) const
PackedStringArray | class_get_enum_constants(class: StringName, enum: StringName, no_inheritance: bool = false) const
PackedStringArray | class_get_enum_list(class: StringName, no_inheritance: bool = false) const
int | class_get_integer_constant(class: StringName, name: StringName) const
StringName | class_get_integer_constant_enum(class: StringName, name: StringName, no_inheritance: bool = false) const
PackedStringArray | class_get_integer_constant_list(class: StringName, no_inheritance: bool = false) const
int | class_get_method_argument_count(class: StringName, method: StringName, no_inheritance: bool = false) const
Array[Dictionary] | class_get_method_list(class: StringName, no_inheritance: bool = false) const
Variant | class_get_property(object: Object, property: StringName) const
Variant | class_get_property_default_value(class: StringName, property: StringName) const
StringName | class_get_property_getter(class: StringName, property: StringName)
Array[Dictionary] | class_get_property_list(class: StringName, no_inheritance: bool = false) const
StringName | class_get_property_setter(class: StringName, property: StringName)
Dictionary | class_get_signal(class: StringName, signal: StringName) const
Array[Dictionary] | class_get_signal_list(class: StringName, no_inheritance: bool = false) const
bool | class_has_enum(class: StringName, name: StringName, no_inheritance: bool = false) const
bool | class_has_integer_constant(class: StringName, name: StringName) const
bool | class_has_method(class: StringName, method: StringName, no_inheritance: bool = false) const
bool | class_has_signal(class: StringName, signal: StringName) const
Error | class_set_property(object: Object, property: StringName, value: Variant) const
PackedStringArray | get_class_list() const
PackedStringArray | get_inheriters_from_class(class: StringName) const
StringName | get_parent_class(class: StringName) const
Variant | instantiate(class: StringName) const
bool | is_class_enabled(class: StringName) const
bool | is_class_enum_bitfield(class: StringName, enum: StringName, no_inheritance: bool = false) const
bool | is_parent_class(class: StringName, inherits: StringName) const

---

## Enumerations

enum APIType
APIType API_CORE = 0

Native Core class type.

APIType API_EDITOR = 1

Native Editor class type.

APIType API_EXTENSION = 2

GDExtension class type.

APIType API_EDITOR_EXTENSION = 3

GDExtension Editor class type.

APIType API_NONE = 4

Unknown class type.

---

## Method Descriptions

bool can_instantiate(class: StringName) const 

Returns true if objects can be instantiated from the specified class, otherwise returns false.

---

Variant class_call_static(class: StringName, method: StringName, ...) vararg 

Calls a static method on a class.

---

bool class_exists(class: StringName) const 

Returns whether the specified class is available or not.

---

APIType class_get_api_type(class: StringName) const 

Returns the API type of the specified class.

---

PackedStringArray class_get_enum_constants(class: StringName, enum: StringName, no_inheritance: bool = false) const 

Returns an array with all the keys in enum of class or its ancestry.

---

PackedStringArray class_get_enum_list(class: StringName, no_inheritance: bool = false) const 

Returns an array with all the enums of class or its ancestry.

---

int class_get_integer_constant(class: StringName, name: StringName) const 

Returns the value of the integer constant name of class or its ancestry. Always returns 0 when the constant could not be found.

---

StringName class_get_integer_constant_enum(class: StringName, name: StringName, no_inheritance: bool = false) const 

Returns which enum the integer constant name of class or its ancestry belongs to.

---

PackedStringArray class_get_integer_constant_list(class: StringName, no_inheritance: bool = false) const 

Returns an array with the names all the integer constants of class or its ancestry.

---

int class_get_method_argument_count(class: StringName, method: StringName, no_inheritance: bool = false) const 

Returns the number of arguments of the method method of class or its ancestry if no_inheritance is false.

---

Array[Dictionary] class_get_method_list(class: StringName, no_inheritance: bool = false) const 

Returns an array with all the methods of class or its ancestry if no_inheritance is false. Every element of the array is a Dictionary with the following keys: args, default_args, flags, id, name, return: (class_name, hint, hint_string, name, type, usage).

Note: In exported release builds the debug info is not available, so the returned dictionaries will contain only method names.

---

Variant class_get_property(object: Object, property: StringName) const 

Returns the value of property of object or its ancestry.

---

Variant class_get_property_default_value(class: StringName, property: StringName) const 

Returns the default value of property of class or its ancestor classes.

---

StringName class_get_property_getter(class: StringName, property: StringName) 

Returns the getter method name of property of class.

---

Array[Dictionary] class_get_property_list(class: StringName, no_inheritance: bool = false) const 

Returns an array with all the properties of class or its ancestry if no_inheritance is false.

---

StringName class_get_property_setter(class: StringName, property: StringName) 

Returns the setter method name of property of class.

---

Dictionary class_get_signal(class: StringName, signal: StringName) const 

Returns the signal data of class or its ancestry. The returned value is a Dictionary with the following keys: args, default_args, flags, id, name, return: (class_name, hint, hint_string, name, type, usage).

---

Array[Dictionary] class_get_signal_list(class: StringName, no_inheritance: bool = false) const 

Returns an array with all the signals of class or its ancestry if no_inheritance is false. Every element of the array is a Dictionary as described in class_get_signal().

---

bool class_has_enum(class: StringName, name: StringName, no_inheritance: bool = false) const 

Returns whether class or its ancestry has an enum called name or not.

---

bool class_has_integer_constant(class: StringName, name: StringName) const 

Returns whether class or its ancestry has an integer constant called name or not.

---

bool class_has_method(class: StringName, method: StringName, no_inheritance: bool = false) const 

Returns whether class (or its ancestry if no_inheritance is false) has a method called method or not.

---

bool class_has_signal(class: StringName, signal: StringName) const 

Returns whether class or its ancestry has a signal called signal or not.

---

Error class_set_property(object: Object, property: StringName, value: Variant) const 

Sets property value of object to value.

---

PackedStringArray get_class_list() const 

Returns the names of all engine classes available.

Note: Script-defined classes with class_name are not included in this list. Use ProjectSettings.get_global_class_list() to get a list of script-defined classes instead.

---

PackedStringArray get_inheriters_from_class(class: StringName) const 

Returns the names of all engine classes that directly or indirectly inherit from class.

---

StringName get_parent_class(class: StringName) const 

Returns the parent class of class.

---

Variant instantiate(class: StringName) const 

Creates an instance of class.

---

bool is_class_enabled(class: StringName) const 

Returns whether this class is enabled or not.

---

bool is_class_enum_bitfield(class: StringName, enum: StringName, no_inheritance: bool = false) const 

Returns whether class (or its ancestor classes if no_inheritance is false) has an enum called enum that is a bitfield.

---

bool is_parent_class(class: StringName, inherits: StringName) const 

Returns whether inherits is an ancestor of class or not.
