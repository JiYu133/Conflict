# RDAccelerationStructureInstance

Experimental: This class may be changed or removed in future versions.

Inherits: RefCounted < Object

Acceleration structure instance (used by RenderingDevice).

## Description

RDAccelerationStructureInstance describes an instance of a Bottom-Level Acceleration Structure (BLAS) used in the RenderingDevice.tlas_build() method.

## Properties

RID | blas | RID()
BitField[AccelerationStructureInstanceFlagBits] | flags | 0
int | hit_sbt_range | 0
int | id | 0
int | mask | 255
Transform3D | transform | Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)

---

## Property Descriptions

RID blas = RID() 

- void set_blas(value: RID)
- RID get_blas()

The BLAS referenced by this instance. If null, the instance is treated as a placeholder but still contributes to gl_InstanceIndex in GLSL.

---

BitField[AccelerationStructureInstanceFlagBits] flags = 0 

- void set_flags(value: BitField[AccelerationStructureInstanceFlagBits])
- BitField[AccelerationStructureInstanceFlagBits] get_flags()

Flags for the instance.

---

int hit_sbt_range = 0 

- void set_hit_sbt_range(value: int)
- int get_hit_sbt_range()

Hit shader binding table range used for this instance, allocated using the RenderingDevice.hit_sbt_range_alloc() method.

---

int id = 0 

- void set_id(value: int)
- int get_id()

Custom instance ID that can be accessed in GLSL using gl_InstanceCustomIndexEXT.

---

int mask = 255 

- void set_mask(value: int)
- int get_mask()

Visibility mask used to control which rays can intersect this instance.

---

Transform3D transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0) 

- void set_transform(value: Transform3D)
- Transform3D get_transform()

Transform applied to the referenced BLAS for this instance.
