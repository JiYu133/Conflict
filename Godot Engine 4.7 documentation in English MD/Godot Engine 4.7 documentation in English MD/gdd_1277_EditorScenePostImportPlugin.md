# EditorScenePostImportPlugin

Inherits: RefCounted < Object

Plugin to control and modifying the process of importing a scene.

## Description

This plugin type exists to modify the process of importing scenes, allowing to change the content as well as add importer options at every stage of the process.

## Methods

void | _get_import_options(path: String) virtual
void | _get_internal_import_options(category: int) virtual
Variant | _get_internal_option_update_view_required(category: int, option: String) virtual const
Variant | _get_internal_option_visibility(category: int, for_animation: bool, option: String) virtual const
Variant | _get_option_visibility(path: String, for_animation: bool, option: String) virtual const
void | _internal_process(category: int, base_node: Node, node: Node, resource: Resource) virtual
void | _post_process(scene: Node) virtual
void | _pre_process(scene: Node) virtual
void | add_import_option(name: String, value: Variant)
void | add_import_option_advanced(type: Variant.Type, name: String, default_value: Variant, hint: PropertyHint = 0, hint_string: String = "", usage_flags: int = 6)
Variant | get_option_value(name: StringName) const

---

## Enumerations

enum InternalImportCategory
InternalImportCategory INTERNAL_IMPORT_CATEGORY_NODE = 0

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

InternalImportCategory INTERNAL_IMPORT_CATEGORY_MESH_3D_NODE = 1

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

InternalImportCategory INTERNAL_IMPORT_CATEGORY_MESH = 2

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

InternalImportCategory INTERNAL_IMPORT_CATEGORY_MATERIAL = 3

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

InternalImportCategory INTERNAL_IMPORT_CATEGORY_ANIMATION = 4

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

InternalImportCategory INTERNAL_IMPORT_CATEGORY_ANIMATION_NODE = 5

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

InternalImportCategory INTERNAL_IMPORT_CATEGORY_SKELETON_3D_NODE = 6

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

InternalImportCategory INTERNAL_IMPORT_CATEGORY_MAX = 7

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

## Method Descriptions

void _get_import_options(path: String) virtual 

Override to add general import options. These will appear in the main import dock on the editor. Add options via add_import_option() and add_import_option_advanced().

---

void _get_internal_import_options(category: int) virtual 

Override to add internal import options. These will appear in the 3D scene import dialog. Add options via add_import_option() and add_import_option_advanced().

---

Variant _get_internal_option_update_view_required(category: int, option: String) virtual const 

Should return true if the 3D view of the import dialog needs to update when changing the given option.

---

Variant _get_internal_option_visibility(category: int, for_animation: bool, option: String) virtual const 

Should return true to show the given option, false to hide the given option, or null to ignore.

---

Variant _get_option_visibility(path: String, for_animation: bool, option: String) virtual const 

Should return true to show the given option, false to hide the given option, or null to ignore.

---

void _internal_process(category: int, base_node: Node, node: Node, resource: Resource) virtual 

Process a specific node or resource for a given category.

---

void _post_process(scene: Node) virtual 

Post-process the scene. This function is called after the final scene has been configured.

---

void _pre_process(scene: Node) virtual 

Pre-process the scene. This function is called right after the scene format loader loaded the scene and no changes have been made.

Pre-process may be used to adjust internal import options in the "nodes", "meshes", "animations" or "materials" keys inside get_option_value("_subresources").

---

void add_import_option(name: String, value: Variant) 

Add a specific import option (name and default value only). This function can only be called from _get_import_options() and _get_internal_import_options().

---

void add_import_option_advanced(type: Variant.Type, name: String, default_value: Variant, hint: PropertyHint = 0, hint_string: String = "", usage_flags: int = 6) 

Add a specific import option. This function can only be called from _get_import_options() and _get_internal_import_options().

---

Variant get_option_value(name: StringName) const 

Query the value of an option. This function can only be called from those querying visibility, or processing.
