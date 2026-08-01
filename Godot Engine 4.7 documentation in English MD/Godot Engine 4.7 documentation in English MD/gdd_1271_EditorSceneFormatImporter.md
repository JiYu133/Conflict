# EditorSceneFormatImporter

Inherits: RefCounted < Object

Inherited By: EditorSceneFormatImporterBlend, EditorSceneFormatImporterFBX2GLTF, EditorSceneFormatImporterGLTF, EditorSceneFormatImporterUFBX

Imports scenes from third-parties' 3D files.

## Description

EditorSceneFormatImporter allows to define an importer script for a third-party 3D format.

To use EditorSceneFormatImporter, register it using the EditorPlugin.add_scene_format_importer_plugin() method first.

## Methods

PackedStringArray | _get_extensions() virtual required const
void | _get_import_options(path: String) virtual
Variant | _get_option_visibility(path: String, for_animation: bool, option: String) virtual const
Object | _import_scene(path: String, flags: int, options: Dictionary) virtual required
void | add_import_option(name: String, value: Variant)
void | add_import_option_advanced(type: Variant.Type, name: String, default_value: Variant, hint: PropertyHint = 0, hint_string: String = "", usage_flags: int = 6)

---

## Enumerations

flags ImportFlags: 

ImportFlags IMPORT_SCENE = 1

Unused flag (this has no effect when enabled).

ImportFlags IMPORT_ANIMATION = 2

Import animations from the 3D scene. When importing a scene as an AnimationLibrary, this flag is always enabled.

ImportFlags IMPORT_FAIL_ON_MISSING_DEPENDENCIES = 4

Unused flag (this has no effect when enabled).

ImportFlags IMPORT_GENERATE_TANGENT_ARRAYS = 8

If true, generate vertex tangents using Mikktspace [http://www.mikktspace.com/] if the input meshes don't have tangent data. When possible, it's recommended to let the 3D modeling software generate tangents on export instead of relying on this option. Tangents are required for correct display of normal and height maps, along with any material/shader features that require tangents.

If you don't need material features that require tangents, disabling this can reduce output file size and speed up importing if the source 3D file doesn't contain tangents.

ImportFlags IMPORT_USE_NAMED_SKIN_BINDS = 16

If checked, use named Skins for animation. The MeshInstance3D node contains 3 properties of relevance here: a skeleton NodePath pointing to the Skeleton3D node (usually ..), a mesh, and a skin:

- The Skeleton3D node contains a list of bones with names, their pose and rest, a name, and a parent bone.
- The mesh is all of the raw vertex data needed to display a mesh. In terms of the mesh, it knows how vertices are weight-painted and uses some internal numbering often imported from 3D modeling software.
- The skin contains the information necessary to bind this mesh onto this Skeleton3D. For each of the internal bone IDs chosen by the 3D modeling software, it contains two things. Firstly, a matrix known as the Bind Pose Matrix, Inverse Bind Matrix, or IBM for short. Secondly, the Skin contains each bone's name (if this flag is enabled), or the bone's index within the Skeleton3D list (if this flag is disabled).

Together, this information is enough to tell Godot how to use the bone poses in the Skeleton3D node to render the mesh from each MeshInstance3D. Note that each MeshInstance3D may share binds, as is common in models exported from Blender, or each MeshInstance3D may use a separate Skin object, as is common in models exported from other tools such as Maya.

ImportFlags IMPORT_DISCARD_MESHES_AND_MATERIALS = 32

Ignore meshes and materials on import. When importing a scene as an AnimationLibrary, this flag is always enabled.

ImportFlags IMPORT_FORCE_DISABLE_MESH_COMPRESSION = 64

If true, mesh compression will not be used. Consider enabling if you notice blocky artifacts in your mesh normals or UVs, or if you have meshes that are larger than a few thousand meters in each direction.

---

## Method Descriptions

PackedStringArray _get_extensions() virtual required const 

Return supported file extensions for this scene importer.

---

void _get_import_options(path: String) virtual 

Override to add general import options. These will appear in the main import dock on the editor. Add options via add_import_option() and add_import_option_advanced().

Note: All EditorSceneFormatImporter and EditorScenePostImportPlugin instances will add options for all files. It is good practice to check the file extension when path is non-empty.

When the user is editing project settings, path will be empty. It is recommended to add all options when path is empty to allow the user to customize Import Defaults.

---

Variant _get_option_visibility(path: String, for_animation: bool, option: String) virtual const 

Should return true to show the given option, false to hide the given option, or null to ignore.

---

Object _import_scene(path: String, flags: int, options: Dictionary) virtual required 

Perform the bulk of the scene import logic here, for example using GLTFDocument or FBXDocument.

---

void add_import_option(name: String, value: Variant) 

Add a specific import option (name and default value only). This function can only be called from _get_import_options().

---

void add_import_option_advanced(type: Variant.Type, name: String, default_value: Variant, hint: PropertyHint = 0, hint_string: String = "", usage_flags: int = 6) 

Add a specific import option. This function can only be called from _get_import_options().
