# Engine extension APIs

This section introduces various ways in which you can extend the engine with C++ code.
You can use these APIs by creating a module.
Note that you can change the engine in many more ways than presented here — this section just presents
a subselection of common and useful ways to do it.

Alternatively, some of the functions presented here are also available through the
GDExtension API.
You can use them in C++ by creating a godot-cpp based GDExtension,
or with any of the community-created GDExtension implementations. Note though
that some aspects of the code or directory structures may be different in GDExtension compared to the module APIs.

- Custom modules in C++
- Vendor Runtime Module
- The GDExtension system
- Binding to external libraries
- Custom Godot servers
- Custom resource format loaders
- Custom AudioStreams
- Custom platform ports
