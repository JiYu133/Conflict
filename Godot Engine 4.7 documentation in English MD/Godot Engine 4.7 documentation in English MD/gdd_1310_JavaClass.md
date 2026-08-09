# JavaClass

Inherits: RefCounted < Object

Represents a class from the Java Native Interface.

## Description

Represents a class from the Java Native Interface. It is returned from JavaClassWrapper.wrap().

Note: This class only works on Android. On any other platform, this class does nothing.

Note: This class is not to be confused with JavaScriptObject.

## Methods

String | get_java_class_name() const
Array[Dictionary] | get_java_method_list() const
JavaClass | get_java_parent_class() const
bool | has_java_method(method: StringName) const

---

## Method Descriptions

String get_java_class_name() const 

Returns the Java class name.

---

Array[Dictionary] get_java_method_list() const 

Returns the object's Java methods and their signatures as an Array of dictionaries, in the same format as Object.get_method_list().

---

JavaClass get_java_parent_class() const 

Returns a JavaClass representing the Java parent class of this class.

---

bool has_java_method(method: StringName) const 

Returns true if the given method name exists in the object's Java methods.
