# GDExtensionManager

Inherits: Object

Provides access to GDExtension functionality.

## Description

The GDExtensionManager loads, initializes, and keeps track of all available GDExtension libraries in the project.

Note: Do not worry about GDExtension unless you know what you are doing.

## Tutorials

- GDExtension overview
- GDExtension example in C++

## Methods

GDExtension | get_extension(path: String)
PackedStringArray | get_loaded_extensions() const
bool | is_extension_loaded(path: String) const
LoadStatus | load_extension(path: String)
LoadStatus | load_extension_from_function(path: String, init_func: const GDExtensionInitializationFunction*)
LoadStatus | reload_extension(path: String)
LoadStatus | unload_extension(path: String)

---

## Signals

extension_loaded(extension: GDExtension) 

Emitted after the editor has finished loading a new extension.

Note: This signal is only emitted in editor builds.

---

extension_unloading(extension: GDExtension) 

Emitted before the editor starts unloading an extension.

Note: This signal is only emitted in editor builds.

---

extensions_reloaded() 

Emitted after the editor has finished reloading one or more extensions.

---

## Enumerations

enum LoadStatus
LoadStatus LOAD_STATUS_OK = 0

The extension has loaded successfully.

LoadStatus LOAD_STATUS_FAILED = 1

The extension has failed to load, possibly because it does not exist or has missing dependencies.

LoadStatus LOAD_STATUS_ALREADY_LOADED = 2

The extension has already been loaded.

LoadStatus LOAD_STATUS_NOT_LOADED = 3

The extension has not been loaded.

LoadStatus LOAD_STATUS_NEEDS_RESTART = 4

The extension requires the application to restart to fully load.

---

## Method Descriptions

GDExtension get_extension(path: String) 

Returns the GDExtension at the given file path, or null if it has not been loaded or does not exist.

---

PackedStringArray get_loaded_extensions() const 

Returns the file paths of all currently loaded extensions.

---

bool is_extension_loaded(path: String) const 

Returns true if the extension at the given file path has already been loaded successfully. See also get_loaded_extensions().

---

LoadStatus load_extension(path: String) 

Loads an extension by absolute file path. The path needs to point to a valid GDExtension. Returns LOAD_STATUS_OK if successful.

---

LoadStatus load_extension_from_function(path: String, init_func: const GDExtensionInitializationFunction*) 

Loads the extension already in address space via the given path and initialization function. The path needs to be unique and start with "libgodot://". Returns LOAD_STATUS_OK if successful.

---

LoadStatus reload_extension(path: String) 

Reloads the extension at the given file path. The path needs to point to a valid GDExtension, otherwise this method may return either LOAD_STATUS_NOT_LOADED or LOAD_STATUS_FAILED.

Note: You can only reload extensions in the editor. In release builds, this method always fails and returns LOAD_STATUS_FAILED.

---

LoadStatus unload_extension(path: String) 

Unloads an extension by file path. The path needs to point to an already loaded GDExtension, otherwise this method returns LOAD_STATUS_NOT_LOADED.
