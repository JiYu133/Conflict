# OpenXRAPIExtension

Inherits: RefCounted < Object

Makes the OpenXR API available for GDExtension.

## Description

OpenXRAPIExtension makes OpenXR available for GDExtension. It provides the OpenXR API to GDExtension through the get_instance_proc_addr() method, and the OpenXR instance through get_instance().

It also provides methods for querying the status of OpenXR initialization, and helper methods for ease of use of the API with GDExtension.

## Tutorials

- XrResult documentation [https://registry.khronos.org/OpenXR/specs/1.0/man/html/XrResult.html]
- XrInstance documentation [https://registry.khronos.org/OpenXR/specs/1.0/man/html/XrInstance.html]
- XrSpace documentation [https://registry.khronos.org/OpenXR/specs/1.0/man/html/XrSpace.html]
- XrSession documentation [https://registry.khronos.org/OpenXR/specs/1.0/man/html/XrSession.html]
- XrSystemId documentation [https://registry.khronos.org/OpenXR/specs/1.0/man/html/XrSystemId.html]
- xrBeginSession documentation [https://registry.khronos.org/OpenXR/specs/1.0/man/html/xrBeginSession.html]
- XrPosef documentation [https://registry.khronos.org/OpenXR/specs/1.0/man/html/XrPosef.html]

## Methods

int | action_get_handle(action: RID)
void | begin_debug_label_region(label_name: String)
bool | can_render()
void | end_debug_label_region()
RID | find_action(name: String, action_set: RID)
String | get_error_string(result: int)
int | get_hand_tracker(hand_index: int)
int | get_instance()
int | get_instance_proc_addr(name: String)
int | get_next_frame_time()
int | get_openxr_version()
int | get_play_space()
int | get_predicted_display_time()
int | get_projection_layer()
float | get_render_state_z_far()
float | get_render_state_z_near()
int | get_session()
PackedInt64Array | get_supported_swapchain_formats()
String | get_swapchain_format_name(swapchain_format: int)
int | get_system_id()
int | get_view_configuration() const
int | get_view_count() const
void | insert_debug_label(label_name: String)
OpenXRAlphaBlendModeSupport | is_environment_blend_mode_alpha_supported()
bool | is_initialized()
bool | is_running()
bool | openxr_is_enabled(check_run_in_editor: bool) static
void | openxr_swapchain_acquire(swapchain: int)
int | openxr_swapchain_create(create_flags: int, usage_flags: int, swapchain_format: int, width: int, height: int, sample_count: int, array_size: int)
void | openxr_swapchain_free(swapchain: int)
RID | openxr_swapchain_get_image(swapchain: int)
int | openxr_swapchain_get_swapchain(swapchain: int)
void | openxr_swapchain_release(swapchain: int)
void | register_composition_layer_provider(extension: OpenXRExtensionWrapper)
void | register_frame_info_extension(extension: OpenXRExtensionWrapper)
void | register_projection_layer_extension(extension: OpenXRExtensionWrapper)
void | register_projection_views_extension(extension: OpenXRExtensionWrapper)
void | set_custom_play_space(space: const void*)
void | set_emulate_environment_blend_mode_alpha_blend(enabled: bool)
void | set_object_name(object_type: int, object_handle: int, object_name: String)
void | set_render_region(render_region: Rect2i)
void | set_velocity_depth_texture(render_target: RID)
void | set_velocity_target_size(target_size: Vector2i)
void | set_velocity_texture(render_target: RID)
Transform3D | transform_from_pose(pose: const void*)
void | unregister_composition_layer_provider(extension: OpenXRExtensionWrapper)
void | unregister_frame_info_extension(extension: OpenXRExtensionWrapper)
void | unregister_projection_layer_extension(extension: OpenXRExtensionWrapper)
void | unregister_projection_views_extension(extension: OpenXRExtensionWrapper)
void | update_main_swapchain_size()
bool | xr_result(result: int, format: String, args: Array)

---

## Enumerations

enum OpenXRAlphaBlendModeSupport
OpenXRAlphaBlendModeSupport OPENXR_ALPHA_BLEND_MODE_SUPPORT_NONE = 0

Means that XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND isn't supported at all.

OpenXRAlphaBlendModeSupport OPENXR_ALPHA_BLEND_MODE_SUPPORT_REAL = 1

Means that XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND is really supported.

OpenXRAlphaBlendModeSupport OPENXR_ALPHA_BLEND_MODE_SUPPORT_EMULATING = 2

Means that XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND is emulated.

---

## Method Descriptions

int action_get_handle(action: RID) 

Returns the corresponding XrAction OpenXR handle for the given action RID.

---

void begin_debug_label_region(label_name: String) 

Begins a new debug label region, this label will be reported in debug messages for any calls following this until end_debug_label_region() is called. Debug labels can be stacked.

---

bool can_render() 

Returns true if OpenXR is initialized for rendering with an XR viewport.

---

void end_debug_label_region() 

Marks the end of a debug label region. Removes the latest debug label region added by calling begin_debug_label_region().

---

RID find_action(name: String, action_set: RID) 

Returns the RID corresponding to an Action of a matching name, optionally limited to a specified action set.

---

String get_error_string(result: int) 

Returns an error string for the given XrResult [https://registry.khronos.org/OpenXR/specs/1.0/man/html/XrResult.html].

---

int get_hand_tracker(hand_index: int) 

Returns the corresponding XRHandTrackerEXT handle for the given hand index value.

---

int get_instance() 

Returns the XrInstance [https://registry.khronos.org/OpenXR/specs/1.0/man/html/XrInstance.html] created during the initialization of the OpenXR API.

---

int get_instance_proc_addr(name: String) 

Returns the function pointer of the OpenXR function with the specified name, cast to an integer. If the function with the given name does not exist, the method returns 0.

Note: openxr/util.h contains utility macros for acquiring OpenXR functions, e.g. GDEXTENSION_INIT_XR_FUNC_V(xrCreateAction).

---

int get_next_frame_time() 

Returns the predicted display timing for the next frame.

---

int get_openxr_version() 

Returns the version of OpenXR that was initialized. Only valid after the OpenXR instance has been created. See XR_MAKE_VERSION [https://registry.khronos.org/OpenXR/specs/1.1/html/xrspec.html#XR_MAKE_VERSION] for how the version is calculated.

---

int get_play_space() 

Returns the play space, which is an XrSpace [https://registry.khronos.org/OpenXR/specs/1.0/man/html/XrSpace.html] cast to an integer.

---

int get_predicted_display_time() 

Returns the predicted display timing for the current frame.

---

int get_projection_layer() 

Returns a pointer to the render state's XrCompositionLayerProjection struct.

Note: This method should only be called from the rendering thread.

---

float get_render_state_z_far() 

Returns the far boundary value of the camera frustum.

Note: This is only accessible in the render thread.

---

float get_render_state_z_near() 

Returns the near boundary value of the camera frustum.

Note: This is only accessible in the render thread.

---

int get_session() 

Returns the OpenXR session, which is an XrSession [https://registry.khronos.org/OpenXR/specs/1.0/man/html/XrSession.html] cast to an integer.

---

PackedInt64Array get_supported_swapchain_formats() 

Returns an array of supported swapchain formats.

---

String get_swapchain_format_name(swapchain_format: int) 

Returns the name of the specified swapchain format.

---

int get_system_id() 

Returns the ID of the system, which is an XrSystemId [https://registry.khronos.org/OpenXR/specs/1.0/man/html/XrSystemId.html] cast to an integer.

---

int get_view_configuration() const 

Returns the view configuration type, which is an XrViewConfigurationType [https://registry.khronos.org/OpenXR/specs/1.0/man/html/XrViewConfigurationType.html] cast to an integer.

---

int get_view_count() const 

Returns the number of views. It is usually two, one for each eye, but may differ with different view configurations.

---

void insert_debug_label(label_name: String) 

Inserts a debug label, this label is reported in any debug message resulting from the OpenXR calls that follows, until any of begin_debug_label_region(), end_debug_label_region(), or insert_debug_label() is called.

---

OpenXRAlphaBlendModeSupport is_environment_blend_mode_alpha_supported() 

Returns OpenXRAlphaBlendModeSupport denoting if XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND is really supported, emulated or not supported at all.

---

bool is_initialized() 

Returns true if OpenXR is initialized.

---

bool is_running() 

Returns true if OpenXR is running (xrBeginSession [https://registry.khronos.org/OpenXR/specs/1.0/man/html/xrBeginSession.html] was successfully called and the swapchains were created).

---

bool openxr_is_enabled(check_run_in_editor: bool) static 

Returns true if OpenXR is enabled.

---

void openxr_swapchain_acquire(swapchain: int) 

Acquires the image of the provided swapchain.

---

int openxr_swapchain_create(create_flags: int, usage_flags: int, swapchain_format: int, width: int, height: int, sample_count: int, array_size: int) 

Returns a pointer to a new swapchain created using the provided parameters.

---

void openxr_swapchain_free(swapchain: int) 

Destroys the provided swapchain and frees it from memory.

---

RID openxr_swapchain_get_image(swapchain: int) 

Returns the RID of the provided swapchain's image.

---

int openxr_swapchain_get_swapchain(swapchain: int) 

Returns the XrSwapchain handle of the provided swapchain.

---

void openxr_swapchain_release(swapchain: int) 

Releases the image of the provided swapchain.

---

void register_composition_layer_provider(extension: OpenXRExtensionWrapper) 

Registers the given extension as a composition layer provider.

Note: This cannot be called after the OpenXR session has started. However, it can be called in OpenXRExtensionWrapper._on_session_created().

---

void register_frame_info_extension(extension: OpenXRExtensionWrapper) 

Registers the given extension as modifying frame info via the OpenXRExtensionWrapper._set_frame_wait_info_and_get_next_pointer(), OpenXRExtensionWrapper._set_view_locate_info_and_get_next_pointer(), or OpenXRExtensionWrapper._set_frame_end_info_and_get_next_pointer() virtual methods.

Note: This cannot be called after the OpenXR session has started. However, it can be called in OpenXRExtensionWrapper._on_session_created().

---

void register_projection_layer_extension(extension: OpenXRExtensionWrapper) 

Registers the given extension as modifying XrCompositionLayerProjection via the OpenXRExtensionWrapper._set_projection_layer_and_get_next_pointer() virtual method.

Note: This cannot be called after the OpenXR session has started. However, it can be called in OpenXRExtensionWrapper._on_session_created().

---

void register_projection_views_extension(extension: OpenXRExtensionWrapper) 

Registers the given extension as a provider of additional data structures to projections views.

Note: This cannot be called after the OpenXR session has started. However, it can be called in OpenXRExtensionWrapper._on_session_created().

---

void set_custom_play_space(space: const void*) 

Sets the reference space used by OpenXR to the given XrSpace [https://registry.khronos.org/OpenXR/specs/1.0/man/html/XrSpace.html] (cast to a void *).

---

void set_emulate_environment_blend_mode_alpha_blend(enabled: bool) 

If set to true, an OpenXR extension is loaded which is capable of emulating the XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND blend mode.

---

void set_object_name(object_type: int, object_handle: int, object_name: String) 

Set the object name of an OpenXR object, used for debug output. object_type must be a valid OpenXR XrObjectType enum and object_handle must be a valid OpenXR object handle.

---

void set_render_region(render_region: Rect2i) 

Sets the render region to render_region, overriding the normal render target's rect.

---

void set_velocity_depth_texture(render_target: RID) 

Sets the render target of the velocity depth texture.

---

void set_velocity_target_size(target_size: Vector2i) 

Sets the target size of the velocity and velocity depth textures.

---

void set_velocity_texture(render_target: RID) 

Sets the render target of the velocity texture.

---

Transform3D transform_from_pose(pose: const void*) 

Creates a Transform3D from an XrPosef [https://registry.khronos.org/OpenXR/specs/1.0/man/html/XrPosef.html].

---

void unregister_composition_layer_provider(extension: OpenXRExtensionWrapper) 

Unregisters the given extension as a composition layer provider.

Note: This cannot be called while the OpenXR session is still running.

---

void unregister_frame_info_extension(extension: OpenXRExtensionWrapper) 

Unregisters the given extension as modifying frame info.

Note: This cannot be called while the OpenXR session is still running.

---

void unregister_projection_layer_extension(extension: OpenXRExtensionWrapper) 

Unregisters the given extension as modifying XrCompositionLayerProjection.

Note: This cannot be called while the OpenXR session is still running.

---

void unregister_projection_views_extension(extension: OpenXRExtensionWrapper) 

Unregisters the given extension as a provider of additional data structures to projections views.

Note: This cannot be called while the OpenXR session is still running.

---

void update_main_swapchain_size() 

Request the recommended resolution from the OpenXR runtime and update the main swapchain size if it has changed.

---

bool xr_result(result: int, format: String, args: Array) 

Returns true if the provided XrResult [https://registry.khronos.org/OpenXR/specs/1.0/man/html/XrResult.html] (cast to an integer) is successful. Otherwise returns false and prints the XrResult [https://registry.khronos.org/OpenXR/specs/1.0/man/html/XrResult.html] converted to a string, with the specified additional information.
