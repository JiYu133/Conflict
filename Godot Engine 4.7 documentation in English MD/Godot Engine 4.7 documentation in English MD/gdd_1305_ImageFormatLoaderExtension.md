# ImageFormatLoaderExtension

Inherits: ImageFormatLoader < RefCounted < Object

Base class for creating ImageFormatLoader extensions (adding support for extra image formats).

## Description

The engine supports multiple image formats out of the box (PNG, SVG, JPEG, WebP to name a few), but you can choose to implement support for additional image formats by extending this class.

Be sure to respect the documented return types and values. You should create an instance of it, and call add_format_loader() to register that loader during the initialization phase.

## Methods

PackedStringArray | _get_recognized_extensions() virtual const
Error | _load_image(image: Image, fileaccess: FileAccess, flags: BitField[LoaderFlags], scale: float) virtual
void | add_format_loader()
void | remove_format_loader()

---

## Method Descriptions

PackedStringArray _get_recognized_extensions() virtual const 

Returns the list of file extensions for this image format. Files with the given extensions will be treated as image file and loaded using this class.

---

Error _load_image(image: Image, fileaccess: FileAccess, flags: BitField[LoaderFlags], scale: float) virtual 

Loads the content of fileaccess into the provided image.

---

void add_format_loader() 

Add this format loader to the engine, allowing it to recognize the file extensions returned by _get_recognized_extensions().

---

void remove_format_loader() 

Remove this format loader from the engine.
