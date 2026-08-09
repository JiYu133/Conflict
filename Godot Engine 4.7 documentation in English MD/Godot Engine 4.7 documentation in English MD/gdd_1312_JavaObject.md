# JavaObject

Inherits: RefCounted < Object

Represents an object from the Java Native Interface.

## Description

Represents an object from the Java Native Interface. It can be returned from Java methods called on JavaClass or other JavaObjects. See JavaClassWrapper for an example.

Note: This class only works on Android. On any other platform, this class does nothing.

Note: This class is not to be confused with JavaScriptObject.

## Methods

JavaClass | get_java_class() const
bool | has_java_method(method: StringName) const

---

## Method Descriptions

JavaClass get_java_class() const 

Returns the JavaClass that this object is an instance of.

---

bool has_java_method(method: StringName) const 

Returns true if the given method name exists in the object's Java methods.
