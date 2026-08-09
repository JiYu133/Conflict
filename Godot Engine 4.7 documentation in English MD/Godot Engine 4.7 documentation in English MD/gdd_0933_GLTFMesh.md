# GLTFMesh

Inherits: Resource < RefCounted < Object

GLTFMesh represents a glTF mesh.

## Description

GLTFMesh handles 3D mesh data imported from glTF files. It includes properties for blend channels, blend weights, instance materials, and the mesh itself.

## Tutorials

- Runtime file loading and saving

## Properties

PackedFloat32Array | blend_weights | PackedFloat32Array()
Array[Material] | instance_materials | []
ImporterMesh | mesh |
String | original_name | ""

## Methods

Variant | get_additional_data(extension_name: StringName)
void | set_additional_data(extension_name: StringName, additional_data: Variant)

---

## Property Descriptions

PackedFloat32Array blend_weights = PackedFloat32Array() 

- void set_blend_weights(value: PackedFloat32Array)
- PackedFloat32Array get_blend_weights()

An array of floats representing the blend weights of the mesh.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedFloat32Array for more details.

---

Array[Material] instance_materials = [] 

- void set_instance_materials(value: Array[Material])
- Array[Material] get_instance_materials()

An array of Material objects representing the materials used in the mesh.

---

ImporterMesh mesh 

- void set_mesh(value: ImporterMesh)
- ImporterMesh get_mesh()

The ImporterMesh object representing the mesh itself.

---

String original_name = "" 

- void set_original_name(value: String)
- String get_original_name()

The original name of the mesh.

---

## Method Descriptions

Variant get_additional_data(extension_name: StringName) 

Gets additional arbitrary data in this GLTFMesh instance. This can be used to keep per-node state data in GLTFDocumentExtension classes, which is important because they are stateless.

The argument should be the GLTFDocumentExtension name (does not have to match the extension name in the glTF file), and the return value can be anything you set. If nothing was set, the return value is null.

---

void set_additional_data(extension_name: StringName, additional_data: Variant) 

Sets additional arbitrary data in this GLTFMesh instance. This can be used to keep per-node state data in GLTFDocumentExtension classes, which is important because they are stateless.

The first argument should be the GLTFDocumentExtension name (does not have to match the extension name in the glTF file), and the second argument can be anything you want.
