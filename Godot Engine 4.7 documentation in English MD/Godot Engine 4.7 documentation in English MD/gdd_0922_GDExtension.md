# GDExtension

Inherits: Resource < RefCounted < Object

A native library for GDExtension.

## Description

The GDExtension resource type represents a shared library [https://en.wikipedia.org/wiki/Shared_library] which can expand the functionality of the engine. The GDExtensionManager singleton is responsible for loading, reloading, and unloading GDExtension resources.

Note: GDExtension itself is not a scripting language and has no relation to GDScript resources.

## Tutorials

- GDExtension overview
- GDExtension example in C++

## Methods

InitializationLevel | get_minimum_library_initialization_level() const
bool | is_library_open() const

---

## Enumerations

enum InitializationLevel
InitializationLevel INITIALIZATION_LEVEL_CORE = 0

The library is initialized at the same time as the core features of the engine.

InitializationLevel INITIALIZATION_LEVEL_SERVERS = 1

The library is initialized at the same time as the engine's servers (such as RenderingServer or PhysicsServer3D).

InitializationLevel INITIALIZATION_LEVEL_SCENE = 2

The library is initialized at the same time as the engine's scene-related classes.

InitializationLevel INITIALIZATION_LEVEL_EDITOR = 3

The library is initialized at the same time as the engine's editor classes. Only happens when loading the GDExtension in the editor.

---

## Method Descriptions

InitializationLevel get_minimum_library_initialization_level() const 

Returns the lowest level required for this extension to be properly initialized (see the InitializationLevel enum).

---

bool is_library_open() const 

Returns true if this extension's library has been opened.
