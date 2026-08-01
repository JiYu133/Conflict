# GLTFDocument

Inherits: Resource < RefCounted < Object

Inherited By: FBXDocument

Class for importing and exporting glTF files in and out of Godot.

## Description

GLTFDocument supports reading data from a glTF file, buffer, or Godot scene. This data can then be written to the filesystem, buffer, or used to create a Godot scene.

All of the data in a glTF scene is stored in the GLTFState class. GLTFDocument processes state objects, but does not contain any scene data itself. GLTFDocument has member variables to store export configuration settings such as the image format, but is otherwise stateless. Multiple scenes can be processed with the same settings using the same GLTFDocument object and different GLTFState objects.

GLTFDocument can be extended with arbitrary functionality by extending the GLTFDocumentExtension class and registering it with GLTFDocument via register_gltf_document_extension(). This allows for custom data to be imported and exported.

## Tutorials

- Runtime file loading and saving
- glTF 'What the duck?' guide [https://www.khronos.org/files/gltf20-reference-guide.pdf]
- Khronos glTF specification [https://registry.khronos.org/glTF/]

## Properties

String | fallback_image_format | "None"
float | fallback_image_quality | 0.25
String | image_format | "PNG"
float | lossy_quality | 0.75
RootNodeMode | root_node_mode | 0
TextureMapMode | texture_map_mode | 1
VisibilityMode | visibility_mode | 0

## Methods

Error | append_from_buffer(bytes: PackedByteArray, base_path: String, state: GLTFState, flags: int = 0)
Error | append_from_file(path: String, state: GLTFState, flags: int = 0, base_path: String = "")
Error | append_from_scene(node: Node, state: GLTFState, flags: int = 0)
GLTFObjectModelProperty | export_object_model_property(state: GLTFState, node_path: NodePath, godot_node: Node, gltf_node_index: int) static
PackedByteArray | generate_buffer(state: GLTFState)
Node | generate_scene(state: GLTFState, bake_fps: float = 30, trimming: bool = false, remove_immutable_tracks: bool = true)
PackedStringArray | get_supported_gltf_extensions() static
GLTFObjectModelProperty | import_object_model_property(state: GLTFState, json_pointer: String) static
void | register_gltf_document_extension(extension: GLTFDocumentExtension, first_priority: bool = false) static
void | unregister_gltf_document_extension(extension: GLTFDocumentExtension) static
Error | write_to_filesystem(state: GLTFState, path: String)

---

## Enumerations

enum RootNodeMode
RootNodeMode ROOT_NODE_MODE_SINGLE_ROOT = 0

Treat the Godot scene's root node as the root node of the glTF file, and mark it as the single root node via the GODOT_single_root glTF extension. This will be parsed the same as ROOT_NODE_MODE_KEEP_ROOT if the implementation does not support GODOT_single_root.

RootNodeMode ROOT_NODE_MODE_KEEP_ROOT = 1

Treat the Godot scene's root node as the root node of the glTF file, but do not mark it as anything special. An extra root node will be generated when importing into Godot. This uses only vanilla glTF features. This is equivalent to the behavior in Godot 4.1 and earlier.

RootNodeMode ROOT_NODE_MODE_MULTI_ROOT = 2

Treat the Godot scene's root node as the name of the glTF scene, and add all of its children as root nodes of the glTF file. This uses only vanilla glTF features. This avoids an extra root node, but only the name of the Godot scene's root node will be preserved, as it will not be saved as a node.

---

enum TextureMapMode
TextureMapMode TEXTURE_MAP_MODE_DO_NOT_REMAP = 0

Import the texture maps in the glTF file as they are, without trying to fit them into specific texture slots suitable for Godot's built-in materials. This may be desirable if using the glTF file with custom shaders, but may not display correctly with Godot's built-in materials. This is equivalent to the behavior in Godot 4.6 and earlier.

TextureMapMode TEXTURE_MAP_MODE_REMAP_TO_STANDARD_MATERIAL = 1

Import the texture maps in the glTF file remapped to the most suitable texture slots based on Godot's StandardMaterial3D class. This is the default behavior.

---

enum VisibilityMode
VisibilityMode VISIBILITY_MODE_INCLUDE_REQUIRED = 0

If the scene contains any non-visible nodes, include them, mark them as non-visible with KHR_node_visibility, and require that importers respect their non-visibility. Downside: If the importer does not support KHR_node_visibility, the file cannot be imported.

VisibilityMode VISIBILITY_MODE_INCLUDE_OPTIONAL = 1

If the scene contains any non-visible nodes, include them, mark them as non-visible with KHR_node_visibility, and do not impose any requirements on importers. Downside: If the importer does not support KHR_node_visibility, invisible objects will be visible.

VisibilityMode VISIBILITY_MODE_EXCLUDE = 2

If the scene contains any non-visible nodes, do not include them in the export. This is the same as the behavior in Godot 4.4 and earlier. Downside: Invisible nodes will not exist in the exported file.

---

flags ImportFlags: 

ImportFlags IMPORT_FLAG_GENERATE_TANGENT_ARRAYS = 8

If true, generate vertex tangents using Mikktspace [http://www.mikktspace.com/] if the input meshes don't have tangent data. When possible, it's recommended to let the 3D modeling software generate tangents on export instead of relying on this option. Tangents are required for correct display of normal and height maps, along with any material/shader features that require tangents.

If you don't need material features that require tangents, disabling this can reduce output file size and speed up importing if the source 3D file doesn't contain tangents.

ImportFlags IMPORT_FLAG_USE_NAMED_SKIN_BINDS = 16

If checked, use named Skins for animation. The MeshInstance3D node contains 3 properties of relevance here: a skeleton NodePath pointing to the Skeleton3D node (usually ..), a mesh, and a skin:

- The Skeleton3D node contains a list of bones with names, their pose and rest, a name, and a parent bone.
- The mesh is all of the raw vertex data needed to display a mesh. In terms of the mesh, it knows how vertices are weight-painted and uses some internal numbering often imported from 3D modeling software.
- The skin contains the information necessary to bind this mesh onto this Skeleton3D. For each of the internal bone IDs chosen by the 3D modeling software, it contains two things. Firstly, a matrix known as the Bind Pose Matrix, Inverse Bind Matrix, or IBM for short. Secondly, the Skin contains each bone's name (if this flag is enabled), or the bone's index within the Skeleton3D list (if this flag is disabled).

Together, this information is enough to tell Godot how to use the bone poses in the Skeleton3D node to render the mesh from each MeshInstance3D. Note that each MeshInstance3D may share binds, as is common in models exported from Blender, or each MeshInstance3D may use a separate Skin object, as is common in models exported from other tools such as Maya.

ImportFlags IMPORT_FLAG_DISCARD_MESHES_AND_MATERIALS = 32

Ignore meshes and materials on import. When importing a scene as an AnimationLibrary, this flag is always enabled.

ImportFlags IMPORT_FLAG_FORCE_DISABLE_MESH_COMPRESSION = 64

If true, mesh compression will not be used. Consider enabling if you notice blocky artifacts in your mesh normals or UVs, or if you have meshes that are larger than a few thousand meters in each direction.

---

## Property Descriptions

String fallback_image_format = "None" 

- void set_fallback_image_format(value: String)
- String get_fallback_image_format()

The user-friendly name of the fallback image format. This is used when exporting the glTF file, including writing to a file and writing to a byte array.

This property may only be one of "None", "PNG", or "JPEG", and is only used when the image_format is not one of "None", "PNG", or "JPEG". If having multiple extension image formats is desired, that can be done using a GLTFDocumentExtension class - this property only covers the use case of providing a base glTF fallback image when using a custom image format.

---

float fallback_image_quality = 0.25 

- void set_fallback_image_quality(value: float)
- float get_fallback_image_quality()

The quality of the fallback image, if any. For PNG files, this downscales the image on both dimensions by this factor. For JPEG files, this is the lossy quality of the image. A low value is recommended, since including multiple high quality images in a glTF file defeats the file size gains of using a more efficient image format.

---

String image_format = "PNG" 

- void set_image_format(value: String)
- String get_image_format()

The user-friendly name of the export image format. This is used when exporting the glTF file, including writing to a file and writing to a byte array.

By default, Godot allows the following options: "None", "PNG", "JPEG", "Lossless WebP", and "Lossy WebP". Support for more image formats can be added in GLTFDocumentExtension classes. A single extension class can provide multiple options for the specific format to use, or even an option that uses multiple formats at once.

---

float lossy_quality = 0.75 

- void set_lossy_quality(value: float)
- float get_lossy_quality()

If image_format is a lossy image format, this determines the lossy quality of the image. On a range of 0.0 to 1.0, where 0.0 is the lowest quality and 1.0 is the highest quality. A lossy quality of 1.0 is not the same as lossless.

---

RootNodeMode root_node_mode = 0 

- void set_root_node_mode(value: RootNodeMode)
- RootNodeMode get_root_node_mode()

How to process the root node during export. The default and recommended value is ROOT_NODE_MODE_SINGLE_ROOT.

Note: Regardless of how the glTF file is exported, when importing, the root node type and name can be overridden in the scene import settings tab.

---

TextureMapMode texture_map_mode = 1 

- void set_texture_map_mode(value: TextureMapMode)
- TextureMapMode get_texture_map_mode()

How to handle texture maps during import. The default and recommended value is TEXTURE_MAP_MODE_REMAP_TO_STANDARD_MATERIAL, which automatically remaps from glTF's flexible texture map system to the more specific texture map slots in Godot's StandardMaterial3D class. Alternatively, TEXTURE_MAP_MODE_DO_NOT_REMAP can be used to preserve the original texture maps from the glTF file, which may be desirable if using the glTF file with custom shaders, but may not display correctly with Godot's built-in materials.

---

VisibilityMode visibility_mode = 0 

- void set_visibility_mode(value: VisibilityMode)
- VisibilityMode get_visibility_mode()

How to deal with node visibility during export. This setting does nothing if all nodes are visible. The default and recommended value is VISIBILITY_MODE_INCLUDE_REQUIRED, which uses the KHR_node_visibility extension.

---

## Method Descriptions

Error append_from_buffer(bytes: PackedByteArray, base_path: String, state: GLTFState, flags: int = 0) 

Takes a PackedByteArray defining a glTF and imports the data to the given GLTFState object through the state parameter.

Note: The base_path tells append_from_buffer() where to find dependencies and can be empty.

---

Error append_from_file(path: String, state: GLTFState, flags: int = 0, base_path: String = "") 

Takes a path to a glTF file and imports the data at that file path to the given GLTFState object through the state parameter.

Note: The base_path tells append_from_file() where to find dependencies and can be empty.

---

Error append_from_scene(node: Node, state: GLTFState, flags: int = 0) 

Takes a Godot Engine scene node and exports it and its descendants to the given GLTFState object through the state parameter.

---

GLTFObjectModelProperty export_object_model_property(state: GLTFState, node_path: NodePath, godot_node: Node, gltf_node_index: int) static 

Determines a mapping between the given Godot node_path and the corresponding glTF Object Model JSON pointer(s) in the generated glTF file. The details of this mapping are returned in a GLTFObjectModelProperty object. Additional mappings can be supplied via the GLTFDocumentExtension._import_object_model_property() callback method.

---

PackedByteArray generate_buffer(state: GLTFState) 

Takes a GLTFState object through the state parameter and returns a glTF PackedByteArray.

---

Node generate_scene(state: GLTFState, bake_fps: float = 30, trimming: bool = false, remove_immutable_tracks: bool = true) 

Takes a GLTFState object through the state parameter and returns a Godot Engine scene node.

The bake_fps parameter overrides the bake_fps in state.

---

PackedStringArray get_supported_gltf_extensions() static 

Returns a list of all support glTF extensions, including extensions supported directly by the engine, and extensions supported by user plugins registering GLTFDocumentExtension classes.

Note: If this method is run before a GLTFDocumentExtension is registered, its extensions won't be included in the list. Be sure to only run this method after all extensions are registered. If you run this when the engine starts, consider waiting a frame before calling this method to ensure all extensions are registered.

---

GLTFObjectModelProperty import_object_model_property(state: GLTFState, json_pointer: String) static 

Determines a mapping between the given glTF Object Model json_pointer and the corresponding Godot node path(s) in the generated Godot scene. The details of this mapping are returned in a GLTFObjectModelProperty object. Additional mappings can be supplied via the GLTFDocumentExtension._export_object_model_property() callback method.

---

void register_gltf_document_extension(extension: GLTFDocumentExtension, first_priority: bool = false) static 

Registers the given GLTFDocumentExtension instance with GLTFDocument. If first_priority is true, this extension will be run first. Otherwise, it will be run last.

Note: Like GLTFDocument itself, all GLTFDocumentExtension classes must be stateless in order to function properly. If you need to store data, use the set_additional_data and get_additional_data methods in GLTFState or GLTFNode.

---

void unregister_gltf_document_extension(extension: GLTFDocumentExtension) static 

Unregisters the given GLTFDocumentExtension instance.

---

Error write_to_filesystem(state: GLTFState, path: String) 

Takes a GLTFState object through the state parameter and writes a glTF file to the filesystem.

Note: The extension of the glTF file determines if it is a .glb binary file or a .gltf text file.
