# PrimitiveMesh

Inherits: Mesh < Resource < RefCounted < Object

Inherited By: BoxMesh, CapsuleMesh, CylinderMesh, PlaneMesh, PointMesh, PrismMesh, RibbonTrailMesh, SphereMesh, TextMesh, TorusMesh, TubeTrailMesh

Base class for all primitive meshes. Handles applying a Material to a primitive mesh.

## Description

Base class for all primitive meshes. Handles applying a Material to a primitive mesh. Examples include BoxMesh, CapsuleMesh, CylinderMesh, PlaneMesh, PrismMesh, and SphereMesh.

## Properties

bool | add_uv2 | false
AABB | custom_aabb | AABB(0, 0, 0, 0, 0, 0)
bool | flip_faces | false
Material | material |
float | uv2_padding | 2.0

## Methods

Array | _create_mesh_array() virtual const
Array | get_mesh_arrays() const
void | request_update()

---

## Property Descriptions

bool add_uv2 = false 

- void set_add_uv2(value: bool)
- bool get_add_uv2()

If set, generates UV2 UV coordinates applying a padding using the uv2_padding setting. UV2 is needed for lightmapping.

---

AABB custom_aabb = AABB(0, 0, 0, 0, 0, 0) 

- void set_custom_aabb(value: AABB)
- AABB get_custom_aabb()

Overrides the AABB with one defined by user for use with frustum culling. Especially useful to avoid unexpected culling when using a shader to offset vertices.

---

bool flip_faces = false 

- void set_flip_faces(value: bool)
- bool get_flip_faces()

If true, the order of the vertices in each triangle is reversed, resulting in the backside of the mesh being drawn.

This gives the same result as using BaseMaterial3D.CULL_FRONT in BaseMaterial3D.cull_mode.

---

Material material 

- void set_material(value: Material)
- Material get_material()

The current Material of the primitive mesh.

---

float uv2_padding = 2.0 

- void set_uv2_padding(value: float)
- float get_uv2_padding()

If add_uv2 is set, specifies the padding in pixels applied along seams of the mesh. Lower padding values allow making better use of the lightmap texture (resulting in higher texel density), but may introduce visible lightmap bleeding along edges.

If the size of the lightmap texture can't be determined when generating the mesh, UV2 is calculated assuming a texture size of 1024x1024.

---

## Method Descriptions

Array _create_mesh_array() virtual const 

Override this method to customize how this primitive mesh should be generated. Should return an Array where each element is another Array of values required for the mesh (see the ArrayType constants).

---

Array get_mesh_arrays() const 

Returns the mesh arrays used to make up the surface of this primitive mesh.

Example: Pass the result to ArrayMesh.add_surface_from_arrays() to create a new surface:

```
var c = CylinderMesh.new()
var arr_mesh = ArrayMesh.new()
arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, c.get_mesh_arrays())
```

```
var c = new CylinderMesh();
var arrMesh = new ArrayMesh();
arrMesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, c.GetMeshArrays());
```

---

void request_update() 

Request an update of this primitive mesh based on its properties.
