# TileSetScenesCollectionSource

Inherits: TileSetSource < Resource < RefCounted < Object

Exposes a set of scenes as tiles for a TileSet resource.

## Description

When placed on a TileMapLayer, tiles from TileSetScenesCollectionSource will automatically instantiate an associated scene at the cell's position in the TileMapLayer.

Scenes are instantiated as children of the TileMapLayer after it enters the tree, at the end of the frame (their creation is deferred). If you add/remove a scene tile in the TileMapLayer that is already inside the tree, the TileMapLayer will automatically instantiate/free the scene accordingly.

Note: Scene tiles all occupy one tile slot and instead use alternate tile ID to identify scene index. TileSetSource.get_tiles_count() will always return 1. Use get_scene_tiles_count() to get a number of scenes in a TileSetScenesCollectionSource.

Use this code if you want to find the scene path at a given tile in TileMapLayer:

```
var source_id = tile_map_layer.get_cell_source_id(Vector2i(x, y))
if source_id > -1:
    var scene_source = tile_map_layer.tile_set.get_source(source_id)
    if scene_source is TileSetScenesCollectionSource:
        var alt_id = tile_map_layer.get_cell_alternative_tile(Vector2i(x, y))
        # The assigned PackedScene.
        var scene = scene_source.get_scene_tile_scene(alt_id)
```

```
int sourceId = tileMapLayer.GetCellSourceId(new Vector2I(x, y));
if (sourceId > -1)
{
    TileSetSource source = tileMapLayer.TileSet.GetSource(sourceId);
    if (source is TileSetScenesCollectionSource sceneSource)
    {
        int altId = tileMapLayer.GetCellAlternativeTile(new Vector2I(x, y));
        // The assigned PackedScene.
        PackedScene scene = sceneSource.GetSceneTileScene(altId);
    }
}
```

## Methods

int | create_scene_tile(packed_scene: PackedScene, id_override: int = -1)
int | get_next_scene_tile_id() const
bool | get_scene_tile_display_placeholder(id: int) const
int | get_scene_tile_id(index: int)
PackedScene | get_scene_tile_scene(id: int) const
int | get_scene_tiles_count()
bool | has_scene_tile_id(id: int)
void | remove_scene_tile(id: int)
void | set_scene_tile_display_placeholder(id: int, display_placeholder: bool)
void | set_scene_tile_id(id: int, new_id: int)
void | set_scene_tile_scene(id: int, packed_scene: PackedScene)

---

## Method Descriptions

int create_scene_tile(packed_scene: PackedScene, id_override: int = -1) 

Creates a scene-based tile out of the given scene.

Returns a newly generated unique ID.

---

int get_next_scene_tile_id() const 

Returns the scene ID a following call to create_scene_tile() would return.

---

bool get_scene_tile_display_placeholder(id: int) const 

Returns whether the scene tile with id displays a placeholder in the editor.

---

int get_scene_tile_id(index: int) 

Returns the scene tile ID of the scene tile at index.

---

PackedScene get_scene_tile_scene(id: int) const 

Returns the PackedScene resource of scene tile with id.

---

int get_scene_tiles_count() 

Returns the number or scene tiles this TileSet source has.

---

bool has_scene_tile_id(id: int) 

Returns whether this TileSet source has a scene tile with id.

---

void remove_scene_tile(id: int) 

Remove the scene tile with id.

---

void set_scene_tile_display_placeholder(id: int, display_placeholder: bool) 

Sets whether or not the scene tile with id should display a placeholder in the editor. This might be useful for scenes that are not visible.

---

void set_scene_tile_id(id: int, new_id: int) 

Changes a scene tile's ID from id to new_id. This will fail if there is already a tile with an ID equal to new_id.

---

void set_scene_tile_scene(id: int, packed_scene: PackedScene) 

Assigns a PackedScene resource to the scene tile with id. This will fail if the scene does not extend CanvasItem, as positioning properties are needed to place the scene on the TileMapLayer.
