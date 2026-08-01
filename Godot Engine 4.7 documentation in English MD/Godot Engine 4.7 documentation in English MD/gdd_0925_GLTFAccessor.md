# GLTFAccessor

Inherits: Resource < RefCounted < Object

Represents a glTF accessor.

## Description

GLTFAccessor is a data structure representing a glTF accessor that would be found in the "accessors" array. A buffer is a blob of binary data. A buffer view is a slice of a buffer. An accessor is a typed interpretation of the data in a buffer view.

Most custom data stored in glTF does not need accessors, only buffer views (see GLTFBufferView). Accessors are for more advanced use cases such as interleaved mesh data encoded for the GPU.

## Tutorials

- Buffers, BufferViews, and Accessors in Khronos glTF specification [https://github.com/KhronosGroup/glTF-Tutorials/blob/master/gltfTutorial/gltfTutorial_005_BuffersBufferViewsAccessors.md]
- Runtime file loading and saving

## Properties

GLTFAccessorType | accessor_type | 0
int | buffer_view | -1
int | byte_offset | 0
GLTFComponentType | component_type | 0
int | count | 0
PackedFloat64Array | max | PackedFloat64Array()
PackedFloat64Array | min | PackedFloat64Array()
bool | normalized | false
int | sparse_count | 0
int | sparse_indices_buffer_view | 0
int | sparse_indices_byte_offset | 0
GLTFComponentType | sparse_indices_component_type | 0
int | sparse_values_buffer_view | 0
int | sparse_values_byte_offset | 0
int | type |

## Methods

GLTFAccessor | from_dictionary(dictionary: Dictionary) static
Dictionary | to_dictionary() const

---

## Enumerations

enum GLTFAccessorType
GLTFAccessorType TYPE_SCALAR = 0

Accessor type "SCALAR". For the glTF object model, this can be used to map to a single float, int, or bool value, or a float array.

GLTFAccessorType TYPE_VEC2 = 1

Accessor type "VEC2". For the glTF object model, this maps to "float2", represented in the glTF JSON as an array of two floats.

GLTFAccessorType TYPE_VEC3 = 2

Accessor type "VEC3". For the glTF object model, this maps to "float3", represented in the glTF JSON as an array of three floats.

GLTFAccessorType TYPE_VEC4 = 3

Accessor type "VEC4". For the glTF object model, this maps to "float4", represented in the glTF JSON as an array of four floats.

GLTFAccessorType TYPE_MAT2 = 4

Accessor type "MAT2". For the glTF object model, this maps to "float2x2", represented in the glTF JSON as an array of four floats.

GLTFAccessorType TYPE_MAT3 = 5

Accessor type "MAT3". For the glTF object model, this maps to "float3x3", represented in the glTF JSON as an array of nine floats.

GLTFAccessorType TYPE_MAT4 = 6

Accessor type "MAT4". For the glTF object model, this maps to "float4x4", represented in the glTF JSON as an array of sixteen floats.

---

enum GLTFComponentType
GLTFComponentType COMPONENT_TYPE_NONE = 0

Component type "NONE". This is not a valid component type, and is used to indicate that the component type is not set.

GLTFComponentType COMPONENT_TYPE_SIGNED_BYTE = 5120

Component type "BYTE". The value is 0x1400 which comes from OpenGL. This indicates data is stored in 1-byte or 8-bit signed integers. This is a core part of the glTF specification.

GLTFComponentType COMPONENT_TYPE_UNSIGNED_BYTE = 5121

Component type "UNSIGNED_BYTE". The value is 0x1401 which comes from OpenGL. This indicates data is stored in 1-byte or 8-bit unsigned integers. This is a core part of the glTF specification.

GLTFComponentType COMPONENT_TYPE_SIGNED_SHORT = 5122

Component type "SHORT". The value is 0x1402 which comes from OpenGL. This indicates data is stored in 2-byte or 16-bit signed integers. This is a core part of the glTF specification.

GLTFComponentType COMPONENT_TYPE_UNSIGNED_SHORT = 5123

Component type "UNSIGNED_SHORT". The value is 0x1403 which comes from OpenGL. This indicates data is stored in 2-byte or 16-bit unsigned integers. This is a core part of the glTF specification.

GLTFComponentType COMPONENT_TYPE_SIGNED_INT = 5124

Component type "INT". The value is 0x1404 which comes from OpenGL. This indicates data is stored in 4-byte or 32-bit signed integers. This is NOT a core part of the glTF specification, and may not be supported by all glTF importers. May be used by some extensions including KHR_interactivity.

GLTFComponentType COMPONENT_TYPE_UNSIGNED_INT = 5125

Component type "UNSIGNED_INT". The value is 0x1405 which comes from OpenGL. This indicates data is stored in 4-byte or 32-bit unsigned integers. This is a core part of the glTF specification.

GLTFComponentType COMPONENT_TYPE_SINGLE_FLOAT = 5126

Component type "FLOAT". The value is 0x1406 which comes from OpenGL. This indicates data is stored in 4-byte or 32-bit floating-point numbers. This is a core part of the glTF specification.

GLTFComponentType COMPONENT_TYPE_DOUBLE_FLOAT = 5130

Component type "DOUBLE". The value is 0x140A which comes from OpenGL. This indicates data is stored in 8-byte or 64-bit floating-point numbers. This is NOT a core part of the glTF specification, and may not be supported by all glTF importers. May be used by some extensions including KHR_interactivity.

GLTFComponentType COMPONENT_TYPE_HALF_FLOAT = 5131

Component type "HALF_FLOAT". The value is 0x140B which comes from OpenGL. This indicates data is stored in 2-byte or 16-bit floating-point numbers. This is NOT a core part of the glTF specification, and may not be supported by all glTF importers. May be used by some extensions including KHR_interactivity.

GLTFComponentType COMPONENT_TYPE_SIGNED_LONG = 5134

Component type "LONG". The value is 0x140E which comes from OpenGL. This indicates data is stored in 8-byte or 64-bit signed integers. This is NOT a core part of the glTF specification, and may not be supported by all glTF importers. May be used by some extensions including KHR_interactivity.

GLTFComponentType COMPONENT_TYPE_UNSIGNED_LONG = 5135

Component type "UNSIGNED_LONG". The value is 0x140F which comes from OpenGL. This indicates data is stored in 8-byte or 64-bit unsigned integers. This is NOT a core part of the glTF specification, and may not be supported by all glTF importers. May be used by some extensions including KHR_interactivity.

---

## Property Descriptions

GLTFAccessorType accessor_type = 0 

- void set_accessor_type(value: GLTFAccessorType)
- GLTFAccessorType get_accessor_type()

The glTF accessor type, as an enum.

---

int buffer_view = -1 

- void set_buffer_view(value: int)
- int get_buffer_view()

The index of the buffer view this accessor is referencing. If -1, this accessor is not referencing any buffer view.

---

int byte_offset = 0 

- void set_byte_offset(value: int)
- int get_byte_offset()

The offset relative to the start of the buffer view in bytes.

---

GLTFComponentType component_type = 0 

- void set_component_type(value: GLTFComponentType)
- GLTFComponentType get_component_type()

The glTF component type as an enum. See GLTFComponentType for possible values. Within the core glTF specification, a value of 5125 or "UNSIGNED_INT" must not be used for any accessor that is not referenced by mesh.primitive.indices.

---

int count = 0 

- void set_count(value: int)
- int get_count()

The number of elements referenced by this accessor.

---

PackedFloat64Array max = PackedFloat64Array() 

- void set_max(value: PackedFloat64Array)
- PackedFloat64Array get_max()

Maximum value of each component in this accessor.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedFloat64Array for more details.

---

PackedFloat64Array min = PackedFloat64Array() 

- void set_min(value: PackedFloat64Array)
- PackedFloat64Array get_min()

Minimum value of each component in this accessor.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedFloat64Array for more details.

---

bool normalized = false 

- void set_normalized(value: bool)
- bool get_normalized()

Specifies whether integer data values are normalized before usage.

---

int sparse_count = 0 

- void set_sparse_count(value: int)
- int get_sparse_count()

Number of deviating accessor values stored in the sparse array.

---

int sparse_indices_buffer_view = 0 

- void set_sparse_indices_buffer_view(value: int)
- int get_sparse_indices_buffer_view()

The index of the buffer view with sparse indices. The referenced buffer view MUST NOT have its target or byteStride properties defined. The buffer view and the optional byteOffset MUST be aligned to the componentType byte length.

---

int sparse_indices_byte_offset = 0 

- void set_sparse_indices_byte_offset(value: int)
- int get_sparse_indices_byte_offset()

The offset relative to the start of the buffer view in bytes.

---

GLTFComponentType sparse_indices_component_type = 0 

- void set_sparse_indices_component_type(value: GLTFComponentType)
- GLTFComponentType get_sparse_indices_component_type()

The indices component data type as an enum. Possible values are 5121 for "UNSIGNED_BYTE", 5123 for "UNSIGNED_SHORT", and 5125 for "UNSIGNED_INT".

---

int sparse_values_buffer_view = 0 

- void set_sparse_values_buffer_view(value: int)
- int get_sparse_values_buffer_view()

The index of the bufferView with sparse values. The referenced buffer view MUST NOT have its target or byteStride properties defined.

---

int sparse_values_byte_offset = 0 

- void set_sparse_values_byte_offset(value: int)
- int get_sparse_values_byte_offset()

The offset relative to the start of the bufferView in bytes.

---

int type 

- void set_type(value: int)
- int get_type()

Deprecated: Use accessor_type instead.

The glTF accessor type, as an int. Possible values are 0 for "SCALAR", 1 for "VEC2", 2 for "VEC3", 3 for "VEC4", 4 for "MAT2", 5 for "MAT3", and 6 for "MAT4".

---

## Method Descriptions

GLTFAccessor from_dictionary(dictionary: Dictionary) static 

Creates a new GLTFAccessor instance by parsing the given Dictionary.

---

Dictionary to_dictionary() const 

Serializes this GLTFAccessor instance into a Dictionary.
