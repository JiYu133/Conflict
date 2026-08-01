# What is GDExtension?

GDExtension is a Godot-specific technology that lets the engine interact with
native shared libraries [https://en.wikipedia.org/wiki/Shared_library]
at runtime. You can use it to run native code without compiling it with the engine.

There are three primary methods with which this is achieved:

- gdextension_interface.h: A set of C functions that Godot and a GDExtension can use to communicate.
- extension_api.json: A list of C functions that are exposed from Godot APIs (Core Features).
- *.gdextension: A file format read by Godot to load a GDExtension.

Most people create GDExtensions with some existing language binding, such as godot-cpp (for C++),
or one of the community-made ones.

## Version compatibility

See godot-cpp Version Compatibility, which applies to all GDExtensions.
