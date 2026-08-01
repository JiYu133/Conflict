# RenderSceneBuffersExtension

Inherits: RenderSceneBuffers < RefCounted < Object

This class allows for a RenderSceneBuffer implementation to be made in GDExtension.

## Description

This class allows for a RenderSceneBuffer implementation to be made in GDExtension.

## Methods

void | _configure(config: RenderSceneBuffersConfiguration) virtual
void | _set_anisotropic_filtering_level(anisotropic_filtering_level: int) virtual
void | _set_fsr_sharpness(fsr_sharpness: float) virtual
void | _set_texture_mipmap_bias(texture_mipmap_bias: float) virtual
void | _set_use_debanding(use_debanding: bool) virtual

---

## Method Descriptions

void _configure(config: RenderSceneBuffersConfiguration) virtual 

Implement this in GDExtension to handle the (re)sizing of a viewport.

---

void _set_anisotropic_filtering_level(anisotropic_filtering_level: int) virtual 

Implement this in GDExtension to change the anisotropic filtering level.

---

void _set_fsr_sharpness(fsr_sharpness: float) virtual 

Implement this in GDExtension to record a new FSR sharpness value.

---

void _set_texture_mipmap_bias(texture_mipmap_bias: float) virtual 

Implement this in GDExtension to change the texture mipmap bias.

---

void _set_use_debanding(use_debanding: bool) virtual 

Implement this in GDExtension to react to the debanding flag changing.
