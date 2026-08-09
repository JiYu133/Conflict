# ImageFormatLoader

Inherits: RefCounted < Object

Inherited By: ImageFormatLoaderExtension

Base class to add support for specific image formats.

## Description

The engine supports multiple image formats out of the box (PNG, SVG, JPEG, WebP to name a few), but you can choose to implement support for additional image formats by extending ImageFormatLoaderExtension.

---

## Enumerations

flags LoaderFlags: 

LoaderFlags FLAG_NONE = 0

Default loading behavior. No processing is applied to the image.

LoaderFlags FLAG_FORCE_LINEAR = 1

If set, the image is converted from sRGB to linear encoding.

LoaderFlags FLAG_CONVERT_COLORS = 2

If set, a predefined color map is applied to the image. Used when ResourceImporterTexture.editor/convert_colors_with_editor_theme is true.
