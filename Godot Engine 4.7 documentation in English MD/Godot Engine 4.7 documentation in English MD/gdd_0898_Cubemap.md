# Cubemap

Inherits: ImageTextureLayered < TextureLayered < Texture < Resource < RefCounted < Object

Six square textures representing the faces of a cube. Commonly used as a skybox.

## Description

A cubemap is made of 6 textures organized in layers. They are typically used for faking reflections in 3D rendering (see ReflectionProbe). It can be used to make an object look as if it's reflecting its surroundings. This usually delivers much better performance than other reflection methods.

This resource is typically used as a uniform in custom shaders. Few core Godot methods make use of Cubemap resources.

To create such a texture file yourself, reimport your image files using the Godot Editor import presets. To create a Cubemap from code, use ImageTextureLayered.create_from_images() on an instance of the Cubemap class.

The expected image order is X+, X-, Y+, Y-, Z+, Z- (in Godot's coordinate system, so Y+ is "up" and Z- is "forward"). You can use one of the following templates as a base:

- 2×3 cubemap template (default layout option) [https://raw.githubusercontent.com/godotengine/godot-docs/master/tutorials/assets_pipeline/img/cubemap_template_2x3.webp]
- 3×2 cubemap template [https://raw.githubusercontent.com/godotengine/godot-docs/master/tutorials/assets_pipeline/img/cubemap_template_3x2.webp]
- 1×6 cubemap template [https://raw.githubusercontent.com/godotengine/godot-docs/master/tutorials/assets_pipeline/img/cubemap_template_1x6.webp]
- 6×1 cubemap template [https://raw.githubusercontent.com/godotengine/godot-docs/master/tutorials/assets_pipeline/img/cubemap_template_6x1.webp]

Note: Godot doesn't support using cubemaps in a PanoramaSkyMaterial. To use a cubemap as a skybox, convert the default PanoramaSkyMaterial to a ShaderMaterial using the Convert to ShaderMaterial resource dropdown option, then replace its code with the following:

```
shader_type sky;
uniform samplerCube source_panorama : filter_linear, source_color, hint_default_black;
uniform float exposure : hint_range(0, 128) = 1.0;
void sky() {
    // If importing a cubemap from another engine, you may need to flip one of the `EYEDIR` components below
    // by replacing it with `-EYEDIR`.
    vec3 eyedir = vec3(EYEDIR.x, EYEDIR.y, EYEDIR.z);
    COLOR = texture(source_panorama, eyedir).rgb * exposure;
}
```

After replacing the shader code and saving, specify the imported Cubemap resource in the Shader Parameters section of the ShaderMaterial in the inspector.

Alternatively, you can use this tool [https://danilw.github.io/GLSL-howto/cubemap_to_panorama_js/cubemap_to_panorama.html] to convert a cubemap to an equirectangular sky map and use PanoramaSkyMaterial as usual.

## Methods

Resource | create_placeholder() const

---

## Method Descriptions

Resource create_placeholder() const 

Creates a placeholder version of this resource (PlaceholderCubemap).
