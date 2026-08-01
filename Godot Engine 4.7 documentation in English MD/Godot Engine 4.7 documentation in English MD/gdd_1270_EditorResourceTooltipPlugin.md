# EditorResourceTooltipPlugin

Inherits: RefCounted < Object

A plugin that advanced tooltip for its handled resource type.

## Description

Resource tooltip plugins are used by FileSystemDock to generate customized tooltips for specific resources. E.g. tooltip for a Texture2D displays a bigger preview and the texture's dimensions.

A plugin must be first registered with FileSystemDock.add_resource_tooltip_plugin(). When the user hovers a resource in filesystem dock which is handled by the plugin, _make_tooltip_for_path() is called to create the tooltip. It works similarly to Control._make_custom_tooltip().

## Methods

bool | _handles(type: String) virtual const
Control | _make_tooltip_for_path(path: String, metadata: Dictionary, base: Control) virtual const
void | request_thumbnail(path: String, control: TextureRect) const

---

## Method Descriptions

bool _handles(type: String) virtual const 

Return true if the plugin is going to handle the given Resource type.

---

Control _make_tooltip_for_path(path: String, metadata: Dictionary, base: Control) virtual const 

Create and return a tooltip that will be displayed when the user hovers a resource under the given path in filesystem dock.

The metadata dictionary is provided by preview generator (see EditorResourcePreviewGenerator._generate()).

base is the base default tooltip, which is a VBoxContainer with a file name, type and size labels. If another plugin handled the same file type, base will be output from the previous plugin. For best result, make sure the base tooltip is part of the returned Control.

Note: It's unadvised to use ResourceLoader.load(), especially with heavy resources like models or textures, because it will make the editor unresponsive when creating the tooltip. You can use request_thumbnail() if you want to display a preview in your tooltip.

Note: If you decide to discard the base, make sure to call Node.queue_free(), because it's not freed automatically.

```gdscript
func _make_tooltip_for_path(path, metadata, base):
    var t_rect = TextureRect.new()
    request_thumbnail(path, t_rect)
    base.add_child(t_rect) # The TextureRect will appear at the bottom of the tooltip.
    return base
```

---

void request_thumbnail(path: String, control: TextureRect) const 

Requests a thumbnail for the given TextureRect. The thumbnail is created asynchronously by EditorResourcePreview and automatically set when available.
