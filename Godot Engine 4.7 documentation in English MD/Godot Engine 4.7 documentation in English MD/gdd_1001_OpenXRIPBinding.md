# OpenXRIPBinding

Inherits: Resource < RefCounted < Object

Defines a binding between an OpenXRAction and an XR input or output.

## Description

This binding resource binds an OpenXRAction to an input or output. As most controllers have left hand and right versions that are handled by the same interaction profile we can specify multiple bindings. For instance an action "Fire" could be bound to both "/user/hand/left/input/trigger" and "/user/hand/right/input/trigger". This would require two binding entries.

## Properties

OpenXRAction | action |
Array | binding_modifiers | []
String | binding_path | ""
PackedStringArray | paths |

## Methods

void | add_path(path: String)
OpenXRActionBindingModifier | get_binding_modifier(index: int) const
int | get_binding_modifier_count() const
int | get_path_count() const
bool | has_path(path: String) const
void | remove_path(path: String)

---

## Property Descriptions

OpenXRAction action 

- void set_action(value: OpenXRAction)
- OpenXRAction get_action()

OpenXRAction that is bound to binding_path.

---

Array binding_modifiers = [] 

- void set_binding_modifiers(value: Array)
- Array get_binding_modifiers()

Binding modifiers for this binding.

---

String binding_path = "" 

- void set_binding_path(value: String)
- String get_binding_path()

Binding path that defines the input or output bound to action.

Note: Binding paths are suggestions, an XR runtime may choose to bind the action to a different input or output emulating this input or output.

---

PackedStringArray paths 

- void set_paths(value: PackedStringArray)
- PackedStringArray get_paths()

Deprecated: Use binding_path instead.

Paths that define the inputs or outputs bound on the device.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedStringArray for more details.

---

## Method Descriptions

void add_path(path: String) 

Deprecated: Binding is for a single path.

Add an input/output path to this binding.

---

OpenXRActionBindingModifier get_binding_modifier(index: int) const 

Get the OpenXRBindingModifier at this index.

---

int get_binding_modifier_count() const 

Get the number of binding modifiers for this binding.

---

int get_path_count() const 

Deprecated: Binding is for a single path.

Get the number of input/output paths in this binding.

---

bool has_path(path: String) const 

Deprecated: Binding is for a single path.

Returns true if this input/output path is part of this binding.

---

void remove_path(path: String) 

Deprecated: Binding is for a single path.

Removes this input/output path from this binding.
