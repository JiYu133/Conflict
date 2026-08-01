# ResourceImporter

Inherits: RefCounted < Object

Inherited By: EditorImportPlugin, ResourceImporterBitMap, ResourceImporterBMFont, ResourceImporterCSVTranslation, ResourceImporterDynamicFont, ResourceImporterImage, ResourceImporterImageFont, ResourceImporterLayeredTexture, ResourceImporterMP3, ResourceImporterOBJ, ResourceImporterOggVorbis, ResourceImporterScene, ResourceImporterShaderFile, ResourceImporterSVG, ResourceImporterTexture, ResourceImporterTextureAtlas, ResourceImporterWAV

Base class for resource importers.

## Description

This is the base class for Godot's resource importers. To implement your own resource importers using editor plugins, see EditorImportPlugin.

## Tutorials

- Import plugins

## Methods

PackedStringArray | _get_build_dependencies(path: String) virtual const

---

## Enumerations

enum ImportOrder
ImportOrder IMPORT_ORDER_DEFAULT = 0

The default import order.

ImportOrder IMPORT_ORDER_SCENE = 100

The import order for scenes, which ensures scenes are imported after all other core resources such as textures. Custom importers should generally have an import order lower than 100 to avoid issues when importing scenes that rely on custom resources.

---

## Method Descriptions

PackedStringArray _get_build_dependencies(path: String) virtual const 

Called when the engine compilation profile editor wants to check what build options an imported resource needs. For example, ResourceImporterDynamicFont has a property called ResourceImporterDynamicFont.multichannel_signed_distance_field, that depends on the engine to be build with the "msdfgen" module. If that resource happened to be a custom one, it would be handled like this:

```gdscript
func _get_build_dependencies(path):
    var resource = load(path)
    var dependencies = PackedStringArray()
    if resource.multichannel_signed_distance_field:
        dependencies.push_back("module_msdfgen_enabled")
    return dependencies
```
