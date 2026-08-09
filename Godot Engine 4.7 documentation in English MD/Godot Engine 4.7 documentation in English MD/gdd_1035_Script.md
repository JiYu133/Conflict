# Script

Inherits: Resource < RefCounted < Object

Inherited By: CSharpScript, GDScript, ScriptExtension

A class stored as a resource.

## Description

A class stored as a resource. A script extends the functionality of all objects that instantiate it.

This is the base class for all scripts and should not be used directly. Trying to create a new script with this class will result in an error.

The new method of a script subclass creates a new instance. Object.set_script() extends an existing object, if that object's class matches one of the script's base classes.

## Tutorials

- Scripting documentation index

## Properties

String | source_code

## Methods

bool | can_instantiate() const
Script | get_base_script() const
StringName | get_global_name() const
StringName | get_instance_base_type() const
Variant | get_property_default_value(property: StringName)
Variant | get_rpc_config() const
Dictionary | get_script_constant_map()
Array[Dictionary] | get_script_method_list()
Array[Dictionary] | get_script_property_list()
Array[Dictionary] | get_script_signal_list()
bool | has_script_method(method_name: StringName) const
bool | has_script_signal(signal_name: StringName) const
bool | has_source_code() const
bool | instance_has(base_object: Object) const
bool | is_abstract() const
bool | is_tool() const
Error | reload(keep_state: bool = false)

---

## Property Descriptions

String source_code 

- void set_source_code(value: String)
- String get_source_code()

The script source code or an empty string if source code is not available. When set, does not reload the class implementation automatically.

---

## Method Descriptions

bool can_instantiate() const 

Returns true if the script can be instantiated.

---

Script get_base_script() const 

Returns the script directly inherited by this script.

---

StringName get_global_name() const 

Returns the class name associated with the script, if there is one. Returns an empty string otherwise.

To give the script a global name, you can use the class_name keyword in GDScript and the [GlobalClass] attribute in C#.

```
class_name MyNode
extends Node
```

```
using Godot;
[GlobalClass]
public partial class MyNode : Node
{
}
```

---

StringName get_instance_base_type() const 

Returns the script's base type.

---

Variant get_property_default_value(property: StringName) 

Returns the default value of the specified property.

---

Variant get_rpc_config() const 

Returns a Dictionary mapping method names to their RPC configuration defined by this script.

---

Dictionary get_script_constant_map() 

Returns a dictionary containing constant names and their values.

---

Array[Dictionary] get_script_method_list() 

Returns the list of methods in this Script.

Note: The dictionaries returned by this method are formatted identically to those returned by Object.get_method_list().

---

Array[Dictionary] get_script_property_list() 

Returns the list of properties in this Script.

Note: The dictionaries returned by this method are formatted identically to those returned by Object.get_property_list().

---

Array[Dictionary] get_script_signal_list() 

Returns the list of signals defined in this Script.

Note: The dictionaries returned by this method are formatted identically to those returned by Object.get_signal_list().

---

bool has_script_method(method_name: StringName) const 

Returns true if the script, or a base class, defines a method with the given name.

---

bool has_script_signal(signal_name: StringName) const 

Returns true if the script, or a base class, defines a signal with the given name.

---

bool has_source_code() const 

Returns true if the script contains non-empty source code.

Note: If a script does not have source code, this does not mean that it is invalid or unusable. For example, a GDScript that was exported with binary tokenization has no source code, but still behaves as expected and could be instantiated. This can be checked with can_instantiate().

---

bool instance_has(base_object: Object) const 

Deprecated: Compare this script with Object.get_script() instead.

Returns true if base_object is an instance of this script.

---

bool is_abstract() const 

Returns true if the script is an abstract script. An abstract script does not have a constructor and cannot be instantiated.

---

bool is_tool() const 

Returns true if the script is a tool script. A tool script can run in the editor.

---

Error reload(keep_state: bool = false) 

Reloads the script's class implementation. Returns an error code.
