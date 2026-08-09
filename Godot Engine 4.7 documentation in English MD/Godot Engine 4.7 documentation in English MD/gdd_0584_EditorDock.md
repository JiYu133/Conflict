# EditorDock

Experimental: This class may be changed or removed in future versions.

Inherits: MarginContainer < Container < Control < CanvasItem < Node < Object

Inherited By: FileSystemDock

Dockable container for the editor.

## Description

EditorDock is a Container node that can be docked in one of the editor's dock slots. Docks are added by plugins to provide space for controls related to an EditorPlugin. The editor comes with a few built-in docks, such as the Scene dock, FileSystem dock, etc.

You can add a dock by using EditorPlugin.add_dock(). The dock can be customized by changing its properties.

```gdscript
@tool
extends EditorPlugin
# Dock reference.
var dock
# Plugin initialization.
func _enter_tree():
    dock = EditorDock.new()
    dock.title = "My Dock"
    dock.dock_icon = preload("./dock_icon.png")
    dock.default_slot = EditorDock.DOCK_SLOT_RIGHT_UL
    var dock_content = preload("./dock_content.tscn").instantiate()
    dock.add_child(dock_content)
    add_dock(dock)
# Plugin clean-up.
func _exit_tree():
    remove_dock(dock)
    dock.queue_free()
    dock = null
```

## Tutorials

- Making plugins

## Properties

bool | accessibility_region | true (overrides Container)
BitField[DockLayout] | available_layouts | 5
bool | closable | false
DockSlot | default_slot | -1
Texture2D | dock_icon |
Shortcut | dock_shortcut |
bool | force_show_icon | false
bool | global | true
StringName | icon_name | &""
String | layout_key | ""
String | title | ""
Color | title_color | Color(0, 0, 0, 0)
bool | transient | false

## Methods

void | _load_layout_from_config(config: ConfigFile, section: String) virtual
void | _save_layout_to_config(config: ConfigFile, section: String) virtual const
void | _update_layout(layout: int) virtual
void | close()
void | make_visible()
void | open()

---

## Signals

closed() 

Emitted when the dock is closed with the Close button in the context popup, before it's removed from its parent. See closable.

---

opened() 

Emitted when the dock is opened via the Editor > Editor Docks menu, before it's made visible.

---

## Enumerations

flags DockLayout: 

DockLayout DOCK_LAYOUT_VERTICAL = 1

Allows placing the dock in the vertical dock slots on either side of the editor.

DockLayout DOCK_LAYOUT_HORIZONTAL = 2

Allows placing the dock in the horizontal dock slots at the bottom.

DockLayout DOCK_LAYOUT_FLOATING = 4

Allows making the dock floating (opened as a separate window).

DockLayout DOCK_LAYOUT_ALL = 7

Allows placing the dock in all available slots.

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

Dock slot, left side, bottom-right (in default layout includes FileSystem and History docks).

DockSlot DOCK_SLOT_RIGHT_UL = 4

Dock slot, right side, upper-left (in default layout includes Inspector, Signal, and Group docks).

DockSlot DOCK_SLOT_RIGHT_BL = 5

Dock slot, right side, bottom-left (empty in default layout).

DockSlot DOCK_SLOT_RIGHT_UR = 6

Dock slot, right side, upper-right (empty in default layout).

DockSlot DOCK_SLOT_RIGHT_BR = 7

Dock slot, right side, bottom-right (empty in default layout).

DockSlot DOCK_SLOT_BOTTOM = 8

Bottom panel.

DockSlot DOCK_SLOT_BOTTOM_L = 9

Dock slot at the bottom, below bottom panel, on the left side.

DockSlot DOCK_SLOT_BOTTOM_R = 10

Dock slot at the bottom, below bottom panel, on the right side.

DockSlot DOCK_SLOT_MAX = 11

Represents the size of the DockSlot enum.

---

## Property Descriptions

BitField[DockLayout] available_layouts = 5 

- void set_available_layouts(value: BitField[DockLayout])
- BitField[DockLayout] get_available_layouts()

The available layouts for this dock, as a bitmask. By default, the dock allows vertical and floating layouts.

---

bool closable = false 

- void set_closable(value: bool)
- bool is_closable()

If true, the dock can be closed with the Close button in the context popup. Docks with global enabled are always closable.

---

DockSlot default_slot = -1 

- void set_default_slot(value: DockSlot)
- DockSlot get_default_slot()

The default dock slot used when adding the dock with EditorPlugin.add_dock().

After the dock is added, it can be moved to a different slot and the editor will automatically remember its position between sessions. If you remove and re-add the dock, it will be reset to default.

---

Texture2D dock_icon 

- void set_dock_icon(value: Texture2D)
- Texture2D get_dock_icon()

The icon for the dock, as a texture. If specified, it will override icon_name.

---

Shortcut dock_shortcut 

- void set_dock_shortcut(value: Shortcut)
- Shortcut get_dock_shortcut()

The shortcut used to open the dock.

---

bool force_show_icon = false 

- void set_force_show_icon(value: bool)
- bool get_force_show_icon()

If true, the dock will always display an icon, regardless of EditorSettings.interface/editor/docks/dock_tab_style or EditorSettings.interface/editor/docks/bottom_dock_tab_style.

---

bool global = true 

- void set_global(value: bool)
- bool is_global()

If true, the dock appears in the Editor > Editor Docks menu and can be closed. Non-global docks can still be closed using close() or when closable is true.

---

StringName icon_name = &"" 

- void set_icon_name(value: StringName)
- StringName get_icon_name()

The icon for the dock, as a name from the EditorIcons theme type in the editor theme. You can find the list of available icons here [https://godot-editor-icons.github.io/].

---

String layout_key = "" 

- void set_layout_key(value: String)
- String get_layout_key()

The key representing this dock in the editor's layout file. If empty, the dock's displayed name will be used instead.

---

String title = "" 

- void set_title(value: String)
- String get_title()

The title of the dock's tab. If empty, the dock's Node.name will be used. If the name is auto-generated (contains @), the first child's name will be used instead.

---

Color title_color = Color(0, 0, 0, 0) 

- void set_title_color(value: Color)
- Color get_title_color()

The color of the dock tab's title. If its alpha is 0.0, the default font color will be used.

---

bool transient = false 

- void set_transient(value: bool)
- bool is_transient()

If true, the dock is not automatically opened or closed when loading an editor layout, only moved. It also can't be opened using a shortcut. This is meant for docks that are opened and closed in specific cases, such as when selecting a TileMap or AnimationTree node.

---

## Method Descriptions

void _load_layout_from_config(config: ConfigFile, section: String) virtual 

Implement this method to handle loading this dock's layout. It's equivalent to EditorPlugin._set_window_layout(). section is a unique section based on layout_key.

---

void _save_layout_to_config(config: ConfigFile, section: String) virtual const 

Implement this method to handle saving this dock's layout. It's equivalent to EditorPlugin._get_window_layout(). section is a unique section based on layout_key.

---

void _update_layout(layout: int) virtual 

Implement this method to handle the layout switching for this dock. layout is one of the DockLayout constants.

```gdscript
func _update_layout(layout):
    box_container.vertical = (layout == DOCK_LAYOUT_VERTICAL)
```

---

void close() 

Closes the dock, making its tab hidden.

---

void make_visible() 

Focuses the dock's tab (or window if it's floating). If the dock was closed, it will be opened. If it's a bottom dock, makes the bottom panel visible.

---

void open() 

Opens the dock. It will appear in the last used dock slot. If the dock has no default slot, it will be opened floating.

Note: This does not focus the dock. If you want to open and focus the dock, use make_visible().
