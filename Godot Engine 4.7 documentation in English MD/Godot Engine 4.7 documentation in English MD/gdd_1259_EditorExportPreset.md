# EditorExportPreset

Inherits: RefCounted < Object

Export preset configuration.

## Description

Represents the configuration of an export preset, as created by the editor's export dialog. An EditorExportPreset instance is intended to be used a read-only configuration passed to the EditorExportPlatform methods when exporting the project.

## Methods

bool | are_advanced_options_enabled() const
String | get_custom_features() const
Dictionary | get_customized_files() const
int | get_customized_files_count() const
bool | get_encrypt_directory() const
bool | get_encrypt_pck() const
String | get_encryption_ex_filter() const
String | get_encryption_in_filter() const
String | get_encryption_key() const
String | get_exclude_filter() const
ExportFilter | get_export_filter() const
String | get_export_path() const
FileExportMode | get_file_export_mode(path: String, default: FileExportMode = 0) const
PackedStringArray | get_files_to_export() const
String | get_include_filter() const
Variant | get_or_env(name: StringName, env_var: String) const
PackedStringArray | get_patches() const
String | get_preset_name() const
Variant | get_project_setting(name: StringName)
ScriptExportMode | get_script_export_mode() const
String | get_version(name: StringName, windows_version: bool) const
bool | has(property: StringName) const
bool | has_export_file(path: String)
bool | is_dedicated_server() const
bool | is_runnable() const

---

## Enumerations

enum ExportFilter
ExportFilter EXPORT_ALL_RESOURCES = 0

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

ExportFilter EXPORT_SELECTED_SCENES = 1

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

ExportFilter EXPORT_SELECTED_RESOURCES = 2

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

ExportFilter EXCLUDE_SELECTED_RESOURCES = 3

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

ExportFilter EXPORT_CUSTOMIZED = 4

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

enum FileExportMode
FileExportMode MODE_FILE_NOT_CUSTOMIZED = 0

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

FileExportMode MODE_FILE_STRIP = 1

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

FileExportMode MODE_FILE_KEEP = 2

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

FileExportMode MODE_FILE_REMOVE = 3

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

enum ScriptExportMode
ScriptExportMode MODE_SCRIPT_TEXT = 0

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

ScriptExportMode MODE_SCRIPT_BINARY_TOKENS = 1

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

ScriptExportMode MODE_SCRIPT_BINARY_TOKENS_COMPRESSED = 2

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

## Method Descriptions

bool are_advanced_options_enabled() const 

Returns true if the "Advanced" toggle is enabled in the export dialog.

---

String get_custom_features() const 

Returns a comma-separated list of custom features added to this preset, as a string. See Feature tags in the documentation for more information.

---

Dictionary get_customized_files() const 

Returns a dictionary of files selected in the "Resources" tab of the export dialog. The dictionary's keys are file paths, and its values are the corresponding export modes: "strip", "keep", or "remove". See also get_file_export_mode().

---

int get_customized_files_count() const 

Returns the number of files selected in the "Resources" tab of the export dialog.

---

bool get_encrypt_directory() const 

Returns true if PCK directory encryption is enabled in the export dialog.

---

bool get_encrypt_pck() const 

Returns true if PCK encryption is enabled in the export dialog.

---

String get_encryption_ex_filter() const 

Returns file filters to exclude during PCK encryption.

---

String get_encryption_in_filter() const 

Returns file filters to include during PCK encryption.

---

String get_encryption_key() const 

Returns PCK encryption key.

---

String get_exclude_filter() const 

Returns file filters to exclude during export.

---

ExportFilter get_export_filter() const 

Returns export file filter mode selected in the "Resources" tab of the export dialog.

---

String get_export_path() const 

Returns export target path.

---

FileExportMode get_file_export_mode(path: String, default: FileExportMode = 0) const 

Returns file export mode for the specified file.

---

PackedStringArray get_files_to_export() const 

Returns array of files to export.

---

String get_include_filter() const 

Returns file filters to include during export.

---

Variant get_or_env(name: StringName, env_var: String) const 

Returns export option value or value of environment variable if it is set.

---

PackedStringArray get_patches() const 

Returns the list of packs on which to base a patch export on.

---

String get_preset_name() const 

Returns this export preset's name.

---

Variant get_project_setting(name: StringName) 

Returns the value of the setting identified by name using export preset feature tag overrides instead of current OS features.

---

ScriptExportMode get_script_export_mode() const 

Returns the export mode used by GDScript files. 0 for "Text", 1 for "Binary tokens", and 2 for "Compressed binary tokens (smaller files)".

---

String get_version(name: StringName, windows_version: bool) const 

Returns the preset's version number, or fall back to the ProjectSettings.application/config/version project setting if set to an empty string.

If windows_version is true, formats the returned version number to be compatible with Windows executable metadata.

---

bool has(property: StringName) const 

Returns true if the preset has the property named property.

---

bool has_export_file(path: String) 

Returns true if the file at the specified path will be exported.

---

bool is_dedicated_server() const 

Returns true if the dedicated server export mode is selected in the export dialog.

---

bool is_runnable() const 

Returns true if the "Runnable" toggle is enabled in the export dialog.
