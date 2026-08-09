# XRInterfaceExtension

Inherits: XRInterface < RefCounted < Object

Base class for XR interface extensions (plugins).

## Description

External XR interface plugins should inherit from this class.

## Tutorials

- XR documentation index

## Methods

void | _end_frame() virtual
bool | _get_anchor_detection_is_enabled() virtual const
int | _get_camera_feed_id() virtual const
Transform3D | _get_camera_transform() virtual
int | _get_capabilities() virtual const
RID | _get_color_texture() virtual
RID | _get_depth_texture() virtual
StringName | _get_name() virtual const
PackedVector3Array | _get_play_area() virtual const
PlayAreaMode | _get_play_area_mode() virtual const
PackedFloat64Array | _get_projection_for_view(view: int, aspect: float, z_near: float, z_far: float) virtual
Vector2 | _get_render_target_size() virtual
PackedStringArray | _get_suggested_pose_names(tracker_name: StringName) virtual const
PackedStringArray | _get_suggested_tracker_names() virtual const
Dictionary | _get_system_info() virtual const
TrackingStatus | _get_tracking_status() virtual const
Transform3D | _get_transform_for_view(view: int, cam_transform: Transform3D) virtual
RID | _get_velocity_texture() virtual
int | _get_view_count() virtual
RID | _get_vrs_texture() virtual
VRSTextureFormat | _get_vrs_texture_format() virtual
bool | _initialize() virtual
bool | _is_initialized() virtual const
void | _post_draw_viewport(render_target: RID, screen_rect: Rect2) virtual
bool | _pre_draw_viewport(render_target: RID) virtual
void | _pre_render() virtual
void | _process() virtual
void | _set_anchor_detection_is_enabled(enabled: bool) virtual
bool | _set_play_area_mode(mode: PlayAreaMode) virtual const
bool | _supports_play_area_mode(mode: PlayAreaMode) virtual const
void | _trigger_haptic_pulse(action_name: String, tracker_name: StringName, frequency: float, amplitude: float, duration_sec: float, delay_sec: float) virtual
void | _uninitialize() virtual
void | add_blit(render_target: RID, src_rect: Rect2, dst_rect: Rect2i, use_layer: bool, layer: int, apply_lens_distortion: bool, eye_center: Vector2, k1: float, k2: float, upscale: float, aspect_ratio: float)
RID | get_color_texture()
RID | get_depth_texture()
RID | get_render_target_texture(render_target: RID)
RID | get_velocity_texture()

---

## Method Descriptions

void _end_frame() virtual 

Called if interface is active and queues have been submitted.

---

bool _get_anchor_detection_is_enabled() virtual const 

Return true if anchor detection is enabled for this interface.

---

int _get_camera_feed_id() virtual const 

Returns the camera feed ID for the CameraFeed registered with the CameraServer that should be presented as the background on an AR capable device (if applicable).

---

Transform3D _get_camera_transform() virtual 

Returns the Transform3D that positions the XRCamera3D in the world.

---

int _get_capabilities() virtual const 

Returns the capabilities of this interface.

---

RID _get_color_texture() virtual 

Return color texture into which to render (if applicable).

---

RID _get_depth_texture() virtual 

Return depth texture into which to render (if applicable).

---

StringName _get_name() virtual const 

Returns the name of this interface.

---

PackedVector3Array _get_play_area() virtual const 

Returns a PackedVector3Array that represents the play areas boundaries (if applicable).

---

PlayAreaMode _get_play_area_mode() virtual const 

Returns the play area mode that sets up our play area.

---

PackedFloat64Array _get_projection_for_view(view: int, aspect: float, z_near: float, z_far: float) virtual 

Returns the projection matrix for the given view as a PackedFloat64Array.

---

Vector2 _get_render_target_size() virtual 

Returns the size of our render target for this interface, this overrides the size of the Viewport marked as the xr viewport.

---

PackedStringArray _get_suggested_pose_names(tracker_name: StringName) virtual const 

Returns a PackedStringArray with pose names configured by this interface. Note that user configuration can override this list.

---

PackedStringArray _get_suggested_tracker_names() virtual const 

Returns a PackedStringArray with tracker names configured by this interface. Note that user configuration can override this list.

---

Dictionary _get_system_info() virtual const 

Returns a Dictionary with system information related to this interface.

---

TrackingStatus _get_tracking_status() virtual const 

Returns the current status of our tracking.

---

Transform3D _get_transform_for_view(view: int, cam_transform: Transform3D) virtual 

Returns a Transform3D for a given view.

---

RID _get_velocity_texture() virtual 

Return velocity texture into which to render (if applicable).

---

int _get_view_count() virtual 

Returns the number of views this interface requires, 1 for mono, 2 for stereoscopic.

---

RID _get_vrs_texture() virtual 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

VRSTextureFormat _get_vrs_texture_format() virtual 

Returns the format of the texture returned by _get_vrs_texture().

---

bool _initialize() virtual 

Initializes the interface, returns true on success.

---

bool _is_initialized() virtual const 

Returns true if this interface has been initialized.

---

void _post_draw_viewport(render_target: RID, screen_rect: Rect2) virtual 

Called after the XR Viewport draw logic has completed.

---

bool _pre_draw_viewport(render_target: RID) virtual 

Called if this is our primary XRInterfaceExtension before we start processing a Viewport for every active XR Viewport, returns true if that viewport should be rendered. An XR interface may return false if the user has taken off their headset and we can pause rendering.

---

void _pre_render() virtual 

Called if this XRInterfaceExtension is active before rendering starts. Most XR interfaces will sync tracking at this point in time.

---

void _process() virtual 

Called if this XRInterfaceExtension is active before our physics and game process is called. Most XR interfaces will update its XRPositionalTrackers at this point in time.

---

void _set_anchor_detection_is_enabled(enabled: bool) virtual 

Enables anchor detection on this interface if supported.

---

bool _set_play_area_mode(mode: PlayAreaMode) virtual const 

Set the play area mode for this interface.

---

bool _supports_play_area_mode(mode: PlayAreaMode) virtual const 

Returns true if this interface supports this play area mode.

---

void _trigger_haptic_pulse(action_name: String, tracker_name: StringName, frequency: float, amplitude: float, duration_sec: float, delay_sec: float) virtual 

Triggers a haptic pulse to be emitted on the specified tracker.

---

void _uninitialize() virtual 

Uninitialize the interface.

---

void add_blit(render_target: RID, src_rect: Rect2, dst_rect: Rect2i, use_layer: bool, layer: int, apply_lens_distortion: bool, eye_center: Vector2, k1: float, k2: float, upscale: float, aspect_ratio: float) 

Blits our render results to screen optionally applying lens distortion. This can only be called while processing _commit_views.

---

RID get_color_texture() 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID get_depth_texture() 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID get_render_target_texture(render_target: RID) 

Returns a valid RID for a texture to which we should render the current frame if supported by the interface.

---

RID get_velocity_texture() 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!
