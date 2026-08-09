# CameraFeed

Inherits: RefCounted < Object

A camera feed gives you access to a single physical camera attached to your device.

## Description

A camera feed gives you access to a single physical camera attached to your device. When enabled, Godot will start capturing frames from the camera which can then be used. See also CameraServer.

Note: Many cameras will return YCbCr images which are split into two textures and need to be combined in a shader. Godot does this automatically for you if you set the environment to show the camera image in the background.

Note: This class is currently only implemented on Linux, Android, macOS, and iOS. On other platforms no CameraFeeds will be available. To get a CameraFeed on iOS, enable EditorExportPlatformIOS.modules/camera.

## Properties

bool | feed_is_active | false
Transform2D | feed_transform | Transform2D(1, 0, 0, -1, 0, 1)
Array | formats | []

## Methods

bool | _activate_feed() virtual
void | _deactivate_feed() virtual
Array | _get_formats() virtual const
bool | _set_format(index: int, parameters: Dictionary) virtual
FeedDataType | get_datatype() const
int | get_id() const
String | get_name() const
FeedPosition | get_position() const
int | get_texture_tex_id(feed_image_type: FeedImage)
void | set_external(width: int, height: int)
bool | set_format(index: int, parameters: Dictionary)
void | set_name(name: String)
void | set_position(position: FeedPosition)
void | set_rgb_image(rgb_image: Image)
void | set_ycbcr_image(ycbcr_image: Image)
void | set_ycbcr_images(y_image: Image, cbcr_image: Image)

---

## Signals

format_changed() 

Emitted when the format has changed.

---

frame_changed() 

Emitted when a new frame is available.

---

## Enumerations

enum FeedDataType
FeedDataType FEED_NOIMAGE = 0

No image set for the feed.

FeedDataType FEED_RGB = 1

Feed supplies RGB images.

FeedDataType FEED_YCBCR = 2

Feed supplies YCbCr images that need to be converted to RGB.

FeedDataType FEED_YCBCR_SEP = 3

Feed supplies separate Y and CbCr images that need to be combined and converted to RGB.

FeedDataType FEED_EXTERNAL = 4

Feed supplies external image.

---

enum FeedPosition
FeedPosition FEED_UNSPECIFIED = 0

Unspecified position.

FeedPosition FEED_FRONT = 1

Camera is mounted at the front of the device.

FeedPosition FEED_BACK = 2

Camera is mounted at the back of the device.

---

## Property Descriptions

bool feed_is_active = false 

- void set_active(value: bool)
- bool is_active()

If true, the feed is active.

---

Transform2D feed_transform = Transform2D(1, 0, 0, -1, 0, 1) 

- void set_transform(value: Transform2D)
- Transform2D get_transform()

The transform applied to the camera's image.

---

Array formats = [] 

- Array get_formats()

Formats supported by the feed. Each entry is a Dictionary describing format parameters.

---

## Method Descriptions

bool _activate_feed() virtual 

Called when the camera feed is activated.

---

void _deactivate_feed() virtual 

Called when the camera feed is deactivated.

---

Array _get_formats() virtual const 

Override this method to define supported formats of the camera feed.

---

bool _set_format(index: int, parameters: Dictionary) virtual 

Override this method to set the format of the camera feed.

---

FeedDataType get_datatype() const 

Returns feed image data type.

---

int get_id() const 

Returns the unique ID for this feed.

---

String get_name() const 

Returns the camera's name.

---

FeedPosition get_position() const 

Returns the position of camera on the device.

---

int get_texture_tex_id(feed_image_type: FeedImage) 

Returns the texture backend ID (usable by some external libraries that need a handle to a texture to write data).

---

void set_external(width: int, height: int) 

Sets the feed as external feed provided by another library.

---

bool set_format(index: int, parameters: Dictionary) 

Sets the feed format parameters for the given index in the formats array. Returns true on success. By default, the YUYV encoded stream is transformed to FEED_RGB. The YUYV encoded stream output format can be changed by setting parameters's output entry to one of the following:

- "separate" will result in FEED_YCBCR_SEP;
- "grayscale" will result in desaturated FEED_RGB;
- "copy" will result in FEED_YCBCR.

---

void set_name(name: String) 

Sets the camera's name.

---

void set_position(position: FeedPosition) 

Sets the position of this camera.

---

void set_rgb_image(rgb_image: Image) 

Sets RGB image for this feed.

---

void set_ycbcr_image(ycbcr_image: Image) 

Sets YCbCr image for this feed.

---

void set_ycbcr_images(y_image: Image, cbcr_image: Image) 

Sets Y and CbCr images for this feed.
