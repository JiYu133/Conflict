# ResourceSaver

Inherits: Object

A singleton for saving Resources to the filesystem.

## Description

A singleton for saving resource types to the filesystem.

It uses the many ResourceFormatSaver classes registered in the engine (either built-in or from a plugin) to save resource data to text-based (e.g. .tres or .tscn) or binary files (e.g. .res or .scn).

## Methods

void | add_resource_format_saver(format_saver: ResourceFormatSaver, at_front: bool = false)
PackedStringArray | get_recognized_extensions(type: Resource)
int | get_resource_id_for_path(path: String, generate: bool = false)
void | remove_resource_format_saver(format_saver: ResourceFormatSaver)
Error | save(resource: Resource, path: String = "", flags: BitField[SaverFlags] = 0)
Error | set_uid(resource: String, uid: int)

---

## Enumerations

flags SaverFlags: 

SaverFlags FLAG_NONE = 0

No resource saving option.

SaverFlags FLAG_RELATIVE_PATHS = 1

Save the resource with a path relative to the scene which uses it.

SaverFlags FLAG_BUNDLE_RESOURCES = 2

Bundles external resources.

SaverFlags FLAG_CHANGE_PATH = 4

Changes the Resource.resource_path of the saved resource to match its new location.

SaverFlags FLAG_OMIT_EDITOR_PROPERTIES = 8

Do not save editor-specific metadata (identified by their __editor prefix).

SaverFlags FLAG_SAVE_BIG_ENDIAN = 16

Save as big endian (see FileAccess.big_endian).

SaverFlags FLAG_COMPRESS = 32

Compress the resource on save using FileAccess.COMPRESSION_ZSTD. Only available for binary resource types.

SaverFlags FLAG_REPLACE_SUBRESOURCE_PATHS = 64

Take over the paths of the saved subresources (see Resource.take_over_path()).

---

## Method Descriptions

void add_resource_format_saver(format_saver: ResourceFormatSaver, at_front: bool = false) 

Registers a new ResourceFormatSaver. The ResourceSaver will use the ResourceFormatSaver as described in save().

This method is performed implicitly for ResourceFormatSavers written in GDScript (see ResourceFormatSaver for more information).

---

PackedStringArray get_recognized_extensions(type: Resource) 

Returns the list of extensions available for saving a resource of a given type.

---

int get_resource_id_for_path(path: String, generate: bool = false) 

Returns the resource ID for the given path. If generate is true, a new resource ID will be generated if one for the path is not found. If generate is false and the path is not found, ResourceUID.INVALID_ID is returned.

---

void remove_resource_format_saver(format_saver: ResourceFormatSaver) 

Unregisters the given ResourceFormatSaver.

---

Error save(resource: Resource, path: String = "", flags: BitField[SaverFlags] = 0) 

Saves a resource to disk to the given path, using a ResourceFormatSaver that recognizes the resource object. If path is empty, ResourceSaver will try to use Resource.resource_path.

The flags bitmask can be specified to customize the save behavior.

Returns @GlobalScope.OK on success.

Note: When the project is running, any generated UID associated with the resource will not be saved as the required code is only executed in editor mode.

---

Error set_uid(resource: String, uid: int) 

Sets the UID of the given resource path to uid. You can generate a new UID using ResourceUID.create_id().

Since resources will normally get a UID automatically, this method is only useful in very specific cases.
