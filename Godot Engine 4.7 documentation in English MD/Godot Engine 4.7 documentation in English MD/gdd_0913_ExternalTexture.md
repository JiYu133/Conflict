# ExternalTexture

Inherits: Texture2D < Texture < Resource < RefCounted < Object

Texture which displays the content of an external buffer.

## Description

Displays the content of an external buffer provided by the platform.

Requires the OES_EGL_image_external [https://registry.khronos.org/OpenGL/extensions/OES/OES_EGL_image_external.txt] extension (OpenGL) or VK_ANDROID_external_memory_android_hardware_buffer [https://registry.khronos.org/vulkan/specs/1.1-extensions/html/vkspec.html#VK_ANDROID_external_memory_android_hardware_buffer] extension (Vulkan).

Note: This is currently only supported in Android builds.

## Properties

bool | resource_local_to_scene | false (overrides Resource)
Vector2 | size | Vector2(256, 256)

## Methods

int | get_external_texture_id() const
void | set_external_buffer_id(external_buffer_id: int)

---

## Property Descriptions

Vector2 size = Vector2(256, 256) 

- void set_size(value: Vector2)
- Vector2 get_size()

External texture size.

---

## Method Descriptions

int get_external_texture_id() const 

Returns the external texture ID.

Depending on your use case, you may need to pass this to platform APIs, for example, when creating an android.graphics.SurfaceTexture on Android.

---

void set_external_buffer_id(external_buffer_id: int) 

Sets the external buffer ID.

Depending on your use case, you may need to call this with data received from a platform API, for example, SurfaceTexture.getHardwareBuffer() on Android.
