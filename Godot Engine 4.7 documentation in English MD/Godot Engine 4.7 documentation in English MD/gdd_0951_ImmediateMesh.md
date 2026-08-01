# ImmediateMesh

Inherits: Mesh < Resource < RefCounted < Object

Mesh optimized for creating geometry manually.

## Description

A mesh type optimized for creating geometry manually, similar to OpenGL 1.x immediate mode.

Here's a sample on how to generate a triangular face:

```
var mesh = ImmediateMesh.new()
mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
mesh.surface_add_vertex(Vector3.LEFT)
mesh.surface_add_vertex(Vector3.FORWARD)
mesh.surface_add_vertex(Vector3.ZERO)
mesh.surface_end()
```

```
var mesh = new ImmediateMesh();
mesh.SurfaceBegin(Mesh.PrimitiveType.Triangles);
mesh.SurfaceAddVertex(Vector3.Left);
mesh.SurfaceAddVertex(Vector3.Forward);
mesh.SurfaceAddVertex(Vector3.Zero);
mesh.SurfaceEnd();
```

Note: Generating complex geometries with ImmediateMesh is highly inefficient. Instead, it is designed to generate simple geometry that changes often.

## Tutorials

- Using ImmediateMesh

## Methods

void | clear_surfaces()
void | surface_add_vertex(vertex: Vector3)
void | surface_add_vertex_2d(vertex: Vector2)
void | surface_begin(primitive: PrimitiveType, material: Material = null)
void | surface_end()
void | surface_set_color(color: Color)
void | surface_set_normal(normal: Vector3)
void | surface_set_tangent(tangent: Plane)
void | surface_set_uv(uv: Vector2)
void | surface_set_uv2(uv2: Vector2)

---

## Method Descriptions

void clear_surfaces() 

Clear all surfaces.

---

void surface_add_vertex(vertex: Vector3) 

Add a 3D vertex using the current attributes previously set.

---

void surface_add_vertex_2d(vertex: Vector2) 

Add a 2D vertex using the current attributes previously set.

---

void surface_begin(primitive: PrimitiveType, material: Material = null) 

Begin a new surface.

---

void surface_end() 

End and commit current surface. Note that surface being created will not be visible until this function is called.

---

void surface_set_color(color: Color) 

Set the color attribute that will be pushed with the next vertex.

---

void surface_set_normal(normal: Vector3) 

Set the normal attribute that will be pushed with the next vertex.

---

void surface_set_tangent(tangent: Plane) 

Set the tangent attribute that will be pushed with the next vertex.

Note: Even though tangent is a Plane, it does not directly represent the tangent plane. Its Plane.x, Plane.y, and Plane.z represent the tangent vector and Plane.d should be either -1 or 1. See also Mesh.ARRAY_TANGENT.

---

void surface_set_uv(uv: Vector2) 

Set the UV attribute that will be pushed with the next vertex.

---

void surface_set_uv2(uv2: Vector2) 

Set the UV2 attribute that will be pushed with the next vertex.
