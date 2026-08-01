# PlaceholderMesh

Inherits: Mesh < Resource < RefCounted < Object

Placeholder class for a mesh.

## Description

This class is used when loading a project that uses a Mesh subclass in 2 conditions:

- When running the project exported in dedicated server mode, only the texture's dimensions are kept (as they may be relied upon for gameplay purposes or positioning of other elements). This allows reducing the exported PCK's size significantly.
- When this subclass is missing due to using a different engine version or build (e.g. modules disabled).

## Properties

AABB | aabb | AABB(0, 0, 0, 0, 0, 0)

---

## Property Descriptions

AABB aabb = AABB(0, 0, 0, 0, 0, 0) 

- void set_aabb(value: AABB)
- AABB get_aabb()

The smallest AABB enclosing this mesh in local space.
