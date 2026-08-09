# RDPipelineShader

Experimental: This class may be changed or removed in future versions.

Inherits: RefCounted < Object

Pipeline shader (used by RenderingDevice).

## Description

Wraps a shader resource and allows specialization constants to be applied at pipeline creation time.

Used by RenderingDevice.raytracing_pipeline_create() for ray generation, miss, and hit shaders. The pipeline selects the required shader stage automatically.

## Properties

RID | shader | RID()
Array[RDPipelineSpecializationConstant] | specialization_constants | []

---

## Property Descriptions

RID shader = RID() 

- void set_shader(value: RID)
- RID get_shader()

Shader resource. The required stage is selected by the pipeline.

---

Array[RDPipelineSpecializationConstant] specialization_constants = [] 

- void set_specialization_constants(value: Array[RDPipelineSpecializationConstant])
- Array[RDPipelineSpecializationConstant] get_specialization_constants()

Specialization constants applied to the selected shader stage at pipeline creation time.
