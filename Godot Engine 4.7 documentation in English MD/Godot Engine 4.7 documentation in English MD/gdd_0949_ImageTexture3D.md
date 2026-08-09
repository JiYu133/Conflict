# ImageTexture3D

Inherits: Texture3D < Texture < Resource < RefCounted < Object

Texture with 3 dimensions.

## Description

ImageTexture3D is a 3-dimensional ImageTexture that has a width, height, and depth. See also ImageTextureLayered.

3D textures are typically used to store density maps for FogMaterial, color correction LUTs for Environment, vector fields for GPUParticlesAttractorVectorField3D and collision maps for GPUParticlesCollisionSDF3D. 3D textures can also be used in custom shaders.

## Methods

Error | create(format: Format, width: int, height: int, depth: int, use_mipmaps: bool, data: Array[Image])
void | update(data: Array[Image])

---

## Method Descriptions

Error create(format: Format, width: int, height: int, depth: int, use_mipmaps: bool, data: Array[Image]) 

Creates the ImageTexture3D with specified format, width, height, and depth. If use_mipmaps is true, generates mipmaps for the ImageTexture3D.

---

void update(data: Array[Image]) 

Replaces the texture's existing data with the layers specified in data. The size of data must match the parameters that were used for create(). In other words, the texture cannot be resized or have its format changed by calling update().
