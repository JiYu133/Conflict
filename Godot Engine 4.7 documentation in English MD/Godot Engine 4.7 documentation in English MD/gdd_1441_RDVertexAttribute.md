# RDVertexAttribute

Inherits: RefCounted < Object

Vertex attribute (used by RenderingDevice).

## Description

This object is used by RenderingDevice.

## Properties

int | binding | 4294967295
DataFormat | format | 232
VertexFrequency | frequency | 0
int | location | 0
int | offset | 0
int | stride | 0

---

## Property Descriptions

int binding = 4294967295 

- void set_binding(value: int)
- int get_binding()

The index of the buffer in the vertex buffer array to bind this vertex attribute. When set to -1, it defaults to the index of the attribute.

Note: You cannot mix binding explicitly assigned attributes with implicitly assigned ones (i.e. -1). Either all attributes must have their binding set to -1, or all must have explicit bindings.

---

DataFormat format = 232 

- void set_format(value: DataFormat)
- DataFormat get_format()

The way that this attribute's data is interpreted when sent to a shader.

---

VertexFrequency frequency = 0 

- void set_frequency(value: VertexFrequency)
- VertexFrequency get_frequency()

The rate at which this attribute is pulled from its vertex buffer.

---

int location = 0 

- void set_location(value: int)
- int get_location()

The location in the shader that this attribute is bound to.

---

int offset = 0 

- void set_offset(value: int)
- int get_offset()

The number of bytes between the start of the vertex buffer and the first instance of this attribute.

---

int stride = 0 

- void set_stride(value: int)
- int get_stride()

The number of bytes between the starts of consecutive instances of this attribute.
