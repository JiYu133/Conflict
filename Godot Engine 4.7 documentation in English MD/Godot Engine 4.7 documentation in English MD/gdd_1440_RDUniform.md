# RDUniform

Inherits: RefCounted < Object

Shader uniform (used by RenderingDevice).

## Description

This object is used by RenderingDevice.

## Properties

int | binding | 0
UniformType | uniform_type | 3

## Methods

void | add_id(id: RID)
void | clear_ids()
Array[RID] | get_ids() const

---

## Property Descriptions

int binding = 0 

- void set_binding(value: int)
- int get_binding()

The uniform's binding.

---

UniformType uniform_type = 3 

- void set_uniform_type(value: UniformType)
- UniformType get_uniform_type()

The uniform's data type.

---

## Method Descriptions

void add_id(id: RID) 

Binds the given id to the uniform. The data associated with the id is then used when the uniform is passed to a shader.

---

void clear_ids() 

Unbinds all ids currently bound to the uniform.

---

Array[RID] get_ids() const 

Returns an array of all ids currently bound to the uniform.
