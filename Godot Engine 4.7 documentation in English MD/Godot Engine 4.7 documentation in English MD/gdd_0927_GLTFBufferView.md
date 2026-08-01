# GLTFBufferView

Inherits: Resource < RefCounted < Object

Represents a glTF buffer view.

## Description

GLTFBufferView is a data structure representing a glTF bufferView that would be found in the "bufferViews" array. A buffer is a blob of binary data. A buffer view is a slice of a buffer that can be used to identify and extract data from the buffer.

Most custom uses of buffers only need to use the buffer, byte_length, and byte_offset. The byte_stride and indices properties are for more advanced use cases such as interleaved mesh data encoded for the GPU.

## Tutorials

- Buffers, BufferViews, and Accessors in Khronos glTF specification [https://github.com/KhronosGroup/glTF-Tutorials/blob/master/gltfTutorial/gltfTutorial_005_BuffersBufferViewsAccessors.md]
- Runtime file loading and saving

## Properties

int | buffer | -1
int | byte_length | 0
int | byte_offset | 0
int | byte_stride | -1
bool | indices | false
bool | vertex_attributes | false

## Methods

GLTFBufferView | from_dictionary(dictionary: Dictionary) static
PackedByteArray | load_buffer_view_data(state: GLTFState) const
Dictionary | to_dictionary() const

---

## Property Descriptions

int buffer = -1 

- void set_buffer(value: int)
- int get_buffer()

The index of the buffer this buffer view is referencing. If -1, this buffer view is not referencing any buffer.

---

int byte_length = 0 

- void set_byte_length(value: int)
- int get_byte_length()

The length, in bytes, of this buffer view. If 0, this buffer view is empty.

---

int byte_offset = 0 

- void set_byte_offset(value: int)
- int get_byte_offset()

The offset, in bytes, from the start of the buffer to the start of this buffer view.

---

int byte_stride = -1 

- void set_byte_stride(value: int)
- int get_byte_stride()

The stride, in bytes, between interleaved data. If -1, this buffer view is not interleaved.

---

bool indices = false 

- void set_indices(value: bool)
- bool get_indices()

true if the GLTFBufferView's OpenGL GPU buffer type is an ELEMENT_ARRAY_BUFFER used for vertex indices (integer constant 34963). false if the buffer type is any other value. See Buffers, BufferViews, and Accessors [https://github.com/KhronosGroup/glTF-Tutorials/blob/master/gltfTutorial/gltfTutorial_005_BuffersBufferViewsAccessors.md] for possible values. This property is set on import and used on export.

---

bool vertex_attributes = false 

- void set_vertex_attributes(value: bool)
- bool get_vertex_attributes()

true if the GLTFBufferView's OpenGL GPU buffer type is an ARRAY_BUFFER used for vertex attributes (integer constant 34962). false if the buffer type is any other value. See Buffers, BufferViews, and Accessors [https://github.com/KhronosGroup/glTF-Tutorials/blob/master/gltfTutorial/gltfTutorial_005_BuffersBufferViewsAccessors.md] for possible values. This property is set on import and used on export.

---

## Method Descriptions

GLTFBufferView from_dictionary(dictionary: Dictionary) static 

Creates a new GLTFBufferView instance by parsing the given Dictionary.

---

PackedByteArray load_buffer_view_data(state: GLTFState) const 

Loads the buffer view data from the buffer referenced by this buffer view in the given GLTFState. Interleaved data with a byte stride is not yet supported by this method. The data is returned as a PackedByteArray.

---

Dictionary to_dictionary() const 

Serializes this GLTFBufferView instance into a Dictionary.
