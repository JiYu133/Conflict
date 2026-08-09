# EncodedObjectAsID

Inherits: RefCounted < Object

Holds a reference to an Object's instance ID.

## Description

Utility class which holds a reference to the internal identifier of an Object instance, as given by Object.get_instance_id(). This ID can then be used to retrieve the object instance with @GlobalScope.instance_from_id().

This class is used internally by the editor inspector and script debugger, but can also be used in plugins to pass and display objects as their IDs.

## Properties

int | object_id | 0

---

## Property Descriptions

int object_id = 0 

- void set_object_id(value: int)
- int get_object_id()

The Object identifier stored in this EncodedObjectAsID instance. The object instance can be retrieved with @GlobalScope.instance_from_id().
