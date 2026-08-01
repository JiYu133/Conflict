# EditorExportPlatformExtension

Inherits: EditorExportPlatform < RefCounted < Object

Base class for custom EditorExportPlatform implementations (plugins).

## Description

External EditorExportPlatform implementations should inherit from this class.

To use EditorExportPlatform, register it using the EditorPlugin.add_export_platform() method first.

## Methods

bool | _can_export(preset: EditorExportPreset, debug: bool) virtual const
void | _cleanup() virtual
Error | _export_pack(preset: EditorExportPreset, debug: bool, path: String, flags: BitField[DebugFlags]) virtual
Error | _export_pack_patch(preset: EditorExportPreset, debug: bool, path: String, patches: PackedStringArray, flags: BitField[DebugFlags]) virtual
Error | _export_project(preset: EditorExportPreset, debug: bool, path: String, flags: BitField[DebugFlags]) virtual required
Error | _export_zip(preset: EditorExportPreset, debug: bool, path: String, flags: BitField[DebugFlags]) virtual
Error | _export_zip_patch(preset: EditorExportPreset, debug: bool, path: String, patches: PackedStringArray, flags: BitField[DebugFlags]) virtual
PackedStringArray | _get_binary_extensions(preset: EditorExportPreset) virtual required const
String | _get_debug_protocol() virtual const
String | _get_device_architecture(device: int) virtual const
bool | _get_export_option_visibility(preset: EditorExportPreset, option: String) virtual const
String | _get_export_option_warning(preset: EditorExportPreset, option: StringName) virtual const
Array[Dictionary] | _get_export_options() virtual const
Texture2D | _get_logo() virtual required const
String | _get_name() virtual required const
Texture2D | _get_option_icon(device: int) virtual const
String | _get_option_label(device: int) virtual const
String | _get_option_tooltip(device: int) virtual const
int | _get_options_count() virtual const
String | _get_options_tooltip() virtual const
String | _get_os_name() virtual required const
PackedStringArray | _get_platform_features() virtual required const
PackedStringArray | _get_preset_features(preset: EditorExportPreset) virtual required const
Texture2D | _get_run_icon() virtual const
bool | _has_valid_export_configuration(preset: EditorExportPreset, debug: bool) virtual required const
bool | _has_valid_project_configuration(preset: EditorExportPreset) virtual required const
void | _initialize() virtual
bool | _is_executable(path: String) virtual const
bool | _poll_export() virtual
Error | _run(preset: EditorExportPreset, device: int, debug_flags: BitField[DebugFlags]) virtual
bool | _should_update_export_options() virtual
String | get_config_error() const
bool | get_config_missing_templates() const
void | set_config_error(error_text: String) const
void | set_config_missing_templates(missing_templates: bool) const

---

## Method Descriptions

bool _can_export(preset: EditorExportPreset, debug: bool) virtual const 

Returns true if the specified preset is valid and can be exported. Use set_config_error() and set_config_missing_templates() to set error details.

Usual implementations call _has_valid_export_configuration() and _has_valid_project_configuration() to determine if exporting is possible.

---

void _cleanup() virtual 

Called by the editor before platform is unregistered.

---

Error _export_pack(preset: EditorExportPreset, debug: bool, path: String, flags: BitField[DebugFlags]) virtual 

Creates a PCK archive at path for the specified preset.

This method is called when "Export PCK/ZIP" button is pressed in the export dialog, with "Export as Patch" disabled, and PCK is selected as a file type.

---

Error _export_pack_patch(preset: EditorExportPreset, debug: bool, path: String, patches: PackedStringArray, flags: BitField[DebugFlags]) virtual 

Creates a patch PCK archive at path for the specified preset, containing only the files that have changed since the last patch.

This method is called when "Export PCK/ZIP" button is pressed in the export dialog, with "Export as Patch" enabled, and PCK is selected as a file type.

Note: The patches provided in patches have already been loaded when this method is called and are merely provided as context. When empty the patches defined in the export preset have been loaded instead.

---

Error _export_project(preset: EditorExportPreset, debug: bool, path: String, flags: BitField[DebugFlags]) virtual required 

Creates a full project at path for the specified preset.

This method is called when "Export" button is pressed in the export dialog.

This method implementation can call EditorExportPlatform.save_pack() or EditorExportPlatform.save_zip() to use default PCK/ZIP export process, or calls EditorExportPlatform.export_project_files() and implement custom callback for processing each exported file.

---

Error _export_zip(preset: EditorExportPreset, debug: bool, path: String, flags: BitField[DebugFlags]) virtual 

Create a ZIP archive at path for the specified preset.

This method is called when "Export PCK/ZIP" button is pressed in the export dialog, with "Export as Patch" disabled, and ZIP is selected as a file type.

---

Error _export_zip_patch(preset: EditorExportPreset, debug: bool, path: String, patches: PackedStringArray, flags: BitField[DebugFlags]) virtual 

Create a ZIP archive at path for the specified preset, containing only the files that have changed since the last patch.

This method is called when "Export PCK/ZIP" button is pressed in the export dialog, with "Export as Patch" enabled, and ZIP is selected as a file type.

Note: The patches provided in patches have already been loaded when this method is called and are merely provided as context. When empty the patches defined in the export preset have been loaded instead.

---

PackedStringArray _get_binary_extensions(preset: EditorExportPreset) virtual required const 

Returns array of supported binary extensions for the full project export.

---

String _get_debug_protocol() virtual const 

Returns protocol used for remote debugging. Default implementation return tcp://.

---

String _get_device_architecture(device: int) virtual const 

Returns device architecture for one-click deploy.

---

bool _get_export_option_visibility(preset: EditorExportPreset, option: String) virtual const 

Validates option and returns visibility for the specified preset. Default implementation return true for all options.

---

String _get_export_option_warning(preset: EditorExportPreset, option: StringName) virtual const 

Validates option and returns warning message for the specified preset. Default implementation return empty string for all options.

---

Array[Dictionary] _get_export_options() virtual const 

Returns a property list, as an Array of dictionaries. Each Dictionary must at least contain the name: StringName and type: Variant.Type entries.

Additionally, the following keys are supported:

- hint: PropertyHint
- hint_string: String
- usage: PropertyUsageFlags
- class_name: StringName
- default_value: Variant, default value of the property.
- update_visibility: bool, if set to true, _get_export_option_visibility() is called for each property when this property is changed.
- required: bool, if set to true, this property warnings are critical, and should be resolved to make export possible. This value is a hint for the _has_valid_export_configuration() implementation, and not used by the engine directly.

See also Object._get_property_list().

---

Texture2D _get_logo() virtual required const 

Returns the platform logo displayed in the export dialog. The logo should be 32×32 pixels, adjusted for the current editor scale (see EditorInterface.get_editor_scale()).

---

String _get_name() virtual required const 

Returns export platform name.

---

Texture2D _get_option_icon(device: int) virtual const 

Returns the item icon for the specified device in the one-click deploy menu. The icon should be 16×16 pixels, adjusted for the current editor scale (see EditorInterface.get_editor_scale()).

---

String _get_option_label(device: int) virtual const 

Returns one-click deploy menu item label for the specified device.

---

String _get_option_tooltip(device: int) virtual const 

Returns one-click deploy menu item tooltip for the specified device.

---

int _get_options_count() virtual const 

Returns the number of devices (or other options) available in the one-click deploy menu.

---

String _get_options_tooltip() virtual const 

Returns tooltip of the one-click deploy menu button.

---

String _get_os_name() virtual required const 

Returns target OS name.

---

PackedStringArray _get_platform_features() virtual required const 

Returns array of platform specific features.

---

PackedStringArray _get_preset_features(preset: EditorExportPreset) virtual required const 

Returns array of platform specific features for the specified preset.

---

Texture2D _get_run_icon() virtual const 

Returns the icon of the one-click deploy menu button. The icon should be 16×16 pixels, adjusted for the current editor scale (see EditorInterface.get_editor_scale()).

---

bool _has_valid_export_configuration(preset: EditorExportPreset, debug: bool) virtual required const 

Returns true if export configuration is valid.

---

bool _has_valid_project_configuration(preset: EditorExportPreset) virtual required const 

Returns true if project configuration is valid.

---

void _initialize() virtual 

Initializes the plugin. Called by the editor when platform is registered.

---

bool _is_executable(path: String) virtual const 

Returns true if specified file is a valid executable (native executable or script) for the target platform.

---

bool _poll_export() virtual 

Returns true if one-click deploy options are changed and editor interface should be updated.

---

Error _run(preset: EditorExportPreset, device: int, debug_flags: BitField[DebugFlags]) virtual 

This method is called when device one-click deploy menu option is selected.

Implementation should export project to a temporary location, upload and run it on the specific device, or perform another action associated with the menu item.

---

bool _should_update_export_options() virtual 

Returns true if export options list is changed and presets should be updated.

---

String get_config_error() const 

Returns current configuration error message text. This method should be called only from the _can_export(), _has_valid_export_configuration(), or _has_valid_project_configuration() implementations.

---

bool get_config_missing_templates() const 

Returns true is export templates are missing from the current configuration. This method should be called only from the _can_export(), _has_valid_export_configuration(), or _has_valid_project_configuration() implementations.

---

void set_config_error(error_text: String) const 

Sets current configuration error message text. This method should be called only from the _can_export(), _has_valid_export_configuration(), or _has_valid_project_configuration() implementations.

---

void set_config_missing_templates(missing_templates: bool) const 

Set to true is export templates are missing from the current configuration. This method should be called only from the _can_export(), _has_valid_export_configuration(), or _has_valid_project_configuration() implementations.
