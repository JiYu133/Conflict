# RDAccelerationStructureGeometry

Experimental: This class may be changed or removed in future versions.

Inherits: RefCounted < Object

Acceleration structure geometry (used by RenderingDevice).

## Description

RDAccelerationStructureGeometry describes a set of triangles used as raytracing geometry in the RenderingDevice.blas_create() method.

The geometry is always in triangle list form, either indexed or non-indexed. Triangle strips are not supported.

## Properties

BitField[AccelerationStructureGeometryFlagBits] | flags | 0
RID | index_buffer | RID()
int | index_count | 0
int | index_offset | 0
RID | vertex_buffer | RID()
int | vertex_count | 0
DataFormat | vertex_format | 232
int | vertex_offset | 0
int | vertex_stride | 0

---

## Property Descriptions

BitField[AccelerationStructureGeometryFlagBits] flags = 0 

- void set_flags(value: BitField[AccelerationStructureGeometryFlagBits])
- BitField[AccelerationStructureGeometryFlagBits] get_flags()

Flags for the geometry.

---

RID index_buffer = RID() 

- void set_index_buffer(value: RID)
- RID get_index_buffer()

Buffer containing vertex indices. If null, triangles are non-indexed.

---

int index_count = 0 

- void set_index_count(value: int)
- int get_index_count()

Number of indices used by this geometry in index_buffer.

---

int index_offset = 0 

- void set_index_offset(value: int)
- int get_index_offset()

Byte offset of the first index in index_buffer.

---

RID vertex_buffer = RID() 

- void set_vertex_buffer(value: RID)
- RID get_vertex_buffer()

Buffer containing vertices.

---

int vertex_count = 0 

- void set_vertex_count(value: int)
- int get_vertex_count()

Number of vertices used by this geometry in vertex_buffer.

---

DataFormat vertex_format = 232 

- void set_vertex_format(value: DataFormat)
- DataFormat get_vertex_format()

Format of the vertices in vertex_buffer.

---

int vertex_offset = 0 

- void set_vertex_offset(value: int)
- int get_vertex_offset()

Byte offset of the first vertex in vertex_buffer.

---

int vertex_stride = 0 

- void set_vertex_stride(value: int)
- int get_vertex_stride()

Number of bytes between each vertex in vertex_buffer.
