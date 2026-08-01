# GLTFDocumentExtension

Inherits: Resource < RefCounted < Object

Inherited By: GLTFDocumentExtensionConvertImporterMesh

GLTFDocument extension class.

## Description

Extends the functionality of the GLTFDocument class by allowing you to run arbitrary code at various stages of glTF import or export.

To use, make a new class extending GLTFDocumentExtension, override any methods you need, make an instance of your class, and register it using GLTFDocument.register_gltf_document_extension().

Note: All GLTFDocumentExtension classes are duplicated when beginning the import or export process. Except for configuration values, these classes must be stateless in order to function properly. If you need to store data, use the set_additional_data and get_additional_data methods in GLTFState or GLTFNode.

## Tutorials

- Runtime file loading and saving

## Methods

void | _convert_scene_node(state: GLTFState, gltf_node: GLTFNode, scene_node: Node) virtual
Array[Dictionary] | _export_get_property_list(root_node: Node) virtual
Error | _export_node(state: GLTFState, gltf_node: GLTFNode, json: Dictionary, node: Node) virtual
GLTFObjectModelProperty | _export_object_model_property(state: GLTFState, node_path: NodePath, godot_node: Node, gltf_node_index: int, target_object: Object, target_depth: int) virtual
Error | _export_post(state: GLTFState) virtual
Error | _export_post_convert(state: GLTFState, root: Node) virtual
Error | _export_preflight(state: GLTFState, root: Node) virtual
Error | _export_preserialize(state: GLTFState) virtual
Node3D | _generate_scene_node(state: GLTFState, gltf_node: GLTFNode, scene_parent: Node) virtual
String | _get_image_file_extension() virtual
PackedStringArray | _get_saveable_image_formats() virtual
PackedStringArray | _get_supported_extensions() virtual
Error | _import_node(state: GLTFState, gltf_node: GLTFNode, json: Dictionary, node: Node) virtual
GLTFObjectModelProperty | _import_object_model_property(state: GLTFState, split_json_pointer: PackedStringArray, partial_paths: Array[NodePath]) virtual
Error | _import_post(state: GLTFState, root: Node) virtual
Error | _import_post_parse(state: GLTFState) virtual
Error | _import_pre_generate(state: GLTFState) virtual
Error | _import_preflight(state: GLTFState, extensions: PackedStringArray) virtual
Error | _parse_image_data(state: GLTFState, image_data: PackedByteArray, mime_type: String, ret_image: Image) virtual
Error | _parse_node_extensions(state: GLTFState, gltf_node: GLTFNode, extensions: Dictionary) virtual
Error | _parse_texture_json(state: GLTFState, texture_json: Dictionary, ret_gltf_texture: GLTFTexture) virtual
Error | _save_image_at_path(state: GLTFState, image: Image, file_path: String, image_format: String, lossy_quality: float) virtual
PackedByteArray | _serialize_image_to_bytes(state: GLTFState, image: Image, image_dict: Dictionary, image_format: String, lossy_quality: float) virtual
Error | _serialize_texture_json(state: GLTFState, texture_json: Dictionary, gltf_texture: GLTFTexture, image_format: String) virtual

---

## Method Descriptions

void _convert_scene_node(state: GLTFState, gltf_node: GLTFNode, scene_node: Node) virtual 

Part of the export process. This method is run after _export_preflight() and before _export_post_convert().

Runs when converting the data from a Godot scene node. This method can be used to process the Godot scene node data into a format that can be used by _export_node().

---

Array[Dictionary] _export_get_property_list(root_node: Node) virtual 

Runs prior to the export process. This method is run before _export_preflight() when exporting a scene from the editor, or it may not be run at all in other situations.

Unlike the rest of the export methods, this does not run when calling a GLTFDocument's export methods in sequence with everything else, but rather runs before that entire process occurs, allowing configuration to occur beforehand, potentially minutes or hours in advance of _export_preflight(). This allows extensions to decide which properties to show in the editor export settings dialog based on the contents of the scene, hiding any settings that are not relevant for that scene. The root_node parameter may be null, in which case all properties should be shown.

---

Error _export_node(state: GLTFState, gltf_node: GLTFNode, json: Dictionary, node: Node) virtual 

Part of the export process. This method is run after _get_saveable_image_formats() and before _export_post(). If this GLTFDocumentExtension is used for exporting images, this runs after _serialize_texture_json().

This method can be used to modify the final JSON of each node. Data should be primarily stored in gltf_node prior to serializing the JSON, but the original Godot Node is also provided if available. node may be null if not available, such as when exporting glTF data not generated from a Godot scene.

---

GLTFObjectModelProperty _export_object_model_property(state: GLTFState, node_path: NodePath, godot_node: Node, gltf_node_index: int, target_object: Object, target_depth: int) virtual 

Part of the export process. Allows GLTFDocumentExtension classes to provide mappings for properties of nodes in the Godot scene tree, to JSON pointers to glTF properties, as defined by the glTF object model.

Returns a GLTFObjectModelProperty instance that defines how the property should be mapped. If your extension can't handle the property, return null or an instance without any JSON pointers (see GLTFObjectModelProperty.has_json_pointers()). You should use GLTFObjectModelProperty.set_types() to set the types, and set the JSON pointer(s) using the GLTFObjectModelProperty.json_pointers property.

The parameters provide context for the property, including the NodePath, the Godot node, the GLTF node index, and the target object. The target_object will be equal to godot_node if no sub-object can be found, otherwise it will point to a sub-object. For example, if the path is ^"A/B/C/MeshInstance3D:mesh:surface_0/material:emission_intensity", it will get the node, then the mesh, and then the material, so target_object will be the Material resource, and target_depth will be 2 because 2 levels were traversed to get to the target.

---

Error _export_post(state: GLTFState) virtual 

Part of the export process. This method is run last, after all other parts of the export process.

This method can be used to modify the final JSON of the generated glTF file.

---

Error _export_post_convert(state: GLTFState, root: Node) virtual 

Part of the export process. This method is run after _convert_scene_node() and before _export_preserialize().

This method can be used to modify the converted node data structures before serialization with any additional data from the scene tree.

---

Error _export_preflight(state: GLTFState, root: Node) virtual 

Part of the export process. This method is run first, before all other parts of the export process.

The return value is used to determine if this GLTFDocumentExtension instance should be used for exporting a given glTF file. If @GlobalScope.OK, the export will use this GLTFDocumentExtension instance. If not overridden, @GlobalScope.OK is returned.

---

Error _export_preserialize(state: GLTFState) virtual 

Part of the export process. This method is run after _export_post_convert() and before _get_saveable_image_formats().

This method can be used to alter the state before performing serialization. It runs every time when generating a buffer with GLTFDocument.generate_buffer() or writing to the file system with GLTFDocument.write_to_filesystem().

---

Node3D _generate_scene_node(state: GLTFState, gltf_node: GLTFNode, scene_parent: Node) virtual 

Part of the import process. This method is run after _import_pre_generate() and before _import_node().

Runs when generating a Godot scene node from a GLTFNode. The returned node will be added to the scene tree. Multiple nodes can be generated in this step if they are added as a child of the returned node.

Note: The scene_parent parameter may be null if this is the single root node.

---

String _get_image_file_extension() virtual 

Returns the file extension to use for saving image data into, for example, ".png". If defined, when this extension is used to handle images, and the images are saved to a separate file, the image bytes will be copied to a file with this extension. If this is set, there should be a ResourceImporter class able to import the file. If not defined or empty, Godot will save the image into a PNG file.

---

PackedStringArray _get_saveable_image_formats() virtual 

Part of the export process. This method is run after _convert_scene_node() and before _export_node().

Returns an array of the image formats that can be saved/exported by this extension. This extension will only be selected as the image exporter if the GLTFDocument's GLTFDocument.image_format is in this array. If this GLTFDocumentExtension is selected as the image exporter, one of the _save_image_at_path() or _serialize_image_to_bytes() methods will run next, otherwise _export_node() will run next. If the format name contains "Lossy", the lossy quality slider will be displayed.

---

PackedStringArray _get_supported_extensions() virtual 

Part of the import process. This method is run after _import_preflight() and before _parse_node_extensions().

Returns an array of the glTF extensions supported by this GLTFDocumentExtension class. This is used to validate if a glTF file with required extensions can be loaded.

---

Error _import_node(state: GLTFState, gltf_node: GLTFNode, json: Dictionary, node: Node) virtual 

Part of the import process. This method is run after _generate_scene_node() and before _import_post().

This method can be used to make modifications to each of the generated Godot scene nodes.

---

GLTFObjectModelProperty _import_object_model_property(state: GLTFState, split_json_pointer: PackedStringArray, partial_paths: Array[NodePath]) virtual 

Part of the import process. Allows GLTFDocumentExtension classes to provide mappings for JSON pointers to glTF properties, as defined by the glTF object model, to properties of nodes in the Godot scene tree.

Returns a GLTFObjectModelProperty instance that defines how the property should be mapped. If your extension can't handle the property, return null or an instance without any NodePaths (see GLTFObjectModelProperty.has_node_paths()). You should use GLTFObjectModelProperty.set_types() to set the types, and GLTFObjectModelProperty.append_path_to_property() function is useful for most simple cases.

In many cases, partial_paths will contain the start of a path, allowing the extension to complete the path. For example, for /nodes/3/extensions/MY_ext/prop, Godot will pass you a NodePath that leads to node 3, so the GLTFDocumentExtension class only needs to resolve the last MY_ext/prop part of the path. In this example, the extension should check split.size() > 4 and split[0] == "nodes" and split[2] == "extensions" and split[3] == "MY_ext" at the start of the function to check if this JSON pointer applies to it, then it can use partial_paths and handle split[4].

---

Error _import_post(state: GLTFState, root: Node) virtual 

Part of the import process. This method is run last, after all other parts of the import process.

This method can be used to modify the final Godot scene generated by the import process.

---

Error _import_post_parse(state: GLTFState) virtual 

Part of the import process. This method is run after _parse_node_extensions() and before _import_pre_generate().

This method can be used to modify any of the data imported so far after parsing each node, but before generating the scene or any of its nodes.

---

Error _import_pre_generate(state: GLTFState) virtual 

Part of the import process. This method is run after _import_post_parse() and before _generate_scene_node().

This method can be used to modify or read from any of the processed data structures, before generating the nodes and then running the final per-node import step.

---

Error _import_preflight(state: GLTFState, extensions: PackedStringArray) virtual 

Part of the import process. This method is run first, before all other parts of the import process.

The return value is used to determine if this GLTFDocumentExtension instance should be used for importing a given glTF file. If @GlobalScope.OK, the import will use this GLTFDocumentExtension instance. If not overridden, @GlobalScope.OK is returned.

---

Error _parse_image_data(state: GLTFState, image_data: PackedByteArray, mime_type: String, ret_image: Image) virtual 

Part of the import process. This method is run after _parse_node_extensions() and before _parse_texture_json().

Runs when parsing image data from a glTF file. The data could be sourced from a separate file, a URI, or a buffer, and then is passed as a byte array.

---

Error _parse_node_extensions(state: GLTFState, gltf_node: GLTFNode, extensions: Dictionary) virtual 

Part of the import process. This method is run after _get_supported_extensions() and before _import_post_parse().

Runs when parsing the node extensions of a GLTFNode. This method can be used to process the extension JSON data into a format that can be used by _generate_scene_node(). The return value should be a member of the Error enum.

---

Error _parse_texture_json(state: GLTFState, texture_json: Dictionary, ret_gltf_texture: GLTFTexture) virtual 

Part of the import process. This method is run after _parse_image_data() and before _generate_scene_node().

Runs when parsing the texture JSON from the glTF textures array. This can be used to set the source image index to use as the texture.

---

Error _save_image_at_path(state: GLTFState, image: Image, file_path: String, image_format: String, lossy_quality: float) virtual 

Part of the export process. This method is run after _get_saveable_image_formats() and before _serialize_texture_json().

This method is run when saving images separately from the glTF file. When images are embedded, _serialize_image_to_bytes() runs instead. Note that these methods only run when this GLTFDocumentExtension is selected as the image exporter.

---

PackedByteArray _serialize_image_to_bytes(state: GLTFState, image: Image, image_dict: Dictionary, image_format: String, lossy_quality: float) virtual 

Part of the export process. This method is run after _get_saveable_image_formats() and before _serialize_texture_json().

This method is run when embedding images in the glTF file. When images are saved separately, _save_image_at_path() runs instead. Note that these methods only run when this GLTFDocumentExtension is selected as the image exporter.

This method must set the image MIME type in the image_dict with the "mimeType" key. For example, for a PNG image, it would be set to "image/png". The return value must be a PackedByteArray containing the image data.

---

Error _serialize_texture_json(state: GLTFState, texture_json: Dictionary, gltf_texture: GLTFTexture, image_format: String) virtual 

Part of the export process. This method is run after _save_image_at_path() or _serialize_image_to_bytes(), and before _export_node(). Note that this method only runs when this GLTFDocumentExtension is selected as the image exporter.

This method can be used to set up the extensions for the texture JSON by editing texture_json. The extension must also be added as used extension with GLTFState.add_used_extension(), be sure to set required to true if you are not providing a fallback.
