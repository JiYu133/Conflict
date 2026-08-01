# CameraTexture

Inherits: Texture2D < Texture < Resource < RefCounted < Object

Texture provided by a CameraFeed.

## Description

This texture gives access to the camera texture provided by a CameraFeed.

Note: Many cameras supply YCbCr images which need to be converted in a shader.

## Properties

int | camera_feed_id | 0
bool | camera_is_active | false
bool | resource_local_to_scene | false (overrides Resource)
FeedImage | which_feed | 0

---

## Property Descriptions

int camera_feed_id = 0 

- void set_camera_feed_id(value: int)
- int get_camera_feed_id()

The ID of the CameraFeed for which we want to display the image.

---

bool camera_is_active = false 

- void set_camera_active(value: bool)
- bool get_camera_active()

Convenience property that gives access to the active property of the CameraFeed.

---

FeedImage which_feed = 0 

- void set_which_feed(value: FeedImage)
- FeedImage get_which_feed()

Which image within the CameraFeed we want access to, important if the camera image is split in a Y and CbCr component.
