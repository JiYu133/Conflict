# LightOccluder2D

Inherits: Node2D < CanvasItem < Node < Object

Occludes light cast by a Light2D, casting shadows.

## Description

Occludes light cast by a Light2D, casting shadows. The LightOccluder2D must be provided with an OccluderPolygon2D in order for the shadow to be computed.

## Tutorials

- 2D lights and shadows

## Properties

OccluderPolygon2D | occluder |
int | occluder_light_mask | 1
bool | sdf_collision | true

---

## Property Descriptions

OccluderPolygon2D occluder 

- void set_occluder_polygon(value: OccluderPolygon2D)
- OccluderPolygon2D get_occluder_polygon()

The OccluderPolygon2D used to compute the shadow.

---

int occluder_light_mask = 1 

- void set_occluder_light_mask(value: int)
- int get_occluder_light_mask()

The LightOccluder2D's occluder light mask. The LightOccluder2D will cast shadows only from Light2D(s) that have the same light mask(s).

---

bool sdf_collision = true 

- void set_as_sdf_collision(value: bool)
- bool is_set_as_sdf_collision()

If enabled, the occluder will be part of a real-time generated signed distance field that can be used in custom shaders.
