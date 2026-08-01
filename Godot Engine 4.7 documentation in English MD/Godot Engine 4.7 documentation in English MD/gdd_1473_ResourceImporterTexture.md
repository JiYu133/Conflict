# ResourceImporterTexture

Inherits: ResourceImporter < RefCounted < Object

Imports an image for use in 2D or 3D rendering.

## Description

This importer imports CompressedTexture2D resources. If you need to process the image in scripts in a more convenient way, use ResourceImporterImage instead. See also ResourceImporterLayeredTexture.

## Tutorials

- Importing images

## Properties

int | compress/channel_pack | 0
int | compress/hdr_compression | 1
bool | compress/high_quality | false
float | compress/lossy_quality | 0.7
int | compress/mode | 0
int | compress/normal_map | 0
float | compress/rdo_quality_loss | 0.0
int | compress/uastc_level | 0
int | detect_3d/compress_to | 1
bool | editor/convert_colors_with_editor_theme | false
bool | editor/scale_with_editor_scale | false
bool | mipmaps/generate | false
int | mipmaps/limit | -1
int | process/channel_remap/alpha | 3
int | process/channel_remap/blue | 2
int | process/channel_remap/green | 1
int | process/channel_remap/red | 0
bool | process/fix_alpha_border | true
bool | process/hdr_as_srgb | false
bool | process/hdr_clamp_exposure | false
bool | process/normal_map_invert_y | false
bool | process/premult_alpha | false
int | process/size_limit | 0
int | roughness/mode | 0
String | roughness/src_normal | ""
float | svg/scale | 1.0

---

## Property Descriptions

int compress/channel_pack = 0 

Controls how color channels should be used in the imported texture.

sRGB Friendly: Prevents the R and RG color formats from being used, as they do not support nonlinear sRGB encoding.

Optimized: Allows the RG color format to be used if the texture does not use the blue channel. This reduces memory usage if the texture's blue channel can be discarded (all pixels must have a blue value of 0).

---

int compress/hdr_compression = 1 

Controls how VRAM compression should be performed for HDR images.

Disabled: Never use VRAM compression for HDR textures, regardless of whether they're opaque or transparent. Instead, the texture is converted to RGBE9995 (9-bits per channel + 5-bit exponent = 32 bits per pixel) to reduce memory usage compared to a half-float or single-precision float image format.

Opaque Only: Only uses VRAM compression for opaque HDR textures. This is due to a limitation of HDR formats, as there is no VRAM-compressed HDR format that supports transparency at the same time.

Always: Force VRAM compression even for HDR textures with an alpha channel. To perform this, the alpha channel is discarded on import.

Note: Only effective on Radiance HDR (.hdr) and OpenEXR (.exr) images.

---

bool compress/high_quality = false 

If true, uses BPTC compression on desktop platforms and ASTC compression on mobile platforms. When using BPTC, BC7 is used for SDR textures and BC6H is used for HDR textures.

If false, uses the faster but lower-quality S3TC compression on desktop platforms and ETC2 on mobile/web platforms. When using S3TC, DXT1 (BC1) is used for opaque textures and DXT5 (BC3) is used for transparent or normal map (RGTC) textures.

BPTC and ASTC support VRAM compression for HDR textures, but S3TC and ETC2 do not (see compress/hdr_compression).

---

float compress/lossy_quality = 0.7 

The quality to use when using the Lossy compression mode. Higher values result in better quality, at the cost of larger file sizes. Lossy quality does not affect memory usage of the imported texture, only its file size on disk.

---

int compress/mode = 0 

The compression mode to use. Each compression mode provides a different tradeoff:

Lossless: Original quality, high memory usage, high size on disk, fast import.

Lossy: Reduced quality, high memory usage, low size on disk, fast import.

VRAM Compressed: Reduced quality, low memory usage, low size on disk, slowest import. Only use for textures in 3D scenes, not for 2D elements.

VRAM Uncompressed: Original quality, high memory usage, highest size on disk, fastest import.

Basis Universal: Reduced quality, low memory usage, lowest size on disk, slow import. Only use for textures in 3D scenes, not for 2D elements.

See Compress mode in the manual for more details.

---

int compress/normal_map = 0 

When using a texture as normal map, only the red and green channels are required. Given regular texture compression algorithms produce artifacts that don't look that nice in normal maps, the RGTC compression format is the best fit for this data. Forcing this option to Enable will make Godot import the image as RGTC compressed. By default, it's set to Detect. This means that if the texture is ever detected to be used as a normal map, it will be changed to Enable and reimported automatically.

Note that RGTC compression affects the resulting normal map image. You will have to adjust custom shaders that use the normal map's blue channel to take this into account. Built-in material shaders already ignore the blue channel in a normal map (regardless of the actual normal map's contents).

---

float compress/rdo_quality_loss = 0.0 

If greater than or equal to 0.01, enables Rate-Distortion Optimization (RDO) to reduce file size. Higher values result in smaller file sizes but lower quality.

Note: Enabling RDO makes encoding times significantly longer, especially when the image is large.

See also ProjectSettings.rendering/textures/basis_universal/rdo_dict_size and ProjectSettings.rendering/textures/basis_universal/zstd_supercompression_level if you want to reduce the file size further.

---

int compress/uastc_level = 0 

The UASTC encoding level. Higher values result in better quality but make encoding times longer.

---

int detect_3d/compress_to = 1 

This changes the compress/mode option that is used when a texture is detected as being used in 3D.

Changing this import option only has an effect if a texture is detected as being used in 3D. Changing this to Disabled then reimporting will not change the existing compress mode on a texture (if it's detected to be used in 3D), but choosing VRAM Compressed or Basis Universal will.

---

bool editor/convert_colors_with_editor_theme = false 

If true, converts the imported image's colors to match EditorSettings.interface/theme/icon_and_font_color. This assumes the image uses the exact same colors as Godot's own color palette for editor icons, with the source file designed for a dark editor theme. This should be enabled for editor plugin icons and custom class icons, but should be left disabled otherwise.

Note: Only available for SVG images.

---

bool editor/scale_with_editor_scale = false 

If true, scales the imported image to match EditorSettings.interface/editor/appearance/custom_display_scale. This should be enabled for editor plugin icons and custom class icons, but should be left disabled otherwise.

Note: Only available for SVG images.

---

bool mipmaps/generate = false 

If true, smaller versions of the texture are generated on import. For example, a 64×64 texture will generate 6 mipmaps (32×32, 16×16, 8×8, 4×4, 2×2, 1×1). This has several benefits:

- Textures will not become grainy in the distance (in 3D), or if scaled down due to Camera2D zoom or CanvasItem scale (in 2D).
- Performance will improve if the texture is displayed in the distance, since sampling smaller versions of the original texture is faster and requires less memory bandwidth.

The downside of mipmaps is that they increase memory usage by roughly 33%.

It's recommended to enable mipmaps in 3D. However, in 2D, this should only be enabled if your project visibly benefits from having mipmaps enabled. If the camera never zooms out significantly, there won't be a benefit to enabling mipmaps but memory usage will increase.

---

int mipmaps/limit = -1 

Unimplemented. This currently has no effect when changed.

---

int process/channel_remap/alpha = 3 

Specifies the data source of the output image's alpha channel.

Red: Use the values from the source image's red channel.

Green: Use the values from the source image's green channel.

Blue: Use the values from the source image's blue channel.

Alpha: Use the values from the source image's alpha channel.

Red Inverted: Use inverted values from the source image's red channel (1.0 - R).

Green Inverted: Use inverted values from the source image's green channel (1.0 - G).

Blue Inverted: Use inverted values from the source image's blue channel (1.0 - B).

Alpha Inverted: Use inverted values from the source image's alpha channel (1.0 - A).

Unused: Set the color channel's value to the default (1.0 for alpha, 0.0 for red, green or blue).

Zero: Set the color channel's value to 0.0.

One: Set the color channel's value to 1.0.

---

int process/channel_remap/blue = 2 

Specifies the data source of the output image's blue channel.

Red: Use the values from the source image's red channel.

Green: Use the values from the source image's green channel.

Blue: Use the values from the source image's blue channel.

Alpha: Use the values from the source image's alpha channel.

Red Inverted: Use inverted values from the source image's red channel (1.0 - R).

Green Inverted: Use inverted values from the source image's green channel (1.0 - G).

Blue Inverted: Use inverted values from the source image's blue channel (1.0 - B).

Alpha Inverted: Use inverted values from the source image's alpha channel (1.0 - A).

Unused: Set the color channel's value to the default (1.0 for alpha, 0.0 for red, green or blue).

Zero: Set the color channel's value to 0.0.

One: Set the color channel's value to 1.0.

---

int process/channel_remap/green = 1 

Specifies the data source of the output image's green channel.

Red: Use the values from the source image's red channel.

Green: Use the values from the source image's green channel.

Blue: Use the values from the source image's blue channel.

Alpha: Use the values from the source image's alpha channel.

Red Inverted: Use inverted values from the source image's red channel (1.0 - R).

Green Inverted: Use inverted values from the source image's green channel (1.0 - G).

Blue Inverted: Use inverted values from the source image's blue channel (1.0 - B).

Alpha Inverted: Use inverted values from the source image's alpha channel (1.0 - A).

Unused: Set the color channel's value to the default (1.0 for alpha, 0.0 for red, green or blue).

Zero: Set the color channel's value to 0.0.

One: Set the color channel's value to 1.0.

---

int process/channel_remap/red = 0 

Specifies the data source of the output image's red channel.

Red: Use the values from the source image's red channel.

Green: Use the values from the source image's green channel.

Blue: Use the values from the source image's blue channel.

Alpha: Use the values from the source image's alpha channel.

Red Inverted: Use inverted values from the source image's red channel (1.0 - R).

Green Inverted: Use inverted values from the source image's green channel (1.0 - G).

Blue Inverted: Use inverted values from the source image's blue channel (1.0 - B).

Alpha Inverted: Use inverted values from the source image's alpha channel (1.0 - A).

Unused: Set the color channel's value to the default (1.0 for alpha, 0.0 for red, green or blue).

Zero: Set the color channel's value to 0.0.

One: Set the color channel's value to 1.0.

---

bool process/fix_alpha_border = true 

If true, puts pixels of the same surrounding color in transition from transparent to opaque areas. For textures displayed with bilinear filtering, this helps to reduce the outline effect when exporting images from an image editor.

It's recommended to leave this enabled (as it is by default), unless this causes issues for a particular image.

---

bool process/hdr_as_srgb = false 

Some HDR images you can find online may be broken and contain data that is encoded using the nonlinear sRGB transfer function (instead of using linear encoding). It is advised not to use those files. If you absolutely have to, enabling process/hdr_as_srgb will make them look correct.

Warning: Enabling process/hdr_as_srgb on well-formatted HDR images will cause the resulting image to look too dark, so leave this on false if unsure.

---

bool process/hdr_clamp_exposure = false 

If true, clamps exposure in the imported high dynamic range images using a smart clamping formula (without introducing visible clipping).

Some HDR panorama images you can find online may contain extremely bright pixels, due to being taken from real life sources without any clipping.

While these HDR panorama images are accurate to real life, this can cause the radiance map generated by Godot to contain sparkles when used as a background sky. This can be seen in material reflections (even on rough materials in extreme cases). Enabling process/hdr_clamp_exposure can resolve this.

---

bool process/normal_map_invert_y = false 

Deprecated: The same result can be achieved by setting process/channel_remap/green to Green Inverted.

If true, convert the normal map from Y- (DirectX-style) to Y+ (OpenGL-style) by inverting its green color channel. This is the normal map convention expected by Godot.

More information about normal maps (including a coordinate order table for popular engines) can be found here [http://wiki.polycount.com/wiki/Normal_Map_Technical_Details].

---

bool process/premult_alpha = false 

An alternative to fixing darkened borders with process/fix_alpha_border is to use premultiplied alpha. By enabling this option, the texture will be converted to this format. A premultiplied alpha texture requires specific materials to be displayed correctly:

- In 2D, a CanvasItemMaterial will need to be created and configured to use the CanvasItemMaterial.BLEND_MODE_PREMULT_ALPHA blend mode on CanvasItems that use this texture. In custom canvas_item shaders, render_mode blend_premul_alpha; should be used.
- In 3D, a BaseMaterial3D will need to be created and configured to use the BaseMaterial3D.BLEND_MODE_PREMULT_ALPHA blend mode on materials that use this texture. In custom spatial shaders, render_mode blend_premul_alpha; should be used.

---

int process/size_limit = 0 

If set to a value greater than 0, the size of the texture is limited on import to a value smaller than or equal to the value specified here. For non-square textures, the size limit affects the longer dimension, with the shorter dimension scaled to preserve aspect ratio. Resizing is performed using cubic interpolation.

This can be used to reduce memory usage without affecting the source images, or avoid issues with textures not displaying on mobile/web platforms (as these usually can't display textures larger than 4096×4096).

Note: Even if this is set to 0, import size is limited to the following dimensions for technical reasons. Depending on compress/mode, textures will be downsampled on import if necessary:

- Lossy: 16383 pixels width or height, whichever is larger;
- Basis Universal: 16384 pixels width or height, whichever is larger;
- All other modes: 32768 pixels width or height, whichever is larger.

---

int roughness/mode = 0 

The color channel to consider as a roughness map in this texture. Only effective if roughness/src_normal is not empty.

---

String roughness/src_normal = "" 

The path to the texture to consider as a normal map for roughness filtering on import. Specifying this can help decrease specular aliasing slightly in 3D.

Roughness filtering on import is only used in 3D rendering, not 2D.

---

float svg/scale = 1.0 

The scale the SVG should be rendered at, with 1.0 being the original design size. Higher values result in a larger image. Note that unlike font oversampling, this affects the size the SVG is rendered at in 2D. See also editor/scale_with_editor_scale.

Note: Only available for SVG images.
