# GLTFPhysicsShape

Inherits: Resource < RefCounted < Object

Represents a glTF physics shape.

## Description

Represents a physics shape as defined by the OMI_physics_shape or OMI_collider glTF extensions. This class is an intermediary between the glTF data and Godot's nodes, and it's abstracted in a way that allows adding support for different glTF physics extensions in the future.

## Tutorials

- Runtime file loading and saving
- OMI_physics_shape glTF extension [https://github.com/omigroup/gltf-extensions/tree/main/extensions/2.0/OMI_physics_shape]
- OMI_collider glTF extension [https://github.com/omigroup/gltf-extensions/tree/main/extensions/2.0/Archived/OMI_collider]

## Properties

float | height | 2.0
ImporterMesh | importer_mesh |
bool | is_trigger | false
int | mesh_index | -1
float | radius | 0.5
String | shape_type | ""
Vector3 | size | Vector3(1, 1, 1)

## Methods

GLTFPhysicsShape | from_dictionary(dictionary: Dictionary) static
GLTFPhysicsShape | from_node(shape_node: CollisionShape3D) static
GLTFPhysicsShape | from_resource(shape_resource: Shape3D) static
Dictionary | to_dictionary() const
CollisionShape3D | to_node(cache_shapes: bool = false)
Shape3D | to_resource(cache_shapes: bool = false)

---

## Property Descriptions

float height = 2.0 

- void set_height(value: float)
- float get_height()

The height of the shape, in meters. This is only used when the shape type is "capsule" or "cylinder". This value should not be negative, and for "capsule" it should be at least twice the radius.

---

ImporterMesh importer_mesh 

- void set_importer_mesh(value: ImporterMesh)
- ImporterMesh get_importer_mesh()

The ImporterMesh resource of the shape. This is only used when the shape type is "hull" (convex hull) or "trimesh" (concave trimesh).

---

bool is_trigger = false 

- void set_is_trigger(value: bool)
- bool get_is_trigger()

If true, indicates that this shape is a trigger. For Godot, this means that the shape should be a child of an Area3D node.

This is the only variable not used in the to_node() method, it's intended to be used alongside when deciding where to add the generated node as a child.

---

int mesh_index = -1 

- void set_mesh_index(value: int)
- int get_mesh_index()

The index of the shape's mesh in the glTF file. This is only used when the shape type is "hull" (convex hull) or "trimesh" (concave trimesh).

---

float radius = 0.5 

- void set_radius(value: float)
- float get_radius()

The radius of the shape, in meters. This is only used when the shape type is "capsule", "cylinder", or "sphere". This value should not be negative.

---

String shape_type = "" 

- void set_shape_type(value: String)
- String get_shape_type()

The type of shape this shape represents. Valid values are "box", "capsule", "cylinder", "sphere", "hull", and "trimesh".

---

Vector3 size = Vector3(1, 1, 1) 

- void set_size(value: Vector3)
- Vector3 get_size()

The size of the shape, in meters. This is only used when the shape type is "box", and it represents the "diameter" of the box. This value should not be negative.

---

## Method Descriptions

GLTFPhysicsShape from_dictionary(dictionary: Dictionary) static 

Creates a new GLTFPhysicsShape instance by parsing the given Dictionary.

---

GLTFPhysicsShape from_node(shape_node: CollisionShape3D) static 

Creates a new GLTFPhysicsShape instance from the given Godot CollisionShape3D node.

---

GLTFPhysicsShape from_resource(shape_resource: Shape3D) static 

Creates a new GLTFPhysicsShape instance from the given Godot Shape3D resource.

---

Dictionary to_dictionary() const 

Serializes this GLTFPhysicsShape instance into a Dictionary in the format defined by OMI_physics_shape.

---

CollisionShape3D to_node(cache_shapes: bool = false) 

Converts this GLTFPhysicsShape instance into a Godot CollisionShape3D node.

---

Shape3D to_resource(cache_shapes: bool = false) 

Converts this GLTFPhysicsShape instance into a Godot Shape3D resource.
