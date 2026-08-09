# EditorExportPlugin

Inherits: RefCounted < Object

A script that is executed when exporting the project.

## Description

EditorExportPlugins are automatically invoked whenever the user exports the project. They can be used to modify scenes and resources during project export based on what Feature Tags are set. For each plugin, _export_begin() is called at the beginning of the export process and then _export_file() is called for each exported file.

Register a EditorExportPlugin by creating a new EditorPlugin and calling its EditorPlugin.add_export_plugin() method.

## Tutorials

- Export Android plugins

## Methods

bool | _begin_customize_resources(platform: EditorExportPlatform, features: PackedStringArray) virtual const
bool | _begin_customize_scenes(platform: EditorExportPlatform, features: PackedStringArray) virtual const
Resource | _customize_resource(resource: Resource, path: String) virtual required
Node | _customize_scene(scene: Node, path: String) virtual required
void | _end_customize_resources() virtual
void | _end_customize_scenes() virtual
void | _end_generate_apple_embedded_project(path: String, will_build_archive: bool) virtual
void | _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) virtual
void | _export_end() virtual
void | _export_file(path: String, type: String, features: PackedStringArray) virtual
PackedStringArray | _get_android_dependencies(platform: EditorExportPlatform, debug: bool) virtual const
PackedStringArray | _get_android_dependencies_maven_repos(platform: EditorExportPlatform, debug: bool) virtual const
PackedStringArray | _get_android_libraries(platform: EditorExportPlatform, debug: bool) virtual const
String | _get_android_manifest_activity_element_contents(platform: EditorExportPlatform, debug: bool) virtual const
String | _get_android_manifest_application_element_contents(platform: EditorExportPlatform, debug: bool) virtual const
String | _get_android_manifest_element_contents(platform: EditorExportPlatform, debug: bool) virtual const
int | _get_customization_configuration_hash() virtual required const
PackedStringArray | _get_export_features(platform: EditorExportPlatform, debug: bool) virtual const
bool | _get_export_option_visibility(platform: EditorExportPlatform, option: String) virtual const
String | _get_export_option_warning(platform: EditorExportPlatform, option: String) virtual const
Array[Dictionary] | _get_export_options(platform: EditorExportPlatform) virtual const
Dictionary | _get_export_options_overrides(platform: EditorExportPlatform) virtual const
String | _get_name() virtual required const
bool | _should_update_export_options(platform: EditorExportPlatform) virtual const
bool | _supports_platform(platform: EditorExportPlatform) virtual const
PackedByteArray | _update_android_prebuilt_manifest(platform: EditorExportPlatform, manifest_data: PackedByteArray) virtual const
void | add_apple_embedded_platform_bundle_file(path: String)
void | add_apple_embedded_platform_cpp_code(code: String)
void | add_apple_embedded_platform_embedded_framework(path: String)
void | add_apple_embedded_platform_framework(path: String)
void | add_apple_embedded_platform_linker_flags(flags: String)
void | add_apple_embedded_platform_plist_content(plist_content: String)
void | add_apple_embedded_platform_project_static_lib(path: String)
void | add_file(path: String, file: PackedByteArray, remap: bool)
void | add_ios_bundle_file(path: String)
void | add_ios_cpp_code(code: String)
void | add_ios_embedded_framework(path: String)
void | add_ios_framework(path: String)
void | add_ios_linker_flags(flags: String)
void | add_ios_plist_content(plist_content: String)
void | add_ios_project_static_lib(path: String)
void | add_macos_plugin_file(path: String)
void | add_shared_object(path: String, tags: PackedStringArray, target: String)
EditorExportPlatform | get_export_platform() const
EditorExportPreset | get_export_preset() const
Variant | get_option(name: StringName) const
void | skip()

---

## Method Descriptions

bool _begin_customize_resources(platform: EditorExportPlatform, features: PackedStringArray) virtual const 

Return true if this plugin will customize resources based on the platform and features used.

When enabled, _get_customization_configuration_hash() and _customize_resource() will be called and must be implemented.

---

bool _begin_customize_scenes(platform: EditorExportPlatform, features: PackedStringArray) virtual const 

Return true if this plugin will customize scenes based on the platform and features used.

When enabled, _get_customization_configuration_hash() and _customize_scene() will be called and must be implemented.

Note: _customize_scene() will only be called for scenes that have been modified since the last export.

---

Resource _customize_resource(resource: Resource, path: String) virtual required 

Customize a resource. If changes are made to it, return the same or a new resource. Otherwise, return null. When a new resource is returned, resource will be replaced by a copy of the new resource.

The path argument is only used when customizing an actual file, otherwise this means that this resource is part of another one and it will be empty.

Implementing this method is required if _begin_customize_resources() returns true.

Note: When customizing any of the following types and returning another resource, the other resource should not be skipped using skip() in _export_file():

- AtlasTexture
- CompressedCubemap
- CompressedCubemapArray
- CompressedTexture2D
- CompressedTexture2DArray
- CompressedTexture3D

---

Node _customize_scene(scene: Node, path: String) virtual required 

Customize a scene. If changes are made to it, return the same or a new scene. Otherwise, return null. If a new scene is returned, it is up to you to dispose of the old one.

Implementing this method is required if _begin_customize_scenes() returns true.

Note: To change a variable in your scene, use the @export annotation when declaring it.

---

void _end_customize_resources() virtual 

This is called when the customization process for resources ends.

---

void _end_customize_scenes() virtual 

This is called when the customization process for scenes ends.

---

void _end_generate_apple_embedded_project(path: String, will_build_archive: bool) virtual 

This is called after Xcode project generation, but before it is built.

Note: Only supported on iOS and visionOS.

---

void _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) virtual 

Virtual method to be overridden by the user. It is called when the export starts and provides all information about the export. features is the list of features for the export, is_debug is true for debug builds, path is the target path for the exported project. flags is only used when running a runnable profile, e.g. when using native run on Android.

---

void _export_end() virtual 

Virtual method to be overridden by the user. Called when the export is finished.

---

void _export_file(path: String, type: String, features: PackedStringArray) virtual 

Virtual method to be overridden by the user. Called for each exported file before _customize_resource() and _customize_scene(). The arguments can be used to identify the file. path is the path of the file, type is the Resource represented by the file (e.g. PackedScene), and features is the list of features for the export.

Calling skip() inside this callback will make the file not included in the export.

---

PackedStringArray _get_android_dependencies(platform: EditorExportPlatform, debug: bool) virtual const 

Virtual method to be overridden by the user. This is called to retrieve the set of Android dependencies provided by this plugin. Each returned Android dependency should have the format of an Android remote binary dependency: org.godot.example:my-plugin:0.0.0

For more information see Android documentation on dependencies [https://developer.android.com/build/dependencies?agpversion=4.1#dependency-types].

Note: Only supported on Android and requires EditorExportPlatformAndroid.gradle_build/use_gradle_build to be enabled.

---

PackedStringArray _get_android_dependencies_maven_repos(platform: EditorExportPlatform, debug: bool) virtual const 

Virtual method to be overridden by the user. This is called to retrieve the URLs of Maven repositories for the set of Android dependencies provided by this plugin.

For more information see Gradle documentation on dependency management [https://docs.gradle.org/current/userguide/dependency_management.html#sec:maven_repo].

Note: Google's Maven repo and the Maven Central repo are already included by default.

Note: Only supported on Android and requires EditorExportPlatformAndroid.gradle_build/use_gradle_build to be enabled.

---

PackedStringArray _get_android_libraries(platform: EditorExportPlatform, debug: bool) virtual const 

Virtual method to be overridden by the user. This is called to retrieve the local paths of the Android libraries archive (AAR) files provided by this plugin.

Note: Relative paths must be relative to Godot's res://addons/ directory. For example, an AAR file located under res://addons/hello_world_plugin/HelloWorld.release.aar can be returned as an absolute path using res://addons/hello_world_plugin/HelloWorld.release.aar or a relative path using hello_world_plugin/HelloWorld.release.aar.

Note: Only supported on Android and requires EditorExportPlatformAndroid.gradle_build/use_gradle_build to be enabled.

---

String _get_android_manifest_activity_element_contents(platform: EditorExportPlatform, debug: bool) virtual const 

Virtual method to be overridden by the user. This is used at export time to update the contents of the activity element in the generated Android manifest.

Note: Only supported on Android and requires EditorExportPlatformAndroid.gradle_build/use_gradle_build to be enabled.

---

String _get_android_manifest_application_element_contents(platform: EditorExportPlatform, debug: bool) virtual const 

Virtual method to be overridden by the user. This is used at export time to update the contents of the application element in the generated Android manifest.

Note: Only supported on Android and requires EditorExportPlatformAndroid.gradle_build/use_gradle_build to be enabled.

---

String _get_android_manifest_element_contents(platform: EditorExportPlatform, debug: bool) virtual const 

Virtual method to be overridden by the user. This is used at export time to update the contents of the manifest element in the generated Android manifest.

Note: Only supported on Android and requires EditorExportPlatformAndroid.gradle_build/use_gradle_build to be enabled.

---

int _get_customization_configuration_hash() virtual required const 

Return a hash based on the configuration passed (for both scenes and resources). This helps keep separate caches for separate export configurations.

Implementing this method is required if _begin_customize_resources() returns true.

Note: _customize_resource() and _customize_scene() will not be called when the EditorExportPlugin script is modified unless this hash changes too.

---

PackedStringArray _get_export_features(platform: EditorExportPlatform, debug: bool) virtual const 

Return a PackedStringArray of additional features this preset, for the given platform, should have.

---

bool _get_export_option_visibility(platform: EditorExportPlatform, option: String) virtual const 

Validates option and returns the visibility for the specified platform. The default implementation returns true for all options.

---

String _get_export_option_warning(platform: EditorExportPlatform, option: String) virtual const 

Check the requirements for the given option and return a non-empty warning string if they are not met.

Note: Use get_option() to check the value of the export options.

---

Array[Dictionary] _get_export_options(platform: EditorExportPlatform) virtual const 

Return a list of export options that can be configured for this export plugin.

Each element in the return value is a Dictionary with the following keys:

- option: A dictionary with the structure documented by Object.get_property_list(), but all keys are optional.
- default_value: The default value for this option.
- update_visibility: An optional boolean value. If set to true, the preset will emit Object.property_list_changed when the option is changed.

---

Dictionary _get_export_options_overrides(platform: EditorExportPlatform) virtual const 

Return a Dictionary of override values for export options, that will be used instead of user-provided values. Overridden options will be hidden from the user interface.

```gdscript
class MyExportPlugin extends EditorExportPlugin:
    func _get_name() -> String:
        return "MyExportPlugin"
    func _supports_platform(platform) -> bool:
        if platform is EditorExportPlatformPC:
            # Run on all desktop platforms including Windows, MacOS and Linux.
            return true
        return false
    func _get_export_options_overrides(platform) -> Dictionary:
        # Override "Embed PCK" to always be enabled.
        return {
            "binary_format/embed_pck": true,
        }
```

---

String _get_name() virtual required const 

Return the name identifier of this plugin (for future identification by the exporter). The plugins are sorted by name before exporting.

Implementing this method is required.

---

bool _should_update_export_options(platform: EditorExportPlatform) virtual const 

Return true if the result of _get_export_options() has changed and the export options of the preset corresponding to platform should be updated.

---

bool _supports_platform(platform: EditorExportPlatform) virtual const 

Return true if the plugin supports the given platform.

---

PackedByteArray _update_android_prebuilt_manifest(platform: EditorExportPlatform, manifest_data: PackedByteArray) virtual const 

Provide access to the Android prebuilt manifest and allows the plugin to modify it if needed.

Implementers of this virtual method should take the binary manifest data from manifest_data, copy it, modify it, and then return it with the modifications.

If no modifications are needed, then an empty PackedByteArray should be returned.

---

void add_apple_embedded_platform_bundle_file(path: String) 

Adds an Apple embedded platform bundle file from the given path to the exported project.

---

void add_apple_embedded_platform_cpp_code(code: String) 

Adds C++ code to the Apple embedded platform export. The final code is created from the code appended by each active export plugin.

---

void add_apple_embedded_platform_embedded_framework(path: String) 

Adds a dynamic library (*.dylib, *.framework) to the Linking Phase in the Apple embedded platform's Xcode project and embeds it into the resulting binary.

Note: For static libraries (*.a), this works in the same way as add_apple_embedded_platform_framework().

Note: This method should not be used for System libraries as they are already present on the device.

---

void add_apple_embedded_platform_framework(path: String) 

Adds a static library (*.a) or a dynamic library (*.dylib, *.framework) to the Linking Phase to the Apple embedded platform's Xcode project.

---

void add_apple_embedded_platform_linker_flags(flags: String) 

Adds linker flags for the Apple embedded platform export.

---

void add_apple_embedded_platform_plist_content(plist_content: String) 

Adds additional fields to the Apple embedded platform's project Info.plist file.

---

void add_apple_embedded_platform_project_static_lib(path: String) 

Adds a static library from the given path to the Apple embedded platform project.

---

void add_file(path: String, file: PackedByteArray, remap: bool) 

Adds a custom file to be exported. path is the virtual path that can be used to load the file, file is the binary data of the file.

When called inside _export_file() and remap is true, the current file will not be exported, but instead remapped to this custom file. remap is ignored when called in other places.

file will not be imported, so consider using _customize_resource() to remap imported resources.

---

void add_ios_bundle_file(path: String) 

Deprecated: Use add_apple_embedded_platform_bundle_file() instead.

Adds an iOS bundle file from the given path to the exported project.

---

void add_ios_cpp_code(code: String) 

Deprecated: Use add_apple_embedded_platform_cpp_code() instead.

Adds C++ code to the iOS export. The final code is created from the code appended by each active export plugin.

---

void add_ios_embedded_framework(path: String) 

Deprecated: Use add_apple_embedded_platform_embedded_framework() instead.

Adds a dynamic library (*.dylib, *.framework) to Linking Phase in iOS's Xcode project and embeds it into resulting binary.

Note: For static libraries (*.a), this works the in same way as add_apple_embedded_platform_framework().

Note: This method should not be used for System libraries as they are already present on the device.

---

void add_ios_framework(path: String) 

Deprecated: Use add_apple_embedded_platform_framework() instead.

Adds a static library (*.a) or a dynamic library (*.dylib, *.framework) to the Linking Phase to the iOS Xcode project.

---

void add_ios_linker_flags(flags: String) 

Deprecated: Use add_apple_embedded_platform_linker_flags() instead.

Adds linker flags for the iOS export.

---

void add_ios_plist_content(plist_content: String) 

Deprecated: Use add_apple_embedded_platform_plist_content() instead.

Adds additional fields to the iOS project Info.plist file.

---

void add_ios_project_static_lib(path: String) 

Deprecated: Use add_apple_embedded_platform_project_static_lib() instead.

Adds a static library from the given path to the iOS project.

---

void add_macos_plugin_file(path: String) 

Adds file or directory matching path to PlugIns directory of macOS app bundle.

Note: This is useful only for macOS exports.

---

void add_shared_object(path: String, tags: PackedStringArray, target: String) 

Adds a shared object or a directory containing only shared objects with the given tags and destination path.

Note: In case of macOS exports, those shared objects will be added to Frameworks directory of app bundle.

In case of a directory code-sign will error if you place non code object in directory.

---

EditorExportPlatform get_export_platform() const 

Returns currently used export platform.

---

EditorExportPreset get_export_preset() const 

Returns currently used export preset.

---

Variant get_option(name: StringName) const 

Returns the current value of an export option supplied by _get_export_options().

---

void skip() 

To be called inside _export_file(). Skips the current file, so it's not included in the export.
