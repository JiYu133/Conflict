# ImporterMesh

Inherits: Resource < RefCounted < Object

A Resource that contains vertex array-based geometry during the import process.

## Description

ImporterMesh is a type of Resource analogous to ArrayMesh. It contains vertex array-based geometry, divided in surfaces. Each surface contains a completely separate array and a material used to draw it. Design wise, a mesh with multiple surfaces is preferred to a single surface, because objects created in 3D editing software commonly contain multiple materials.

Unlike its runtime counterpart, ImporterMesh contains mesh data before various import steps, such as LOD and shadow mesh generation, have taken place. Modify surface data by calling clear(), followed by add_surface() for each surface.

## Methods

void | add_blend_shape(name: String)
void | add_surface(primitive: PrimitiveType, arrays: Array, blend_shapes: Array[Array] = [], lods: Dictionary = {}, material: Material = null, name: String = "", flags: int = 0)
void | clear()
ImporterMesh | from_mesh(mesh: Mesh) static
void | generate_lods(normal_merge_angle: float, normal_split_angle: float, bone_transform_array: Array)
int | get_blend_shape_count() const
BlendShapeMode | get_blend_shape_mode() const
String | get_blend_shape_name(blend_shape_idx: int) const
Vector2i | get_lightmap_size_hint() const
ArrayMesh | get_mesh(base_mesh: ArrayMesh = null)
Array | get_surface_arrays(surface_idx: int) const
Array | get_surface_blend_shape_arrays(surface_idx: int, blend_shape_idx: int) const
int | get_surface_count() const
int | get_surface_format(surface_idx: int) const
int | get_surface_lod_count(surface_idx: int) const
PackedInt32Array | get_surface_lod_indices(surface_idx: int, lod_idx: int) const
float | get_surface_lod_size(surface_idx: int, lod_idx: int) const
Material | get_surface_material(surface_idx: int) const
String | get_surface_name(surface_idx: int) const
PrimitiveType | get_surface_primitive_type(surface_idx: int)
ImporterMesh | merge_importer_meshes(importer_meshes: Array[ImporterMesh], relative_transforms: Array[Transform3D], deduplicate_surfaces: bool = true) static
void | set_blend_shape_mode(mode: BlendShapeMode)
void | set_lightmap_size_hint(size: Vector2i)
void | set_surface_material(surface_idx: int, material: Material)
void | set_surface_name(surface_idx: int, name: String)

---

## Method Descriptions

void add_blend_shape(name: String) 

Adds name for a blend shape that will be added with add_surface(). Must be called before surface is added.

---

void add_surface(primitive: PrimitiveType, arrays: Array, blend_shapes: Array[Array] = [], lods: Dictionary = {}, material: Material = null, name: String = "", flags: int = 0) 

Creates a new surface. Mesh.get_surface_count() will become the surf_idx for this new surface.

Surfaces are created to be rendered using a primitive, which may be any of the values defined in PrimitiveType.

The arrays argument is an array of arrays. Each of the Mesh.ARRAY_MAX elements contains an array with some of the mesh data for this surface as described by the corresponding member of ArrayType or null if it is not used by the surface. For example, arrays[0] is the array of vertices. That first vertex sub-array is always required; the others are optional. Adding an index array puts this surface into "index mode" where the vertex and other arrays become the sources of data and the index array defines the vertex order. All sub-arrays must have the same length as the vertex array (or be an exact multiple of the vertex array's length, when multiple elements of a sub-array correspond to a single vertex) or be empty, except for Mesh.ARRAY_INDEX if it is used.

The blend_shapes argument is an array of vertex data for each blend shape. Each element is an array of the same structure as arrays, but Mesh.ARRAY_VERTEX, Mesh.ARRAY_NORMAL, and Mesh.ARRAY_TANGENT are set if and only if they are set in arrays and all other entries are null.

The lods argument is a dictionary with float keys and PackedInt32Array values. Each entry in the dictionary represents an LOD level of the surface, where the value is the Mesh.ARRAY_INDEX array to use for the LOD level and the key is roughly proportional to the distance at which the LOD stats being used. I.e., increasing the key of an LOD also increases the distance that the objects has to be from the camera before the LOD is used.

The flags argument is the bitwise OR of, as required: One value of ArrayCustomFormat left shifted by ARRAY_FORMAT_CUSTOMn_SHIFT for each custom channel in use, Mesh.ARRAY_FLAG_USE_DYNAMIC_UPDATE, Mesh.ARRAY_FLAG_USE_8_BONE_WEIGHTS, or Mesh.ARRAY_FLAG_USES_EMPTY_VERTEX_ARRAY.

Note: When using indices, it is recommended to only use points, lines, or triangles.

---

void clear() 

Removes all surfaces and blend shapes from this ImporterMesh.

---

ImporterMesh from_mesh(mesh: Mesh) static 

Converts the given Mesh into an ImporterMesh by copying all its surfaces, blend shapes, materials, and metadata into a new ImporterMesh object.

---

void generate_lods(normal_merge_angle: float, normal_split_angle: float, bone_transform_array: Array) 

Generates all lods for this ImporterMesh.

normal_merge_angle is in degrees and used in the same way as the importer settings in lods.

normal_split_angle is not used and only remains for compatibility with older versions of the API.

The number of generated lods can be accessed using get_surface_lod_count(), and each LOD is available in get_surface_lod_size() and get_surface_lod_indices().

bone_transform_array is an Array which can be either empty or contain Transform3Ds which, for each of the mesh's bone IDs, will apply mesh skinning when generating the LOD mesh variations. This is usually used to account for discrepancies in scale between the mesh itself and its skinning data.

---

int get_blend_shape_count() const 

Returns the number of blend shapes that the mesh holds.

---

BlendShapeMode get_blend_shape_mode() const 

Returns the blend shape mode for this Mesh.

---

String get_blend_shape_name(blend_shape_idx: int) const 

Returns the name of the blend shape at this index.

---

Vector2i get_lightmap_size_hint() const 

Returns the size hint of this mesh for lightmap-unwrapping in UV-space.

---

ArrayMesh get_mesh(base_mesh: ArrayMesh = null) 

Returns the mesh data represented by this ImporterMesh as a usable ArrayMesh.

This method caches the returned mesh, and subsequent calls will return the cached data until clear() is called.

If not yet cached and base_mesh is provided, base_mesh will be used and mutated.

---

Array get_surface_arrays(surface_idx: int) const 

Returns the arrays for the vertices, normals, UVs, etc. that make up the requested surface. See add_surface().

---

Array get_surface_blend_shape_arrays(surface_idx: int, blend_shape_idx: int) const 

Returns a single set of blend shape arrays for the requested blend shape index for a surface.

---

int get_surface_count() const 

Returns the number of surfaces that the mesh holds.

---

int get_surface_format(surface_idx: int) const 

Returns the format of the surface that the mesh holds.

---

int get_surface_lod_count(surface_idx: int) const 

Returns the number of lods that the mesh holds on a given surface.

---

PackedInt32Array get_surface_lod_indices(surface_idx: int, lod_idx: int) const 

Returns the index buffer of a lod for a surface.

---

float get_surface_lod_size(surface_idx: int, lod_idx: int) const 

Returns the screen ratio which activates a lod for a surface.

---

Material get_surface_material(surface_idx: int) const 

Returns a Material in a given surface. Surface is rendered using this material.

---

String get_surface_name(surface_idx: int) const 

Gets the name assigned to this surface.

---

PrimitiveType get_surface_primitive_type(surface_idx: int) 

Returns the primitive type of the requested surface (see add_surface()).

---

ImporterMesh merge_importer_meshes(importer_meshes: Array[ImporterMesh], relative_transforms: Array[Transform3D], deduplicate_surfaces: bool = true) static 

Merges multiple ImporterMeshes into a single ImporterMesh. Each input mesh is transformed by the corresponding Transform3D in the relative_transforms array, which must be the same size as importer_meshes. Negative scales are supported, and the winding order in the mesh data will be corrected to account for this.

If deduplicate_surfaces is true and multiple meshes have surfaces with the same names and formats, the surfaces will be merged together when the meshes are merged, and will use the material from the first matching surface. This is useful for reducing the number of surfaces in the resulting mesh, and avoids duplicating materials. Surfaces with bone weights will never be deduplicated. If deduplicate_surfaces is false, the surfaces will always be kept separate, and will be given unique names.

Warning: Blend shapes and LODs are not supported and will be discarded. Do not use this function to discard blend shapes and LODs, as support for these may be added in the future.

---

void set_blend_shape_mode(mode: BlendShapeMode) 

Sets the blend shape mode.

---

void set_lightmap_size_hint(size: Vector2i) 

Sets the size hint of this mesh for lightmap-unwrapping in UV-space.

---

void set_surface_material(surface_idx: int, material: Material) 

Sets a Material for a given surface. Surface will be rendered using this material.

---

void set_surface_name(surface_idx: int, name: String) 

Sets a name for a given surface.
