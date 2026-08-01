# GLTFSpecGloss

Inherits: Resource < RefCounted < Object

Archived glTF extension for specular/glossy materials.

## Description

KHR_materials_pbrSpecularGlossiness is an archived glTF extension. This means that it is deprecated and not recommended for new files. However, it is still supported for loading old files.

## Tutorials

- Runtime file loading and saving
- KHR_materials_pbrSpecularGlossiness glTF extension spec [https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Archived/KHR_materials_pbrSpecularGlossiness]

## Properties

Color | diffuse_factor | Color(1, 1, 1, 1)
Image | diffuse_img |
float | gloss_factor | 1.0
Image | spec_gloss_img |
Color | specular_factor | Color(1, 1, 1, 1)

---

## Property Descriptions

Color diffuse_factor = Color(1, 1, 1, 1) 

- void set_diffuse_factor(value: Color)
- Color get_diffuse_factor()

The reflected diffuse factor of the material.

---

Image diffuse_img 

- void set_diffuse_img(value: Image)
- Image get_diffuse_img()

The diffuse texture.

---

float gloss_factor = 1.0 

- void set_gloss_factor(value: float)
- float get_gloss_factor()

The glossiness or smoothness of the material.

---

Image spec_gloss_img 

- void set_spec_gloss_img(value: Image)
- Image get_spec_gloss_img()

The specular-glossiness texture.

---

Color specular_factor = Color(1, 1, 1, 1) 

- void set_specular_factor(value: Color)
- Color get_specular_factor()

The specular RGB color of the material. The alpha channel is unused.
