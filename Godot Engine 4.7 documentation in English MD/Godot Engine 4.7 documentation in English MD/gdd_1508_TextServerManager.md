# TextServerManager

Inherits: Object

A singleton for managing TextServer implementations.

## Description

TextServerManager is the API backend for loading, enumerating, and switching TextServers.

Note: Switching text server at runtime is possible, but will invalidate all fonts and text buffers. Make sure to unload all controls, fonts, and themes before doing so.

## Methods

void | add_interface(interface: TextServer)
TextServer | find_interface(name: String) const
TextServer | get_interface(idx: int) const
int | get_interface_count() const
Array[Dictionary] | get_interfaces() const
TextServer | get_primary_interface() const
void | remove_interface(interface: TextServer)
void | set_primary_interface(index: TextServer)

---

## Signals

interface_added(interface_name: StringName) 

Emitted when a new interface has been added.

---

interface_removed(interface_name: StringName) 

Emitted when an interface is removed.

---

## Method Descriptions

void add_interface(interface: TextServer) 

Registers a TextServer interface.

---

TextServer find_interface(name: String) const 

Finds an interface by its name.

---

TextServer get_interface(idx: int) const 

Returns the interface registered at a given index.

---

int get_interface_count() const 

Returns the number of interfaces currently registered.

---

Array[Dictionary] get_interfaces() const 

Returns a list of available interfaces, with the index and name of each interface.

---

TextServer get_primary_interface() const 

Returns the primary TextServer interface currently in use.

---

void remove_interface(interface: TextServer) 

Removes an interface. All fonts and shaped text caches should be freed before removing an interface.

---

void set_primary_interface(index: TextServer) 

Sets the primary TextServer interface.
