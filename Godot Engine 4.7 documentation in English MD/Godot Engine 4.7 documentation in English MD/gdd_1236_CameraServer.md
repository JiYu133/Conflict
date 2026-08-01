# CameraServer

Inherits: Object

Server keeping track of different cameras accessible in Godot.

## Description

The CameraServer keeps track of different cameras accessible in Godot. These are external cameras such as webcams or the cameras on your phone.

It is notably used to provide AR modules with a video feed from the camera.

Note: This class is currently only implemented on Linux, Android, macOS, and iOS. On other platforms no CameraFeeds will be available. To get a CameraFeed on iOS, enable EditorExportPlatformIOS.modules/camera.

## Properties

bool | monitoring_feeds | false

## Methods

void | add_feed(feed: CameraFeed)
Array[CameraFeed] | feeds()
CameraFeed | get_feed(index: int)
int | get_feed_count()
void | remove_feed(feed: CameraFeed)

---

## Signals

camera_feed_added(id: int) 

Emitted when a CameraFeed is added (e.g. a webcam is plugged in).

---

camera_feed_removed(id: int) 

Emitted when a CameraFeed is removed (e.g. a webcam is unplugged).

---

camera_feeds_updated() 

Emitted when camera feeds are updated.

---

## Enumerations

enum FeedImage
FeedImage FEED_RGBA_IMAGE = 0

The RGBA camera image.

FeedImage FEED_YCBCR_IMAGE = 0

The YCbCr [https://en.wikipedia.org/wiki/YCbCr] camera image.

FeedImage FEED_Y_IMAGE = 0

The Y component camera image.

FeedImage FEED_CBCR_IMAGE = 1

The CbCr component camera image.

---

## Property Descriptions

bool monitoring_feeds = false 

- void set_monitoring_feeds(value: bool)
- bool is_monitoring_feeds()

If true, the server is actively monitoring available camera feeds.

This has a performance cost, so only set it to true when you're actively accessing the camera.

Note: After setting it to true, you can receive updated camera feeds through the camera_feeds_updated signal.

```
func _ready():
    CameraServer.camera_feeds_updated.connect(_on_camera_feeds_updated)
    CameraServer.monitoring_feeds = true
func _on_camera_feeds_updated():
    var feeds = CameraServer.feeds()
```

```
public override void _Ready()
{
    CameraServer.CameraFeedsUpdated += OnCameraFeedsUpdated;
    CameraServer.MonitoringFeeds = true;
}
void OnCameraFeedsUpdated()
{
    var feeds = CameraServer.Feeds();
}
```

---

## Method Descriptions

void add_feed(feed: CameraFeed) 

Adds the camera feed to the camera server.

---

Array[CameraFeed] feeds() 

Returns an array of CameraFeeds.

---

CameraFeed get_feed(index: int) 

Returns the CameraFeed corresponding to the camera with the given index.

---

int get_feed_count() 

Returns the number of CameraFeeds registered.

---

void remove_feed(feed: CameraFeed) 

Removes the specified camera feed.
