# VisualShaderNodeParticleMeshEmitter

Inherits: VisualShaderNodeParticleEmitter < VisualShaderNode < Resource < RefCounted < Object

A visual shader node that makes particles emitted in a shape defined by a Mesh.

## Description

VisualShaderNodeParticleEmitter that makes the particles emitted in a shape of the assigned mesh. It will emit from the mesh's surfaces, either all or only the specified one.

## Properties

Mesh | mesh |
int | surface_index | 0
bool | use_all_surfaces | true

---

## Property Descriptions

Mesh mesh 

- void set_mesh(value: Mesh)
- Mesh get_mesh()

The Mesh that defines emission shape.

---

int surface_index = 0 

- void set_surface_index(value: int)
- int get_surface_index()

Index of the surface that emits particles. use_all_surfaces must be false for this to take effect.

---

bool use_all_surfaces = true 

- void set_use_all_surfaces(value: bool)
- bool is_use_all_surfaces()

If true, the particles will emit from all surfaces of the mesh.
