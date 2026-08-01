# EditorInterface

Inherits: Object

Godot editor's interface.

## Description

EditorInterface gives you control over Godot editor's window. It allows customizing the window, saving and (re-)loading scenes, rendering mesh previews, inspecting and editing resources and objects, and provides access to EditorSettings, EditorFileSystem, EditorResourcePreview, ScriptEditor, the editor viewport, and information about scenes.

Note: This class shouldn't be instantiated directly. Instead, access the singleton directly by its name.

```
var editor_settings = EditorInterface.get_editor_settings()
```

```
// In C# you can access it via the static Singleton property.
EditorSettings settings = EditorInterface.Singleton.GetEditorSettings();
```

## Properties

bool | distraction_free_mode
bool | movie_maker_enabled

## Methods

void | add_root_node(node: Node)
Error | close_scene()
void | edit_node(node: Node)
void | edit_resource(resource: Resource)
void | edit_script(script: Script, line: int = -1, column: int = 0, grab_focus: bool = true)
Control | get_base_control() const
EditorCommandPalette | get_command_palette() const
String | get_current_directory() const
String | get_current_feature_profile() const
String | get_current_path() const
Node | get_edited_scene_root() const
String | get_editor_language() const
VBoxContainer | get_editor_main_screen() const
EditorPaths | get_editor_paths() const
float | get_editor_scale() const
EditorSettings | get_editor_settings() const
Theme | get_editor_theme() const
EditorToaster | get_editor_toaster() const
EditorUndoRedoManager | get_editor_undo_redo() const
SubViewport | get_editor_viewport_2d() const
SubViewport | get_editor_viewport_3d(idx: int = 0) const
FileSystemDock | get_file_system_dock() const
EditorInspector | get_inspector() const
float | get_node_3d_rotate_snap() const
float | get_node_3d_scale_snap() const
float | get_node_3d_translate_snap() const
Array[Node] | get_open_scene_roots() const
PackedStringArray | get_open_scenes() const
String | get_playing_scene() const
EditorFileSystem | get_resource_filesystem() const
EditorResourcePreview | get_resource_previewer() const
ScriptEditor | get_script_editor() const
PackedStringArray | get_selected_paths() const
EditorSelection | get_selection() const
PackedStringArray | get_unsaved_scenes() const
void | inspect_object(object: Object, for_property: String = "", inspector_only: bool = false)
bool | is_multi_window_enabled() const
bool | is_node_3d_snap_enabled() const
bool | is_object_edited(object: Object) const
bool | is_playing_scene() const
bool | is_plugin_enabled(plugin: String) const
Array[Texture2D] | make_mesh_previews(meshes: Array[Mesh], preview_size: int)
void | mark_scene_as_unsaved()
void | open_scene_from_path(scene_filepath: String, set_inherited: bool = false)
void | play_current_scene()
void | play_custom_scene(scene_filepath: String)
void | play_main_scene()
void | popup_create_dialog(callback: Callable, base_type: StringName = "", current_type: String = "", dialog_title: String = "", type_blocklist: Array[StringName] = [])
void | popup_dialog(dialog: Window, rect: Rect2i = Rect2i(0, 0, 0, 0))
void | popup_dialog_centered(dialog: Window, minsize: Vector2i = Vector2i(0, 0))
void | popup_dialog_centered_clamped(dialog: Window, minsize: Vector2i = Vector2i(0, 0), fallback_ratio: float = 0.75)
void | popup_dialog_centered_ratio(dialog: Window, ratio: float = 0.8)
void | popup_method_selector(object: Object, callback: Callable, current_value: String = "")
void | popup_node_selector(callback: Callable, valid_types: Array[StringName] = [], current_value: Node = null)
void | popup_property_selector(object: Object, callback: Callable, type_filter: PackedInt32Array = PackedInt32Array(), current_value: String = "")
void | popup_quick_open(callback: Callable, base_types: Array[StringName] = [])
void | reload_scene_from_path(scene_filepath: String)
void | restart_editor(save: bool = true)
void | save_all_scenes()
Error | save_scene()
void | save_scene_as(path: String, with_preview: bool = true)
void | select_file(file: String)
void | set_current_feature_profile(profile_name: String)
void | set_main_screen_editor(name: String)
void | set_object_edited(object: Object, edited: bool)
void | set_plugin_enabled(plugin: String, enabled: bool)
void | stop_playing_scene()

---

## Property Descriptions

bool distraction_free_mode 

- void set_distraction_free_mode(value: bool)
- bool is_distraction_free_mode_enabled()

If true, enables distraction-free mode which hides side docks to increase the space available for the main view.

---

bool movie_maker_enabled 

- void set_movie_maker_enabled(value: bool)
- bool is_movie_maker_enabled()

If true, the Movie Maker mode is enabled in the editor. See MovieWriter for more information.

---

## Method Descriptions

void add_root_node(node: Node) 

Makes node root of the currently opened scene. Only works if the scene is empty. If the node is a scene instance, an inheriting scene will be created.

---

Error close_scene() 

Closes the currently active scene, discarding any pending changes in the process. Returns @GlobalScope.OK on success or @GlobalScope.ERR_DOES_NOT_EXIST if there is no scene to close.

---

void edit_node(node: Node) 

Edits the given Node. The node will be also selected if it's inside the scene tree.

---

void edit_resource(resource: Resource) 

Edits the given Resource. If the resource is a Script you can also edit it with edit_script() to specify the line and column position.

---

void edit_script(script: Script, line: int = -1, column: int = 0, grab_focus: bool = true) 

Edits the given Script. The line and column on which to open the script can also be specified. The script will be open with the user-configured editor for the script's language which may be an external editor.

---

Control get_base_control() const 

Returns the main container of Godot editor's window. For example, you can use it to retrieve the size of the container and place your controls accordingly.

Warning: Removing and freeing this node will render the editor useless and may cause a crash.

---

EditorCommandPalette get_command_palette() const 

Returns the editor's EditorCommandPalette instance.

Warning: Removing and freeing this node will render a part of the editor useless and may cause a crash.

---

String get_current_directory() const 

Returns the current directory being viewed in the FileSystemDock. If a file is selected, its base directory will be returned using String.get_base_dir() instead.

---

String get_current_feature_profile() const 

Returns the name of the currently activated feature profile. If the default profile is currently active, an empty string is returned instead.

In order to get a reference to the EditorFeatureProfile, you must load the feature profile using EditorFeatureProfile.load_from_file().

Note: Feature profiles created via the user interface are loaded from the feature_profiles directory, as a file with the .profile extension. The editor configuration folder can be found by using EditorPaths.get_config_dir().

---

String get_current_path() const 

Returns the current path being viewed in the FileSystemDock.

---

Node get_edited_scene_root() const 

Returns the edited (current) scene's root Node.

---

String get_editor_language() const 

Returns the language currently used for the editor interface.

---

VBoxContainer get_editor_main_screen() const 

Returns the editor control responsible for main screen plugins and tools. Use it with plugins that implement EditorPlugin._has_main_screen().

Note: This node is a VBoxContainer, which means that if you add a Control child to it, you need to set the child's Control.size_flags_vertical to Control.SIZE_EXPAND_FILL to make it use the full available space.

Warning: Removing and freeing this node will render a part of the editor useless and may cause a crash.

---

EditorPaths get_editor_paths() const 

Returns the EditorPaths singleton.

---

float get_editor_scale() const 

Returns the actual scale of the editor UI (1.0 being 100% scale). This can be used to adjust position and dimensions of the UI added by plugins.

Note: This value is set via the EditorSettings.interface/editor/appearance/display_scale and EditorSettings.interface/editor/appearance/custom_display_scale settings. The editor must be restarted for changes to be properly applied.

---

EditorSettings get_editor_settings() const 

Returns the editor's EditorSettings instance.

---

Theme get_editor_theme() const 

Returns the editor's Theme.

Note: When creating custom editor UI, prefer accessing theme items directly from your GUI nodes using the get_theme_* methods.

---

EditorToaster get_editor_toaster() const 

Returns the editor's EditorToaster.

---

EditorUndoRedoManager get_editor_undo_redo() const 

Returns the editor's EditorUndoRedoManager.

---

SubViewport get_editor_viewport_2d() const 

Returns the 2D editor SubViewport. It does not have a camera. Instead, the view transforms are done directly and can be accessed with Viewport.global_canvas_transform.

---

SubViewport get_editor_viewport_3d(idx: int = 0) const 

Returns the specified 3D editor SubViewport, from 0 to 3. The viewport can be used to access the active editor cameras with Viewport.get_camera_3d().

---

FileSystemDock get_file_system_dock() const 

Returns the editor's FileSystemDock instance.

Warning: Removing and freeing this node will render a part of the editor useless and may cause a crash.

---

EditorInspector get_inspector() const 

Returns the editor's EditorInspector instance.

Warning: Removing and freeing this node will render a part of the editor useless and may cause a crash.

---

float get_node_3d_rotate_snap() const 

Returns the amount of degrees the 3D editor's rotational snapping is set to.

---

float get_node_3d_scale_snap() const 

Returns the amount of units the 3D editor's scale snapping is set to.

---

float get_node_3d_translate_snap() const 

Returns the amount of units the 3D editor's translation snapping is set to.

---

Array[Node] get_open_scene_roots() const 

Returns an array with references to the root nodes of the currently opened scenes.

---

PackedStringArray get_open_scenes() const 

Returns an array with the file paths of the currently opened scenes.

---

String get_playing_scene() const 

Returns the name of the scene that is being played. If no scene is currently being played, returns an empty string.

---

EditorFileSystem get_resource_filesystem() const 

Returns the editor's EditorFileSystem instance.

---

EditorResourcePreview get_resource_previewer() const 

Returns the editor's EditorResourcePreview instance.

---

ScriptEditor get_script_editor() const 

Returns the editor's ScriptEditor instance.

Warning: Removing and freeing this node will render a part of the editor useless and may cause a crash.

---

PackedStringArray get_selected_paths() const 

Returns an array containing the paths of the currently selected files (and directories) in the FileSystemDock.

---

EditorSelection get_selection() const 

Returns the editor's EditorSelection instance.

---

PackedStringArray get_unsaved_scenes() const 

Returns an array of file paths of currently unsaved scenes.

---

void inspect_object(object: Object, for_property: String = "", inspector_only: bool = false) 

Shows the given property on the given object in the editor's Inspector dock. If inspector_only is true, plugins will not attempt to edit object.

---

bool is_multi_window_enabled() const 

Returns true if multiple window support is enabled in the editor. Multiple window support is enabled if all of these statements are true:

- EditorSettings.interface/multi_window/enable is true.
- EditorSettings.interface/editor/display/single_window_mode is false.
- Viewport.gui_embed_subwindows is false. This is forced to true on platforms that don't support multiple windows such as Web, or when the --single-window command line argument is used.

---

bool is_node_3d_snap_enabled() const 

Returns true if the 3D editor currently has snapping mode enabled, and false otherwise.

---

bool is_object_edited(object: Object) const 

Returns true if the object has been marked as edited through set_object_edited().

---

bool is_playing_scene() const 

Returns true if a scene is currently being played, false otherwise. Paused scenes are considered as being played.

---

bool is_plugin_enabled(plugin: String) const 

Returns true if the specified plugin is enabled. The plugin name is the same as its directory name.

---

Array[Texture2D] make_mesh_previews(meshes: Array[Mesh], preview_size: int) 

Returns mesh previews rendered at the given size as an Array of Texture2Ds.

---

void mark_scene_as_unsaved() 

Marks the current scene tab as unsaved.

---

void open_scene_from_path(scene_filepath: String, set_inherited: bool = false) 

Opens the scene at the given path. If set_inherited is true, creates a new inherited scene.

---

void play_current_scene() 

Plays the currently active scene.

---

void play_custom_scene(scene_filepath: String) 

Plays the scene specified by its filepath.

---

void play_main_scene() 

Plays the main scene.

---

void popup_create_dialog(callback: Callable, base_type: StringName = "", current_type: String = "", dialog_title: String = "", type_blocklist: Array[StringName] = []) 

Experimental: This method may be changed or removed in future versions.

Pops up an editor dialog for creating an object.

The callback must take a single argument of type String, which will contain the type name of the selected object (or the script path of the type, if the type is created from a script), or be an empty string if no item is selected.

The base_type specifies the base type of objects to display. For example, if you set this to "Resource", all types derived from Resource will display in the create dialog.

The current_type will be passed in the search box of the create dialog, and the specified type can be immediately selected when the dialog pops up. If the current_type is not derived from base_type, there will be no result of the type in the dialog.

The dialog_title allows you to define a custom title for the dialog. This is useful if you want to accurately hint the usage of the dialog. If the dialog_title is an empty string, the dialog will use "Create New 'Base Type'" as the default title.

The type_blocklist contains a list of type names, and the types in the blocklist will be hidden from the create dialog.

Note: Trying to list the base type in the type_blocklist will hide all types derived from the base type from the create dialog.

---

void popup_dialog(dialog: Window, rect: Rect2i = Rect2i(0, 0, 0, 0)) 

Pops up the dialog in the editor UI with Window.popup_exclusive(). The dialog must have no current parent, otherwise the method fails.

See also Window.set_unparent_when_invisible().

---

void popup_dialog_centered(dialog: Window, minsize: Vector2i = Vector2i(0, 0)) 

Pops up the dialog in the editor UI with Window.popup_exclusive_centered(). The dialog must have no current parent, otherwise the method fails.

See also Window.set_unparent_when_invisible().

---

void popup_dialog_centered_clamped(dialog: Window, minsize: Vector2i = Vector2i(0, 0), fallback_ratio: float = 0.75) 

Pops up the dialog in the editor UI with Window.popup_exclusive_centered_clamped(). The dialog must have no current parent, otherwise the method fails.

See also Window.set_unparent_when_invisible().

---

void popup_dialog_centered_ratio(dialog: Window, ratio: float = 0.8) 

Pops up the dialog in the editor UI with Window.popup_exclusive_centered_ratio(). The dialog must have no current parent, otherwise the method fails.

See also Window.set_unparent_when_invisible().

---

void popup_method_selector(object: Object, callback: Callable, current_value: String = "") 

Pops up an editor dialog for selecting a method from object. The callback must take a single argument of type String which will contain the name of the selected method or be empty if the dialog is canceled. If current_value is provided, the method will be selected automatically in the method list, if it exists.

---

void popup_node_selector(callback: Callable, valid_types: Array[StringName] = [], current_value: Node = null) 

Pops up an editor dialog for selecting a Node from the edited scene. The callback must take a single argument of type NodePath. It is called on the selected NodePath or the empty path ^"" if the dialog is canceled. If valid_types is provided, the dialog will only show Nodes that match one of the listed Node types. If current_value is provided, the Node will be automatically selected in the tree, if it exists.

Example: Display the node selection dialog as soon as this node is added to the tree for the first time:

```gdscript
func _ready():
    if Engine.is_editor_hint():
        EditorInterface.popup_node_selector(_on_node_selected, ["Button"])
func _on_node_selected(node_path):
    if node_path.is_empty():
        print("node selection canceled")
    else:
        print("selected ", node_path)
```

---

void popup_property_selector(object: Object, callback: Callable, type_filter: PackedInt32Array = PackedInt32Array(), current_value: String = "") 

Pops up an editor dialog for selecting properties from object. The callback must take a single argument of type NodePath. It is called on the selected property path (see NodePath.get_as_property_path()) or the empty path ^"" if the dialog is canceled. If type_filter is provided, the dialog will only show properties that match one of the listed Variant.Type values. If current_value is provided, the property will be selected automatically in the property list, if it exists.

```gdscript
func _ready():
    if Engine.is_editor_hint():
        EditorInterface.popup_property_selector(this, _on_property_selected, [TYPE_INT])
func _on_property_selected(property_path):
    if property_path.is_empty():
        print("property selection canceled")
    else:
        print("selected ", property_path)
```

---

void popup_quick_open(callback: Callable, base_types: Array[StringName] = []) 

Pops up an editor dialog for quick selecting a resource file. The callback must take a single argument of type String which will contain the path of the selected resource or be empty if the dialog is canceled. If base_types is provided, the dialog will only show resources that match these types. Only types deriving from Resource are supported.

---

void reload_scene_from_path(scene_filepath: String) 

Reloads the scene at the given path. Fails if the scene is not open.

---

void restart_editor(save: bool = true) 

Restarts the editor. This closes the editor and then opens the same project. If save is true, the project will be saved before restarting.

---

void save_all_scenes() 

Saves all opened scenes in the editor.

---

Error save_scene() 

Saves the currently active scene. Returns either @GlobalScope.OK or @GlobalScope.ERR_CANT_CREATE.

---

void save_scene_as(path: String, with_preview: bool = true) 

Saves the currently active scene as a file at path.

---

void select_file(file: String) 

Selects the file, with the path provided by file, in the FileSystem dock.

---

void set_current_feature_profile(profile_name: String) 

Selects and activates the specified feature profile with the given profile_name. Set profile_name to an empty string to reset to the default feature profile.

A feature profile can be created programmatically using the EditorFeatureProfile class.

Note: The feature profile that gets activated must be located in the feature_profiles directory, as a file with the .profile extension. If a profile could not be found, an error occurs. The editor configuration folder can be found by using EditorPaths.get_config_dir().

---

void set_main_screen_editor(name: String) 

Sets the editor's current main screen to the one specified in name. name must match the title of the tab in question exactly (e.g. 2D, 3D, Script, Game, or Asset Store for default tabs).

---

void set_object_edited(object: Object, edited: bool) 

If edited is true, the object is marked as edited.

Note: This is primarily used by the editor for Resource based objects to track their modified state. For example, any changes to an open scene, a resource in the inspector, or an edited script will cause this method to be called with true. Saving the scene, script, or resource resets the edited state by calling this method with false.

Note: Each call to this method increments the object's edited version. This is used to track changes in the editor and to trigger when thumbnails should be regenerated for resources.

---

void set_plugin_enabled(plugin: String, enabled: bool) 

Sets the enabled status of a plugin. The plugin name is the same as its directory name.

---

void stop_playing_scene() 

Stops the scene that is currently playing.
