# RDHitGroup

Experimental: This class may be changed or removed in future versions.

Inherits: RefCounted < Object

Hit group (used by RenderingDevice).

## Description

Defines a hit group for use with RenderingDevice.raytracing_pipeline_create().

A hit group combines shaders that are executed when a ray intersects geometry. It may include a closest-hit shader, any-hit shader, and intersection shader.

Hit groups are referenced by index when populating hit shader binding tables using RenderingDevice.hit_sbt_range_update().

## Properties

RDPipelineShader | any_hit_shader
RDPipelineShader | closest_hit_shader
RDPipelineShader | intersection_shader

---

## Property Descriptions

RDPipelineShader any_hit_shader 

- void set_any_hit_shader(value: RDPipelineShader)
- RDPipelineShader get_any_hit_shader()

Any-hit shader for this hit group. Executed for each potential intersection. Can be null.

---

RDPipelineShader closest_hit_shader 

- void set_closest_hit_shader(value: RDPipelineShader)
- RDPipelineShader get_closest_hit_shader()

Closest-hit shader for this hit group. Executed for the closest intersection. Can be null.

---

RDPipelineShader intersection_shader 

- void set_intersection_shader(value: RDPipelineShader)
- RDPipelineShader get_intersection_shader()

Intersection shader for this hit group. Required for non-triangle geometry. Must be null when using for triangle geometry.
