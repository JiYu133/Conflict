# The GDExtension system

GDExtension is a Godot-specific technology that lets the engine interact with
native shared libraries [https://en.wikipedia.org/wiki/Shared_library]
at runtime. You can use it to run native code without compiling it with the engine.

Note

GDExtension is not a scripting language and has no relation to
GDScript.

This section describes how GDExtension works, and is generally aimed at people wanting to make a GDExtension from
scratch, for example to create language bindings. If you want to use existing language bindings, please refer to other
articles instead, such as the articles about C++ (godot-cpp) or one of the
community-made ones.

- What is GDExtension?
- The .gdextension file
- The C interface JSON file
- GDExtension C example
