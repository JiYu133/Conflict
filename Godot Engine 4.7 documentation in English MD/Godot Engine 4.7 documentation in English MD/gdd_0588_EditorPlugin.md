# EditorPlugin

Inherits: Node < Object

Inherited By: GridMapEditorPlugin

Used by the editor to extend its functionality.

## Description

Plugins are used by the editor to extend functionality. The most common types of plugins are those which edit a given node or resource type, import plugins and export plugins. See also EditorScript to add functions to the editor.

Note: Some names in this class contain "left" or "right" (e.g. DOCK_SLOT_LEFT_UL). These APIs assume left-to-right layout, and would be backwards when using right-to-left layout. These names are kept for compatibility reasons.

## Tutorials

- Editor plugins documentation index

## Methods

void | _apply_changes() virtual
bool | _build() virtual
void | _clear() virtual
void | _disable_plugin() virtual
void | _edit(object: Object) virtual
void | _enable_plugin() virtual
void | _forward_3d_draw_over_viewport(viewport_control: Control) virtual
void | _forward_3d_force_draw_over_viewport(viewport_control: Control) virtual
int | _forward_3d_gui_input(viewport_camera: Camera3D, event: InputEvent) virtual
void | _forward_canvas_draw_over_viewport(viewport_control: Control) virtual
void | _forward_canvas_force_draw_over_viewport(viewport_control: Control) virtual
bool | _forward_canvas_gui_input(event: InputEvent) virtual
PackedStringArray | _get_breakpoints() virtual const
Texture2D | _get_plugin_icon() virtual const
String | _get_plugin_name() virtual const
Dictionary | _get_state() virtual const
String | _get_unsaved_status(for_scene: String) virtual const
void | _get_window_layout(configuration: ConfigFile) virtual
bool | _handles(object: Object) virtual const
bool | _has_main_screen() virtual const
void | _make_visible(visible: bool) virtual
PackedStringArray | _run_scene(scene: String, args: PackedStringArray) virtual const
void | _save_external_data() virtual
void | _set_state(state: Dictionary) virtual
void | _set_window_layout(configuration: ConfigFile) virtual
void | add_autoload_singleton(name: String, path: String)
void | add_context_menu_plugin(slot: ContextMenuSlot, plugin: EditorContextMenuPlugin)
Button | add_control_to_bottom_panel(control: Control, title: String, shortcut: Shortcut = null)
void | add_control_to_container(container: CustomControlContainer, control: Control)
void | add_control_to_dock(slot: DockSlot, control: Control, shortcut: Shortcut = null)
void | add_custom_type(type: String, base: String, script: Script, icon: Texture2D)
void | add_debugger_plugin(script: EditorDebuggerPlugin)
void | add_dock(dock: EditorDock)
void | add_export_platform(platform: EditorExportPlatform)
void | add_export_plugin(plugin: EditorExportPlugin)
void | add_import_plugin(importer: EditorImportPlugin, first_priority: bool = false)
void | add_inspector_plugin(plugin: EditorInspectorPlugin)
void | add_node_3d_gizmo_plugin(plugin: EditorNode3DGizmoPlugin)
void | add_resource_conversion_plugin(plugin: EditorResourceConversionPlugin)
void | add_scene_format_importer_plugin(scene_format_importer: EditorSceneFormatImporter, first_priority: bool = false)
void | add_scene_post_import_plugin(scene_import_plugin: EditorScenePostImportPlugin, first_priority: bool = false)
void | add_tool_menu_item(name: String, callable: Callable)
void | add_tool_submenu_item(name: String, submenu: PopupMenu)
void | add_translation_parser_plugin(parser: EditorTranslationParserPlugin)
void | add_undo_redo_inspector_hook_callback(callable: Callable)
EditorInterface | get_editor_interface()
PopupMenu | get_export_as_menu()
String | get_plugin_version() const
ScriptCreateDialog | get_script_create_dialog()
EditorUndoRedoManager | get_undo_redo()
void | hide_bottom_panel()
void | make_bottom_panel_item_visible(item: Control)
void | queue_save_layout()
void | remove_autoload_singleton(name: String)
void | remove_context_menu_plugin(plugin: EditorContextMenuPlugin)
void | remove_control_from_bottom_panel(control: Control)
void | remove_control_from_container(container: CustomControlContainer, control: Control)
void | remove_control_from_docks(control: Control)
void | remove_custom_type(type: String)
void | remove_debugger_plugin(script: EditorDebuggerPlugin)
void | remove_dock(dock: EditorDock)
void | remove_export_platform(platform: EditorExportPlatform)
void | remove_export_plugin(plugin: EditorExportPlugin)
void | remove_import_plugin(importer: EditorImportPlugin)
void | remove_inspector_plugin(plugin: EditorInspectorPlugin)
void | remove_node_3d_gizmo_plugin(plugin: EditorNode3DGizmoPlugin)
void | remove_resource_conversion_plugin(plugin: EditorResourceConversionPlugin)
void | remove_scene_format_importer_plugin(scene_format_importer: EditorSceneFormatImporter)
void | remove_scene_post_import_plugin(scene_import_plugin: EditorScenePostImportPlugin)
void | remove_tool_menu_item(name: String)
void | remove_translation_parser_plugin(parser: EditorTranslationParserPlugin)
void | remove_undo_redo_inspector_hook_callback(callable: Callable)
void | set_dock_tab_icon(control: Control, icon: Texture2D)
void | set_force_draw_over_forwarding_enabled()
void | set_input_event_forwarding_always_enabled()
int | update_overlays() const

---

## Signals

main_screen_changed(screen_name: String) 

Emitted when user changes the workspace (2D, 3D, Script, Game, Asset Store). Also works with custom screens defined by plugins.

---

project_settings_changed() 

Deprecated: Use ProjectSettings.settings_changed instead.

Emitted when any project setting has changed.

---

resource_saved(resource: Resource) 

Emitted when the given resource was saved on disc. See also scene_saved.

---

scene_changed(scene_root: Node) 

Emitted when the scene is changed in the editor. The argument will return the root node of the scene that has just become active. If this scene is new and empty, the argument will be null.

---

scene_closed(filepath: String) 

Emitted when user closes a scene. The argument is a file path to the closed scene.

---

scene_saved(filepath: String) 

Emitted when a scene was saved on disc. The argument is a file path to the saved scene. See also resource_saved.

---

## Enumerations

enum CustomControlContainer
CustomControlContainer CONTAINER_TOOLBAR = 0

Main editor toolbar, next to play buttons.

CustomControlContainer CONTAINER_SPATIAL_EDITOR_MENU = 1

The toolbar that appears when 3D editor is active.

CustomControlContainer CONTAINER_SPATIAL_EDITOR_SIDE_LEFT = 2

Left sidebar of the 3D editor.

CustomControlContainer CONTAINER_SPATIAL_EDITOR_SIDE_RIGHT = 3

Right sidebar of the 3D editor.

CustomControlContainer CONTAINER_SPATIAL_EDITOR_BOTTOM = 4

Bottom panel of the 3D editor.

CustomControlContainer CONTAINER_CANVAS_EDITOR_MENU = 5

The toolbar that appears when 2D editor is active.

CustomControlContainer CONTAINER_CANVAS_EDITOR_SIDE_LEFT = 6

Left sidebar of the 2D editor.

CustomControlContainer CONTAINER_CANVAS_EDITOR_SIDE_RIGHT = 7

Right sidebar of the 2D editor.

CustomControlContainer CONTAINER_CANVAS_EDITOR_BOTTOM = 8

Bottom panel of the 2D editor.

CustomControlContainer CONTAINER_INSPECTOR_BOTTOM = 9

Bottom section of the inspector.

CustomControlContainer CONTAINER_PROJECT_SETTING_TAB_LEFT = 10

Tab of Project Settings dialog, to the left of other tabs.

CustomControlContainer CONTAINER_PROJECT_SETTING_TAB_RIGHT = 11

Tab of Project Settings dialog, to the right of other tabs.

---

enum DockSlot
DockSlot DOCK_SLOT_NONE = -1

The dock is closed.

DockSlot DOCK_SLOT_LEFT_UL = 0

Dock slot, left side, upper-left (empty in default layout).

DockSlot DOCK_SLOT_LEFT_BL = 1

Dock slot, left side, bottom-left (empty in default layout).

DockSlot DOCK_SLOT_LEFT_UR = 2

Dock slot, left side, upper-right (in default layout includes Scene and Import docks).

DockSlot DOCK_SLOT_LEFT_BR = 3

Dock slot, left side, bottom-right (in default layout includes FileSystem dock).

DockSlot DOCK_SLOT_RIGHT_UL = 4

Dock slot, right side, upper-left (in default layout includes Inspector, Node, and History docks).

DockSlot DOCK_SLOT_RIGHT_BL = 5

Dock slot, right side, bottom-left (empty in default layout).

DockSlot DOCK_SLOT_RIGHT_UR = 6

Dock slot, right side, upper-right (empty in default layout).

DockSlot DOCK_SLOT_RIGHT_BR = 7

Dock slot, right side, bottom-right (empty in default layout).

DockSlot DOCK_SLOT_BOTTOM = 8

Bottom panel.

DockSlot DOCK_SLOT_MAX = 9

Represents the size of the DockSlot enum.

---

enum AfterGUIInput
AfterGUIInput AFTER_GUI_INPUT_PASS = 0

Forwards the InputEvent to other EditorPlugins.

AfterGUIInput AFTER_GUI_INPUT_STOP = 1

Prevents the InputEvent from reaching other Editor classes.

AfterGUIInput AFTER_GUI_INPUT_CUSTOM = 2

Pass the InputEvent to other editor plugins except the main Node3D one. This can be used to prevent node selection changes and work with sub-gizmos instead.

---

## Method Descriptions

void _apply_changes() virtual 

This method is called when the editor is about to save the project, switch to another tab, etc. It asks the plugin to apply any pending state changes to ensure consistency.

This is used, for example, in shader editors to let the plugin know that it must apply the shader code being written by the user to the object.

---

bool _build() virtual 

This method is called when the editor is about to run the project. The plugin can then perform required operations before the project runs.

This method must return a boolean. If this method returns false, the project will not run. The run is aborted immediately, so this also prevents all other plugins' _build() methods from running.

---

void _clear() virtual 

Clear all the state and reset the object being edited to zero. This ensures your plugin does not keep editing a currently existing node, or a node from the wrong scene.

---

void _disable_plugin() virtual 

Called by the engine when the user disables the EditorPlugin in the Plugin tab of the project settings window.

---

void _edit(object: Object) virtual 

This function is used for plugins that edit specific object types (nodes or resources). It requests the editor to edit the given object.

object can be null if the plugin was editing an object, but there is no longer any selected object handled by this plugin. It can be used to cleanup editing state.

---

void _enable_plugin() virtual 

Called by the engine when the user enables the EditorPlugin in the Plugin tab of the project settings window.

---

void _forward_3d_draw_over_viewport(viewport_control: Control) virtual 

Called by the engine when the 3D editor's viewport is updated. viewport_control is an overlay on top of the viewport and it can be used for drawing. You can update the viewport manually by calling update_overlays().

```
func _forward_3d_draw_over_viewport(overlay):
    # Draw a circle at the cursor's position.
    overlay.draw_circle(overlay.get_local_mouse_position(), 64, Color.WHITE)
func _forward_3d_gui_input(camera, event):
    if event is InputEventMouseMotion:
        # Redraw the viewport when the cursor is moved.
        update_overlays()
        return EditorPlugin.AFTER_GUI_INPUT_STOP
    return EditorPlugin.AFTER_GUI_INPUT_PASS
```

```
public override void _Forward3DDrawOverViewport(Control viewportControl)
{
    // Draw a circle at the cursor's position.
    viewportControl.DrawCircle(viewportControl.GetLocalMousePosition(), 64, Colors.White);
}
public override EditorPlugin.AfterGuiInput _Forward3DGuiInput(Camera3D viewportCamera, InputEvent @event)
{
    if (@event is InputEventMouseMotion)
    {
        // Redraw the viewport when the cursor is moved.
        UpdateOverlays();
        return EditorPlugin.AfterGuiInput.Stop;
    }
    return EditorPlugin.AfterGuiInput.Pass;
}
```

---

void _forward_3d_force_draw_over_viewport(viewport_control: Control) virtual 

This method is the same as _forward_3d_draw_over_viewport(), except it draws on top of everything. Useful when you need an extra layer that shows over anything else.

You need to enable calling of this method by using set_force_draw_over_forwarding_enabled().

---

int _forward_3d_gui_input(viewport_camera: Camera3D, event: InputEvent) virtual 

Called when there is a root node in the current edited scene, _handles() is implemented, and an InputEvent happens in the 3D viewport. The return value decides whether the InputEvent is consumed or forwarded to other EditorPlugins. See AfterGUIInput for options.

```
# Prevents the InputEvent from reaching other Editor classes.
func _forward_3d_gui_input(camera, event):
    return EditorPlugin.AFTER_GUI_INPUT_STOP
```

```
// Prevents the InputEvent from reaching other Editor classes.
public override EditorPlugin.AfterGuiInput _Forward3DGuiInput(Camera3D camera, InputEvent @event)
{
    return EditorPlugin.AfterGuiInput.Stop;
}
```

This method must return AFTER_GUI_INPUT_PASS in order to forward the InputEvent to other Editor classes.

```
# Consumes InputEventMouseMotion and forwards other InputEvent types.
func _forward_3d_gui_input(camera, event):
    return EditorPlugin.AFTER_GUI_INPUT_STOP if event is InputEventMouseMotion else EditorPlugin.AFTER_GUI_INPUT_PASS
```

```
// Consumes InputEventMouseMotion and forwards other InputEvent types.
public override EditorPlugin.AfterGuiInput _Forward3DGuiInput(Camera3D camera, InputEvent @event)
{
    return @event is InputEventMouseMotion ? EditorPlugin.AfterGuiInput.Stop : EditorPlugin.AfterGuiInput.Pass;
}
```

---

void _forward_canvas_draw_over_viewport(viewport_control: Control) virtual 

Called by the engine when the 2D editor's viewport is updated. viewport_control is an overlay on top of the viewport and it can be used for drawing. You can update the viewport manually by calling update_overlays().

```
func _forward_canvas_draw_over_viewport(overlay):
    # Draw a circle at the cursor's position.
    overlay.draw_circle(overlay.get_local_mouse_position(), 64, Color.WHITE)
func _forward_canvas_gui_input(event):
    if event is InputEventMouseMotion:
        # Redraw the viewport when the cursor is moved.
        update_overlays()
        return true
    return false
```

```
public override void _ForwardCanvasDrawOverViewport(Control viewportControl)
{
    // Draw a circle at the cursor's position.
    viewportControl.DrawCircle(viewportControl.GetLocalMousePosition(), 64, Colors.White);
}
public override bool _ForwardCanvasGuiInput(InputEvent @event)
{
    if (@event is InputEventMouseMotion)
    {
        // Redraw the viewport when the cursor is moved.
        UpdateOverlays();
        return true;
    }
    return false;
}
```

---

void _forward_canvas_force_draw_over_viewport(viewport_control: Control) virtual 

This method is the same as _forward_canvas_draw_over_viewport(), except it draws on top of everything. Useful when you need an extra layer that shows over anything else.

You need to enable calling of this method by using set_force_draw_over_forwarding_enabled().

---

bool _forward_canvas_gui_input(event: InputEvent) virtual 

Called when there is a root node in the current edited scene, _handles() is implemented, and an InputEvent happens in the 2D viewport. If this method returns true, event is intercepted by this EditorPlugin, otherwise event is forwarded to other Editor classes.

```
# Prevents the InputEvent from reaching other Editor classes.
func _forward_canvas_gui_input(event):
    return true
```

```
// Prevents the InputEvent from reaching other Editor classes.
public override bool ForwardCanvasGuiInput(InputEvent @event)
{
    return true;
}
```

This method must return false in order to forward the InputEvent to other Editor classes.

```
# Consumes InputEventMouseMotion and forwards other InputEvent types.
func _forward_canvas_gui_input(event):
    if (event is InputEventMouseMotion):
        return true
    return false
```

```
// Consumes InputEventMouseMotion and forwards other InputEvent types.
public override bool _ForwardCanvasGuiInput(InputEvent @event)
{
    if (@event is InputEventMouseMotion)
    {
        return true;
    }
    return false;
}
```

---

PackedStringArray _get_breakpoints() virtual const 

This is for editors that edit script-based objects. You can return a list of breakpoints in the format (script:line), for example: res://path_to_script.gd:25.

---

Texture2D _get_plugin_icon() virtual const 

Override this method in your plugin to return a Texture2D in order to give it an icon.

For main screen plugins, this appears at the top of the screen, to the right of the "2D", "3D", "Script", "Game", and "Asset Store" buttons.

Ideally, the plugin icon should be white with a transparent background and 16×16 pixels in size.

```
func _get_plugin_icon():
    # You can use a custom icon:
    return preload("res://addons/my_plugin/my_plugin_icon.svg")
    # Or use a built-in icon:
    return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
```

```
public override Texture2D _GetPluginIcon()
{
    // You can use a custom icon:
    return ResourceLoader.Load("res://addons/my_plugin/my_plugin_icon.svg");
    // Or use a built-in icon:
    return EditorInterface.Singleton.GetEditorTheme().GetIcon("Node", "EditorIcons");
}
```

---

String _get_plugin_name() virtual const 

Override this method in your plugin to provide the name of the plugin when displayed in the Godot editor.

For main screen plugins, this appears at the top of the screen, to the right of the "2D", "3D", "Script", "Game", and "Asset Store" buttons.

---

Dictionary _get_state() virtual const 

Override this method to provide a state data you want to be saved, like view position, grid settings, folding, etc. This is used when saving the scene (so state is kept when opening it again) and for switching tabs (so state can be restored when the tab returns). This data is automatically saved for each scene in an editstate file in the editor metadata folder. If you want to store global (scene-independent) editor data for your plugin, you can use _get_window_layout() instead.

Use _set_state() to restore your saved state.

Note: This method should not be used to save important settings that should persist with the project.

Note: You must implement _get_plugin_name() for the state to be stored and restored correctly.

```gdscript
func _get_state():
    var state = { "zoom": zoom, "preferred_color": my_color }
    return state
```

---

String _get_unsaved_status(for_scene: String) virtual const 

Override this method to provide a custom message that lists unsaved changes. The editor will call this method when exiting or when closing a scene, and display the returned string in a confirmation dialog. Return empty string if the plugin has no unsaved changes.

When closing a scene, for_scene is the path to the scene being closed. You can use it to handle built-in resources in that scene.

If the user confirms saving, _save_external_data() will be called, before closing the editor.

```gdscript
func _get_unsaved_status(for_scene):
    if not unsaved:
        return ""
    if for_scene.is_empty():
        return "Save changes in MyCustomPlugin before closing?"
    else:
        return "Scene %s has changes from MyCustomPlugin. Save before closing?" % for_scene.get_file()
func _save_external_data():
    unsaved = false
```

If the plugin has no scene-specific changes, you can ignore the calls when closing scenes:

```gdscript
func _get_unsaved_status(for_scene):
    if not for_scene.is_empty():
        return ""
```

---

void _get_window_layout(configuration: ConfigFile) virtual 

Override this method to provide the GUI layout of the plugin or any other data you want to be stored. This is used to save the project's editor layout when queue_save_layout() is called or the editor layout was changed (for example changing the position of a dock). The data is stored in the editor_layout.cfg file in the editor metadata directory.

Use _set_window_layout() to restore your saved layout.

```gdscript
func _get_window_layout(configuration):
    configuration.set_value("MyPlugin", "window_position", $Window.position)
    configuration.set_value("MyPlugin", "icon_color", $Icon.modulate)
```

---

bool _handles(object: Object) virtual const 

Implement this function if your plugin edits a specific type of object (Resource or Node). If you return true, then you will get the functions _edit() and _make_visible() called when the editor requests them. If you have declared the methods _forward_canvas_gui_input() and _forward_3d_gui_input() these will be called too.

Note: Each plugin should handle only one type of objects at a time. If a plugin handles more types of objects and they are edited at the same time, it will result in errors.

---

bool _has_main_screen() virtual const 

Returns true if this is a main screen editor plugin (it goes in the workspace selector together with 2D, 3D, Script, Game, and Asset Store).

When the plugin's workspace is selected, other main screen plugins will be hidden, but your plugin will not appear automatically. It needs to be added as a child of EditorInterface.get_editor_main_screen() and made visible inside _make_visible().

Use _get_plugin_name() and _get_plugin_icon() to customize the plugin button's appearance.

```gdscript
var plugin_control
func _enter_tree():
    plugin_control = preload("my_plugin_control.tscn").instantiate()
    EditorInterface.get_editor_main_screen().add_child(plugin_control)
    plugin_control.hide()
func _has_main_screen():
    return true
func _make_visible(visible):
    plugin_control.visible = visible
func _get_plugin_name():
    return "My Super Cool Plugin 3000"
func _get_plugin_icon():
    return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
```

---

void _make_visible(visible: bool) virtual 

This function will be called when the editor is requested to become visible. It is used for plugins that edit a specific object type.

Remember that you have to manage the visibility of all your editor controls manually.

---

PackedStringArray _run_scene(scene: String, args: PackedStringArray) virtual const 

This function is called when an individual scene is about to be played in the editor. args is a list of command line arguments that will be passed to the new Godot instance, which will be replaced by the list returned by this function.

```gdscript
func _run_scene(scene, args):
    args.append("--an-extra-argument")
    return args
```

Note: Text that is printed in this method will not be visible in the editor's Output panel unless EditorSettings.run/output/always_clear_output_on_play is false.

---

void _save_external_data() virtual 

This method is called after the editor saves the project or when it's closed. It asks the plugin to save edited external scenes/resources.

---

void _set_state(state: Dictionary) virtual 

Restore the state saved by _get_state(). This method is called when the current scene tab is changed in the editor.

Note: Your plugin must implement _get_plugin_name(), otherwise it will not be recognized and this method will not be called.

```gdscript
func _set_state(data):
    zoom = data.get("zoom", 1.0)
    preferred_color = data.get("my_color", Color.WHITE)
```

---

void _set_window_layout(configuration: ConfigFile) virtual 

Restore the plugin GUI layout and data saved by _get_window_layout(). This method is called for every plugin on editor startup. Use the provided configuration file to read your saved data.

```gdscript
func _set_window_layout(configuration):
    $Window.position = configuration.get_value("MyPlugin", "window_position", Vector2())
    $Icon.modulate = configuration.get_value("MyPlugin", "icon_color", Color.WHITE)
```

---

void add_autoload_singleton(name: String, path: String) 

Adds a script at path to the Autoload list as name.

---

void add_context_menu_plugin(slot: ContextMenuSlot, plugin: EditorContextMenuPlugin) 

Adds a plugin to the context menu. slot is the context menu where the plugin will be added.

Note: A plugin instance can belong only to a single context menu slot.

---

Button add_control_to_bottom_panel(control: Control, title: String, shortcut: Shortcut = null) 

Deprecated: Use add_dock() instead, with EditorDock.default_slot set to DOCK_SLOT_BOTTOM.

Adds a control to the bottom panel (together with Output, Debug, Animation, etc.). Returns a reference to a button that is outside the scene tree. It's up to you to hide/show the button when needed. When your plugin is deactivated, make sure to remove your custom control with remove_control_from_bottom_panel() and free it with Node.queue_free().

shortcut is a shortcut that, when activated, will toggle the bottom panel's visibility. The shortcut object is only set when this control is added to the bottom panel.

Note See the default editor bottom panel shortcuts in the Editor Settings for inspiration. By convention, they all use Alt modifier.

---

void add_control_to_container(container: CustomControlContainer, control: Control) 

Adds a custom control to a container in the editor UI.

Please remember that you have to manage the visibility of your custom controls yourself (and likely hide it after adding it).

When your plugin is deactivated, make sure to remove your custom control with remove_control_from_container() and free it with Node.queue_free().

---

void add_control_to_dock(slot: DockSlot, control: Control, shortcut: Shortcut = null) 

Deprecated: Use add_dock() instead.

Adds the control to a specific dock slot.

If the dock is repositioned and as long as the plugin is active, the editor will save the dock position on further sessions.

When your plugin is deactivated, make sure to remove your custom control with remove_control_from_docks() and free it with Node.queue_free().

Optionally, you can specify a shortcut parameter. When pressed, this shortcut will open and focus the dock.

---

void add_custom_type(type: String, base: String, script: Script, icon: Texture2D) 

Adds a custom type, which will appear in the list of nodes or resources.

When a given node or resource is selected, the base type will be instantiated (e.g. "Node3D", "Control", "Resource"), then the script will be loaded and set to this object.

Note: The base type is the base engine class which this type's class hierarchy inherits, not any custom type parent classes.

You can use the virtual method _handles() to check if your custom object is being edited by checking the script or using the is keyword.

During run-time, this will be a simple object with a script so this function does not need to be called then.

Note: Custom types added this way are not true classes. They are just a helper to create a node with specific script.

---

void add_debugger_plugin(script: EditorDebuggerPlugin) 

Adds a Script as debugger plugin to the Debugger. The script must extend EditorDebuggerPlugin.

---

void add_dock(dock: EditorDock) 

Adds a new dock.

When your plugin is deactivated, make sure to remove your custom dock with remove_dock() and free it with Node.queue_free().

---

void add_export_platform(platform: EditorExportPlatform) 

Registers a new EditorExportPlatform. Export platforms provides functionality of exporting to the specific platform.

---

void add_export_plugin(plugin: EditorExportPlugin) 

Registers a new EditorExportPlugin. Export plugins are used to perform tasks when the project is being exported.

See add_inspector_plugin() for an example of how to register a plugin.

---

void add_import_plugin(importer: EditorImportPlugin, first_priority: bool = false) 

Registers a new EditorImportPlugin. Import plugins are used to import custom and unsupported assets as a custom Resource type.

If first_priority is true, the new import plugin is inserted first in the list and takes precedence over pre-existing plugins.

Note: If you want to import custom 3D asset formats use add_scene_format_importer_plugin() instead.

See add_inspector_plugin() for an example of how to register a plugin.

---

void add_inspector_plugin(plugin: EditorInspectorPlugin) 

Registers a new EditorInspectorPlugin. Inspector plugins are used to extend EditorInspector and provide custom configuration tools for your object's properties.

Note: Always use remove_inspector_plugin() to remove the registered EditorInspectorPlugin when your EditorPlugin is disabled to prevent leaks and an unexpected behavior.

```
const MyInspectorPlugin = preload("res://addons/your_addon/path/to/your/script.gd")
var inspector_plugin = MyInspectorPlugin.new()
func _enter_tree():
    add_inspector_plugin(inspector_plugin)
func _exit_tree():
    remove_inspector_plugin(inspector_plugin)
```

---

void add_node_3d_gizmo_plugin(plugin: EditorNode3DGizmoPlugin) 

Registers a new EditorNode3DGizmoPlugin. Gizmo plugins are used to add custom gizmos to the 3D preview viewport for a Node3D.

See add_inspector_plugin() for an example of how to register a plugin.

---

void add_resource_conversion_plugin(plugin: EditorResourceConversionPlugin) 

Registers a new EditorResourceConversionPlugin. Resource conversion plugins are used to add custom resource converters to the editor inspector.

See EditorResourceConversionPlugin for an example of how to create a resource conversion plugin.

---

void add_scene_format_importer_plugin(scene_format_importer: EditorSceneFormatImporter, first_priority: bool = false) 

Registers a new EditorSceneFormatImporter. Scene importers are used to import custom 3D asset formats as scenes.

If first_priority is true, the new import plugin is inserted first in the list and takes precedence over pre-existing plugins.

---

void add_scene_post_import_plugin(scene_import_plugin: EditorScenePostImportPlugin, first_priority: bool = false) 

Add an EditorScenePostImportPlugin. These plugins allow customizing the import process of 3D assets by adding new options to the import dialogs.

If first_priority is true, the new import plugin is inserted first in the list and takes precedence over pre-existing plugins.

---

void add_tool_menu_item(name: String, callable: Callable) 

Adds a custom menu item to Project > Tools named name. When clicked, the provided callable will be called.

---

void add_tool_submenu_item(name: String, submenu: PopupMenu) 

Adds a custom PopupMenu submenu under Project > Tools > name. Use remove_tool_menu_item() on plugin clean up to remove the menu.

---

void add_translation_parser_plugin(parser: EditorTranslationParserPlugin) 

Registers a custom translation parser plugin for extracting translatable strings from custom files.

---

void add_undo_redo_inspector_hook_callback(callable: Callable) 

Hooks a callback into the undo/redo action creation when a property is modified in the inspector. This allows, for example, to save other properties that may be lost when a given property is modified.

The callback should have 4 arguments: Object undo_redo, Object modified_object, String property and Variant new_value. They are, respectively, the UndoRedo object used by the inspector, the currently modified object, the name of the modified property and the new value the property is about to take.

---

EditorInterface get_editor_interface() 

Deprecated: EditorInterface is a global singleton and can be accessed directly by its name.

Returns the EditorInterface singleton instance.

---

PopupMenu get_export_as_menu() 

Returns the PopupMenu under Scene > Export As....

---

String get_plugin_version() const 

Provide the version of the plugin declared in the plugin.cfg config file.

---

ScriptCreateDialog get_script_create_dialog() 

Gets the Editor's dialog used for making scripts.

Note: Users can configure it before use.

Warning: Removing and freeing this node will render a part of the editor useless and may cause a crash.

---

EditorUndoRedoManager get_undo_redo() 

Gets the undo/redo object. Most actions in the editor can be undoable, so use this object to make sure this happens when it's worth it.

---

void hide_bottom_panel() 

Minimizes the bottom panel.

---

void make_bottom_panel_item_visible(item: Control) 

Makes a specific item in the bottom panel visible.

---

void queue_save_layout() 

Queue save the project's editor layout.

---

void remove_autoload_singleton(name: String) 

Removes an Autoload name from the list.

---

void remove_context_menu_plugin(plugin: EditorContextMenuPlugin) 

Removes the specified context menu plugin.

---

void remove_control_from_bottom_panel(control: Control) 

Deprecated: Use remove_dock() instead.

Removes the control from the bottom panel. You have to manually Node.queue_free() the control.

---

void remove_control_from_container(container: CustomControlContainer, control: Control) 

Removes the control from the specified container. You have to manually Node.queue_free() the control.

---

void remove_control_from_docks(control: Control) 

Deprecated: Use remove_dock() instead.

Removes the control from the dock. You have to manually Node.queue_free() the control.

---

void remove_custom_type(type: String) 

Removes a custom type added by add_custom_type().

---

void remove_debugger_plugin(script: EditorDebuggerPlugin) 

Removes the debugger plugin with given script from the Debugger.

---

void remove_dock(dock: EditorDock) 

Removes dock from the available docks. You should manually call Node.queue_free() to free it.

---

void remove_export_platform(platform: EditorExportPlatform) 

Removes an export platform registered by add_export_platform().

---

void remove_export_plugin(plugin: EditorExportPlugin) 

Removes an export plugin registered by add_export_plugin().

---

void remove_import_plugin(importer: EditorImportPlugin) 

Removes an import plugin registered by add_import_plugin().

---

void remove_inspector_plugin(plugin: EditorInspectorPlugin) 

Removes an inspector plugin registered by add_inspector_plugin().

---

void remove_node_3d_gizmo_plugin(plugin: EditorNode3DGizmoPlugin) 

Removes a gizmo plugin registered by add_node_3d_gizmo_plugin().

---

void remove_resource_conversion_plugin(plugin: EditorResourceConversionPlugin) 

Removes a resource conversion plugin registered by add_resource_conversion_plugin().

---

void remove_scene_format_importer_plugin(scene_format_importer: EditorSceneFormatImporter) 

Removes a scene format importer registered by add_scene_format_importer_plugin().

---

void remove_scene_post_import_plugin(scene_import_plugin: EditorScenePostImportPlugin) 

Remove the EditorScenePostImportPlugin, added with add_scene_post_import_plugin().

---

void remove_tool_menu_item(name: String) 

Removes a menu name from Project > Tools.

---

void remove_translation_parser_plugin(parser: EditorTranslationParserPlugin) 

Removes a custom translation parser plugin registered by add_translation_parser_plugin().

---

void remove_undo_redo_inspector_hook_callback(callable: Callable) 

Removes a callback previously added by add_undo_redo_inspector_hook_callback().

---

void set_dock_tab_icon(control: Control, icon: Texture2D) 

Deprecated: Use EditorDock.dock_icon instead.

Sets the tab icon for the given control in a dock slot. Setting to null removes the icon.

---

void set_force_draw_over_forwarding_enabled() 

Enables calling of _forward_canvas_force_draw_over_viewport() for the 2D editor and _forward_3d_force_draw_over_viewport() for the 3D editor when their viewports are updated. You need to call this method only once and it will work permanently for this plugin.

---

void set_input_event_forwarding_always_enabled() 

Use this method if you always want to receive inputs from 3D view screen inside _forward_3d_gui_input(). It might be especially usable if your plugin will want to use raycast in the scene.

---

int update_overlays() const 

Updates the overlays of the 2D and 3D editor viewport. Causes methods _forward_canvas_draw_over_viewport(), _forward_canvas_force_draw_over_viewport(), _forward_3d_draw_over_viewport() and _forward_3d_force_draw_over_viewport() to be called.
