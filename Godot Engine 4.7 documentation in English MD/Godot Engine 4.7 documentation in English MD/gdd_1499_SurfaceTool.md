# SurfaceTool

Inherits: RefCounted < Object

Helper tool to create geometry.

## Description

The SurfaceTool is used to construct a Mesh by specifying vertex attributes individually. It can be used to construct a Mesh from a script. All properties except indices need to be added before calling add_vertex(). For example, to add vertex colors and UVs:

```
var st = SurfaceTool.new()
st.begin(Mesh.PRIMITIVE_TRIANGLES)
st.set_color(Color(1, 0, 0))
st.set_uv(Vector2(0, 0))
st.add_vertex(Vector3(0, 0, 0))
```

```
var st = new SurfaceTool();
st.Begin(Mesh.PrimitiveType.Triangles);
st.SetColor(new Color(1, 0, 0));
st.SetUV(new Vector2(0, 0));
st.AddVertex(new Vector3(0, 0, 0));
```

The above SurfaceTool now contains one vertex of a triangle which has a UV coordinate and a specified Color. If another vertex were added without calling set_uv() or set_color(), then the last values would be used.

Vertex attributes must be passed before calling add_vertex(). Failure to do so will result in an error when committing the vertex information to a mesh.

Additionally, the attributes used before the first vertex is added determine the format of the mesh. For example, if you only add UVs to the first vertex, you cannot add color to any of the subsequent vertices.

See also ArrayMesh, ImmediateMesh and MeshDataTool for procedural geometry generation.

Note: Godot uses clockwise winding order [https://learnopengl.com/Advanced-OpenGL/Face-culling] for front faces of triangle primitive modes.

## Tutorials

- Using the SurfaceTool
- 3D Voxel Demo [https://godotengine.org/asset-library/asset/2755]

## Methods

void | add_index(index: int)
void | add_triangle_fan(vertices: PackedVector3Array, uvs: PackedVector2Array = PackedVector2Array(), colors: PackedColorArray = PackedColorArray(), uv2s: PackedVector2Array = PackedVector2Array(), normals: PackedVector3Array = PackedVector3Array(), tangents: Array[Plane] = [])
void | add_vertex(vertex: Vector3)
void | append_from(existing: Mesh, surface: int, transform: Transform3D)
void | begin(primitive: PrimitiveType)
void | clear()
ArrayMesh | commit(existing: ArrayMesh = null, flags: int = 0)
Array | commit_to_arrays()
void | create_from(existing: Mesh, surface: int)
void | create_from_arrays(arrays: Array, primitive_type: PrimitiveType = 3)
void | create_from_blend_shape(existing: Mesh, surface: int, blend_shape: String)
void | deindex()
PackedInt32Array | generate_lod(nd_threshold: float, target_index_count: int = 3)
void | generate_normals(flip: bool = false)
void | generate_tangents()
AABB | get_aabb() const
CustomFormat | get_custom_format(channel_index: int) const
PrimitiveType | get_primitive_type() const
SkinWeightCount | get_skin_weight_count() const
void | index()
void | optimize_indices_for_cache()
void | set_bones(bones: PackedInt32Array)
void | set_color(color: Color)
void | set_custom(channel_index: int, custom_color: Color)
void | set_custom_format(channel_index: int, format: CustomFormat)
void | set_material(material: Material)
void | set_normal(normal: Vector3)
void | set_skin_weight_count(count: SkinWeightCount)
void | set_smooth_group(index: int)
void | set_tangent(tangent: Plane)
void | set_uv(uv: Vector2)
void | set_uv2(uv2: Vector2)
void | set_weights(weights: PackedFloat32Array)

---

## Enumerations

enum CustomFormat
CustomFormat CUSTOM_RGBA8_UNORM = 0

Limits range of data passed to set_custom() to unsigned normalized 0 to 1 stored in 8 bits per channel. See Mesh.ARRAY_CUSTOM_RGBA8_UNORM.

CustomFormat CUSTOM_RGBA8_SNORM = 1

Limits range of data passed to set_custom() to signed normalized -1 to 1 stored in 8 bits per channel. See Mesh.ARRAY_CUSTOM_RGBA8_SNORM.

CustomFormat CUSTOM_RG_HALF = 2

Stores data passed to set_custom() as half precision floats, and uses only red and green color channels. See Mesh.ARRAY_CUSTOM_RG_HALF.

CustomFormat CUSTOM_RGBA_HALF = 3

Stores data passed to set_custom() as half precision floats and uses all color channels. See Mesh.ARRAY_CUSTOM_RGBA_HALF.

CustomFormat CUSTOM_R_FLOAT = 4

Stores data passed to set_custom() as full precision floats, and uses only red color channel. See Mesh.ARRAY_CUSTOM_R_FLOAT.

CustomFormat CUSTOM_RG_FLOAT = 5

Stores data passed to set_custom() as full precision floats, and uses only red and green color channels. See Mesh.ARRAY_CUSTOM_RG_FLOAT.

CustomFormat CUSTOM_RGB_FLOAT = 6

Stores data passed to set_custom() as full precision floats, and uses only red, green and blue color channels. See Mesh.ARRAY_CUSTOM_RGB_FLOAT.

CustomFormat CUSTOM_RGBA_FLOAT = 7

Stores data passed to set_custom() as full precision floats, and uses all color channels. See Mesh.ARRAY_CUSTOM_RGBA_FLOAT.

CustomFormat CUSTOM_MAX = 8

Used to indicate a disabled custom channel.

---

enum SkinWeightCount
SkinWeightCount SKIN_4_WEIGHTS = 0

Each individual vertex can be influenced by only 4 bone weights.

SkinWeightCount SKIN_8_WEIGHTS = 1

Each individual vertex can be influenced by up to 8 bone weights.

---

## Method Descriptions

void add_index(index: int) 

Adds a vertex to index array if you are using indexed vertices. Does not need to be called before adding vertices.

---

void add_triangle_fan(vertices: PackedVector3Array, uvs: PackedVector2Array = PackedVector2Array(), colors: PackedColorArray = PackedColorArray(), uv2s: PackedVector2Array = PackedVector2Array(), normals: PackedVector3Array = PackedVector3Array(), tangents: Array[Plane] = []) 

Inserts a triangle fan made of array data into Mesh being constructed.

Requires the primitive type be set to Mesh.PRIMITIVE_TRIANGLES.

---

void add_vertex(vertex: Vector3) 

Specifies the position of current vertex. Should be called after specifying other vertex properties (e.g. Color, UV).

---

void append_from(existing: Mesh, surface: int, transform: Transform3D) 

Append vertices from a given Mesh surface onto the current vertex array with specified Transform3D.

---

void begin(primitive: PrimitiveType) 

Called before adding any vertices. Takes the primitive type as an argument (e.g. Mesh.PRIMITIVE_TRIANGLES).

---

void clear() 

Clear all information passed into the surface tool so far.

---

ArrayMesh commit(existing: ArrayMesh = null, flags: int = 0) 

Returns a constructed ArrayMesh from current information passed in. If an existing ArrayMesh is passed in as an argument, will add an extra surface to the existing ArrayMesh.

The flags argument can be the bitwise OR of Mesh.ARRAY_FLAG_USE_DYNAMIC_UPDATE, Mesh.ARRAY_FLAG_USE_8_BONE_WEIGHTS, or Mesh.ARRAY_FLAG_USES_EMPTY_VERTEX_ARRAY.

---

Array commit_to_arrays() 

Commits the data to the same format used by ArrayMesh.add_surface_from_arrays(), ImporterMesh.add_surface(), and create_from_arrays(). This way you can further process the mesh data using the ArrayMesh or ImporterMesh APIs.

---

void create_from(existing: Mesh, surface: int) 

Creates a vertex array from an existing Mesh.

---

void create_from_arrays(arrays: Array, primitive_type: PrimitiveType = 3) 

Creates this SurfaceTool from existing vertex arrays such as returned by commit_to_arrays(), Mesh.surface_get_arrays(), Mesh.surface_get_blend_shape_arrays(), ImporterMesh.get_surface_arrays(), and ImporterMesh.get_surface_blend_shape_arrays(). primitive_type controls the type of mesh data, defaulting to Mesh.PRIMITIVE_TRIANGLES.

---

void create_from_blend_shape(existing: Mesh, surface: int, blend_shape: String) 

Creates a vertex array from the specified blend shape of an existing Mesh. This can be used to extract a specific pose from a blend shape.

---

void deindex() 

Removes the index array by expanding the vertex array.

---

PackedInt32Array generate_lod(nd_threshold: float, target_index_count: int = 3) 

Deprecated: This method is unused internally, as it does not preserve normals or UVs. Consider using ImporterMesh.generate_lods() instead.

Generates an LOD for a given nd_threshold in linear units (square root of quadric error metric), using at most target_index_count indices.

---

void generate_normals(flip: bool = false) 

Generates normals from vertices so you do not have to do it manually. If flip is true, the resulting normals will be inverted. generate_normals() should be called after generating geometry and before committing the mesh using commit() or commit_to_arrays(). For correct display of normal-mapped surfaces, you will also have to generate tangents using generate_tangents().

Note: generate_normals() only works if the primitive type is set to Mesh.PRIMITIVE_TRIANGLES.

Note: generate_normals() takes smooth groups into account. To generate smooth normals, set the smooth group to a value greater than or equal to 0 using set_smooth_group() or leave the smooth group at the default of 0. To generate flat normals, set the smooth group to -1 using set_smooth_group() prior to adding vertices.

---

void generate_tangents() 

Generates a tangent vector for each vertex. Requires that each vertex already has UVs and normals set (see generate_normals()).

---

AABB get_aabb() const 

Returns the axis-aligned bounding box of the vertex positions.

---

CustomFormat get_custom_format(channel_index: int) const 

Returns the format for custom channel_index (currently up to 4). Returns CUSTOM_MAX if this custom channel is unused.

---

PrimitiveType get_primitive_type() const 

Returns the type of mesh geometry, such as Mesh.PRIMITIVE_TRIANGLES.

---

SkinWeightCount get_skin_weight_count() const 

By default, returns SKIN_4_WEIGHTS to indicate only 4 bone influences per vertex are used.

Returns SKIN_8_WEIGHTS if up to 8 influences are used.

Note: This function returns an enum, not the exact number of weights.

---

void index() 

Shrinks the vertex array by creating an index array. This can improve performance by avoiding vertex reuse.

---

void optimize_indices_for_cache() 

Optimizes triangle sorting for performance. Requires that get_primitive_type() is Mesh.PRIMITIVE_TRIANGLES.

---

void set_bones(bones: PackedInt32Array) 

Specifies an array of bones to use for the next vertex. bones must contain 4 integers.

---

void set_color(color: Color) 

Specifies a Color to use for the next vertex. If every vertex needs to have this information set and you fail to submit it for the first vertex, this information may not be used at all.

Note: The material must have BaseMaterial3D.vertex_color_use_as_albedo enabled for the vertex color to be visible.

---

void set_custom(channel_index: int, custom_color: Color) 

Sets the custom value on this vertex for channel_index.

set_custom_format() must be called first for this channel_index. Formats which are not RGBA will ignore other color channels.

---

void set_custom_format(channel_index: int, format: CustomFormat) 

Sets the color format for this custom channel_index. Use CUSTOM_MAX to disable.

Must be invoked after begin() and should be set before commit() or commit_to_arrays().

---

void set_material(material: Material) 

Sets Material to be used by the Mesh you are constructing.

---

void set_normal(normal: Vector3) 

Specifies a normal to use for the next vertex. If every vertex needs to have this information set and you fail to submit it for the first vertex, this information may not be used at all.

---

void set_skin_weight_count(count: SkinWeightCount) 

Set to SKIN_8_WEIGHTS to indicate that up to 8 bone influences per vertex may be used.

By default, only 4 bone influences are used (SKIN_4_WEIGHTS).

Note: This function takes an enum, not the exact number of weights.

---

void set_smooth_group(index: int) 

Specifies the smooth group to use for the next vertex. If this is never called, all vertices will have the default smooth group of 0 and will be smoothed with adjacent vertices of the same group. To produce a mesh with flat normals, set the smooth group to -1.

Note: This function actually takes a uint32_t, so C# users should use uint32.MaxValue instead of -1 to produce a mesh with flat normals.

---

void set_tangent(tangent: Plane) 

Specifies a tangent to use for the next vertex. If every vertex needs to have this information set and you fail to submit it for the first vertex, this information may not be used at all.

Note: Even though tangent is a Plane, it does not directly represent the tangent plane. Its Plane.x, Plane.y, and Plane.z represent the tangent vector and Plane.d should be either -1 or 1. See also Mesh.ARRAY_TANGENT.

---

void set_uv(uv: Vector2) 

Specifies a set of UV coordinates to use for the next vertex. If every vertex needs to have this information set and you fail to submit it for the first vertex, this information may not be used at all.

---

void set_uv2(uv2: Vector2) 

Specifies an optional second set of UV coordinates to use for the next vertex. If every vertex needs to have this information set and you fail to submit it for the first vertex, this information may not be used at all.

---

void set_weights(weights: PackedFloat32Array) 

Specifies weight values to use for the next vertex. weights must contain 4 values. If every vertex needs to have this information set and you fail to submit it for the first vertex, this information may not be used at all.
