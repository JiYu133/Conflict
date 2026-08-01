# EditorFeatureProfile

Inherits: RefCounted < Object

An editor feature profile which can be used to disable specific features.

## Description

An editor feature profile can be used to disable specific features of the Godot editor. When disabled, the features won't appear in the editor, which makes the editor less cluttered. This is useful in education settings to reduce confusion or when working in a team. For example, artists and level designers could use a feature profile that disables the script editor to avoid accidentally making changes to files they aren't supposed to edit.

To manage editor feature profiles visually, use Editor > Manage Feature Profiles... at the top of the editor window.

## Methods

String | get_feature_name(feature: Feature)
bool | is_class_disabled(class_name: StringName) const
bool | is_class_editor_disabled(class_name: StringName) const
bool | is_class_property_disabled(class_name: StringName, property: StringName) const
bool | is_feature_disabled(feature: Feature) const
Error | load_from_file(path: String)
Error | save_to_file(path: String)
void | set_disable_class(class_name: StringName, disable: bool)
void | set_disable_class_editor(class_name: StringName, disable: bool)
void | set_disable_class_property(class_name: StringName, property: StringName, disable: bool)
void | set_disable_feature(feature: Feature, disable: bool)

---

## Enumerations

enum Feature
Feature FEATURE_3D = 0

The 3D editor. If this feature is disabled, the 3D editor won't display but 3D nodes will still display in the Create New Node dialog.

Feature FEATURE_SCRIPT = 1

The Script tab, which contains the script editor and class reference browser. If this feature is disabled, the Script tab won't display.

Feature FEATURE_ASSET_LIB = 2

The Asset Store tab. If this feature is disabled, the Asset Store tab won't display.

Feature FEATURE_SCENE_TREE = 3

Scene tree editing. If this feature is disabled, the Scene tree dock will still be visible but will be read-only.

Feature FEATURE_NODE_DOCK = 4

Deprecated: Replaced by the Signals and Groups docks.

The Node dock. If this feature is disabled, signals and groups won't be visible and modifiable from the editor.

Feature FEATURE_FILESYSTEM_DOCK = 5

The FileSystem dock. If this feature is disabled, the FileSystem dock won't be visible.

Feature FEATURE_IMPORT_DOCK = 6

The Import dock. If this feature is disabled, the Import dock won't be visible.

Feature FEATURE_HISTORY_DOCK = 7

The History dock. If this feature is disabled, the History dock won't be visible.

Feature FEATURE_GAME = 8

The Game tab, which allows embedding the game window and selecting nodes by clicking inside of it. If this feature is disabled, the Game tab won't display.

Feature FEATURE_SIGNALS_DOCK = 9

The Signals dock. If this feature is disabled, signals won't be visible and modifiable from the editor.

Feature FEATURE_GROUPS_DOCK = 10

The Groups dock. If this feature is disabled, groups won't be visible and modifiable from the editor.

Feature FEATURE_MAX = 11

Represents the size of the Feature enum.

---

## Method Descriptions

String get_feature_name(feature: Feature) 

Returns the specified feature's human-readable name.

---

bool is_class_disabled(class_name: StringName) const 

Returns true if the class specified by class_name is disabled. When disabled, the class won't appear in the Create New Node dialog.

---

bool is_class_editor_disabled(class_name: StringName) const 

Returns true if editing for the class specified by class_name is disabled. When disabled, the class will still appear in the Create New Node dialog but the Inspector will be read-only when selecting a node that extends the class.

---

bool is_class_property_disabled(class_name: StringName, property: StringName) const 

Returns true if property is disabled in the class specified by class_name. When a property is disabled, it won't appear in the Inspector when selecting a node that extends the class specified by class_name.

---

bool is_feature_disabled(feature: Feature) const 

Returns true if the feature is disabled. When a feature is disabled, it will disappear from the editor entirely.

---

Error load_from_file(path: String) 

Loads an editor feature profile from a file. The file must follow the JSON format obtained by using the feature profile manager's Export button or the save_to_file() method.

Note: Feature profiles created via the user interface are loaded from the feature_profiles directory, as a file with the .profile extension. The editor configuration folder can be found by using EditorPaths.get_config_dir().

---

Error save_to_file(path: String) 

Saves the editor feature profile to a file in JSON format. It can then be imported using the feature profile manager's Import button or the load_from_file() method.

Note: Feature profiles created via the user interface are saved in the feature_profiles directory, as a file with the .profile extension. The editor configuration folder can be found by using EditorPaths.get_config_dir().

---

void set_disable_class(class_name: StringName, disable: bool) 

If disable is true, disables the class specified by class_name. When disabled, the class won't appear in the Create New Node dialog.

---

void set_disable_class_editor(class_name: StringName, disable: bool) 

If disable is true, disables editing for the class specified by class_name. When disabled, the class will still appear in the Create New Node dialog but the Inspector will be read-only when selecting a node that extends the class.

---

void set_disable_class_property(class_name: StringName, property: StringName, disable: bool) 

If disable is true, disables editing for property in the class specified by class_name. When a property is disabled, it won't appear in the Inspector when selecting a node that extends the class specified by class_name.

---

void set_disable_feature(feature: Feature, disable: bool) 

If disable is true, disables the editor feature specified in feature. When a feature is disabled, it will disappear from the editor entirely.
