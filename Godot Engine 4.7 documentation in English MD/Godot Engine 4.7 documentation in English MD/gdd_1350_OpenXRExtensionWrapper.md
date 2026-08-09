# OpenXRExtensionWrapper

Inherits: Object

Inherited By: OpenXRAndroidThreadSettingsExtension, OpenXRExtensionWrapperExtension, OpenXRFrameSynthesisExtension, OpenXRFutureExtension, OpenXRRenderModelExtension, OpenXRSpatialAnchorCapability, OpenXRSpatialEntityExtension, OpenXRSpatialMarkerTrackingCapability, OpenXRSpatialPlaneTrackingCapability

Allows implementing OpenXR extensions with GDExtension.

## Description

OpenXRExtensionWrapper allows implementing OpenXR extensions with GDExtension. The extension should be registered with register_extension_wrapper().

When OpenXRInterface is initialized as the primary interface and any Viewport has Viewport.use_xr set to true, OpenXR will become involved in Godot's rendering process. If ProjectSettings.rendering/driver/threads/thread_model is set to "Separate", Godot's renderer will run on its own thread, and special care must be taken in all OpenXRExtensionWrappers in order to prevent crashes or unexpected behavior. Some virtual methods will be called on the render thread, and any data they access should not be directly written to on the main thread. This is to prevent two potential issues:

1. Changes intended for the next frame, taking effect on the current frame. When using the "Separate" thread model, the main thread will immediately start working on the next frame while the render thread may still be rendering the current frame. If the main thread changes anything used by the render thread directly, the change could end up being used one frame earlier than intended.
2. Reading and writing to the same data at the same time from different threads can lead to the render thread using data in an invalid state.

In most cases, the solution is to use RenderingServer.call_on_render_thread() to schedule Callables to write to any data used on the render thread. When using the "Separate" thread model, these Callables will run after the renderer finishes the current frame and before it starts rendering the next frame. When not using this mode, they'll run immediately, so it's recommended to always use RenderingServer.call_on_render_thread() in these cases, which will allow your code to do the right thing regardless of the thread model.

Any virtual methods that run on the render thread will be noted below.

## Methods

int | _get_composition_layer(index: int) virtual
int | _get_composition_layer_count() virtual
int | _get_composition_layer_order(index: int) virtual
Dictionary | _get_requested_extensions(xr_version: int) virtual
PackedStringArray | _get_suggested_tracker_names() virtual
Array[Dictionary] | _get_viewport_composition_layer_extension_properties() virtual
Dictionary | _get_viewport_composition_layer_extension_property_defaults() virtual
void | _on_before_instance_created() virtual
bool | _on_event_polled(event: const void*) virtual
void | _on_instance_created(instance: int) virtual
void | _on_instance_destroyed() virtual
void | _on_main_swapchains_created() virtual
void | _on_post_draw_viewport(viewport: RID) virtual
void | _on_pre_draw_viewport(viewport: RID) virtual
void | _on_pre_render() virtual
void | _on_process() virtual
void | _on_register_metadata(interaction_profile_metadata: OpenXRInteractionProfileMetadata) virtual
void | _on_session_created(session: int) virtual
void | _on_session_destroyed() virtual
void | _on_state_exiting() virtual
void | _on_state_focused() virtual
void | _on_state_idle() virtual
void | _on_state_loss_pending() virtual
void | _on_state_ready() virtual
void | _on_state_stopping() virtual
void | _on_state_synchronized() virtual
void | _on_state_visible() virtual
void | _on_sync_actions() virtual
void | _on_viewport_composition_layer_destroyed(layer: const void*) virtual
void | _prepare_view_configuration(view_count: int) virtual
void | _print_view_configuration_info(view: int) virtual const
int | _set_android_surface_swapchain_create_info_and_get_next_pointer(property_values: Dictionary, next_pointer: void*) virtual
int | _set_frame_end_info_and_get_next_pointer(next_pointer: void*) virtual
int | _set_frame_wait_info_and_get_next_pointer(next_pointer: void*) virtual
int | _set_hand_joint_locations_and_get_next_pointer(hand_index: int, next_pointer: void*) virtual
int | _set_instance_create_info_and_get_next_pointer(xr_version: int, next_pointer: void*) virtual
int | _set_projection_layer_and_get_next_pointer(next_pointer: void*) virtual
int | _set_projection_views_and_get_next_pointer(view_index: int, next_pointer: void*) virtual
int | _set_reference_space_create_info_and_get_next_pointer(reference_space_type: int, next_pointer: void*) virtual
int | _set_session_create_and_get_next_pointer(next_pointer: void*) virtual
int | _set_swapchain_create_info_and_get_next_pointer(next_pointer: void*) virtual
int | _set_system_properties_and_get_next_pointer(next_pointer: void*) virtual
int | _set_view_configuration_and_get_next_pointer(view: int, next_pointer: void*) virtual
int | _set_view_locate_info_and_get_next_pointer(next_pointer: void*) virtual
int | _set_viewport_composition_layer_and_get_next_pointer(layer: const void*, property_values: Dictionary, next_pointer: void*) virtual
OpenXRAPIExtension | get_openxr_api()
void | register_extension_wrapper()

---

## Method Descriptions

int _get_composition_layer(index: int) virtual 

Returns a pointer to an XrCompositionLayerBaseHeader struct to provide the given composition layer.

This will only be called if the extension previously registered itself with OpenXRAPIExtension.register_composition_layer_provider().

Note: This virtual method will be called on the render thread. Additionally, the data it returns will be used shortly after this method is called, so it needs to remain valid until the next time _on_pre_render() runs.

---

int _get_composition_layer_count() virtual 

Returns the number of composition layers this extension wrapper provides via _get_composition_layer().

This will only be called if the extension previously registered itself with OpenXRAPIExtension.register_composition_layer_provider().

Note: This virtual method will be called on the render thread. Additionally, the data it returns will be used shortly after this method is called, so it needs to remain valid until the next time _on_pre_render() runs.

---

int _get_composition_layer_order(index: int) virtual 

Returns an integer that will be used to sort the given composition layer provided via _get_composition_layer(). Lower numbers will move the layer to the front of the list, and higher numbers to the end. The default projection layer has an order of 0, so layers provided by this method should probably be above or below (but not exactly) 0.

This will only be called if the extension previously registered itself with OpenXRAPIExtension.register_composition_layer_provider().

Note: This virtual method will be called on the render thread. Additionally, the data it returns will be used shortly after this method is called, so it needs to remain valid until the next time _on_pre_render() runs.

---

Dictionary _get_requested_extensions(xr_version: int) virtual 

Returns a Dictionary of OpenXR extensions related to this extension. xr_version specifies the OpenXR version we're instantiating. This will be zero if the editor requests this list to flag supported features. The Dictionary should contain the name of the extension, mapped to a bool * cast to an integer:

- If the bool * is a nullptr this extension is mandatory.
- If the bool * points to a boolean, the boolean will be updated to true if the extension is enabled.

---

PackedStringArray _get_suggested_tracker_names() virtual 

Returns a PackedStringArray of positional tracker names that are used within the extension wrapper.

---

Array[Dictionary] _get_viewport_composition_layer_extension_properties() virtual 

Gets an array of Dictionarys that represent properties, just like Object._get_property_list(), that will be added to OpenXRCompositionLayer nodes.

Note: This virtual method will be called on the render thread.

---

Dictionary _get_viewport_composition_layer_extension_property_defaults() virtual 

Gets a Dictionary containing the default values for the properties returned by _get_viewport_composition_layer_extension_properties().

---

void _on_before_instance_created() virtual 

Called before the OpenXR instance is created.

Note: This virtual method will be called on the main thread, however, it will be called before OpenXR becomes involved in rendering, so it is safe to write to data that will be used by the render thread.

---

bool _on_event_polled(event: const void*) virtual 

Called when there is an OpenXR event to process. When implementing, return true if the event was handled, return false otherwise.

---

void _on_instance_created(instance: int) virtual 

Called right after the OpenXR instance is created.

Note: This virtual method will be called on the main thread, however, it will be called before OpenXR becomes involved in rendering, so it is safe to write to data that will be used by the render thread.

---

void _on_instance_destroyed() virtual 

Called right before the OpenXR instance is destroyed.

Note: This virtual method will be called on the main thread, however, it will be called after OpenXR is done being involved in rendering, so it is safe to write to data that was used by the render thread.

---

void _on_main_swapchains_created() virtual 

Called right after the main swapchains are (re)created.

Note: This virtual method will be called on the render thread.

---

void _on_post_draw_viewport(viewport: RID) virtual 

Called right after the given viewport is rendered.

Note: The draw commands might only be queued at this point, not executed.

Note: This virtual method will be called on the render thread.

---

void _on_pre_draw_viewport(viewport: RID) virtual 

Called right before the given viewport is rendered.

Note: This virtual method will be called on the render thread.

---

void _on_pre_render() virtual 

Called right before the XR viewports begin their rendering step.

Note: This virtual method will be called on the render thread.

---

void _on_process() virtual 

Called as part of the OpenXR process handling. This happens right before general and physics processing steps of the main loop. During this step controller data is queried and made available to game logic.

---

void _on_register_metadata(interaction_profile_metadata: OpenXRInteractionProfileMetadata) virtual 

Allows extensions to register additional controller metadata. This function is called even when the OpenXR API is not constructed as the metadata needs to be available to the editor.

Extensions should also provide metadata regardless of whether they are supported on the host system. The controller data is used to setup action maps for users who may have access to the relevant hardware.

---

void _on_session_created(session: int) virtual 

Called right after the OpenXR session is created.

Note: This virtual method will be called on the main thread, however, it will be called before OpenXR becomes involved in rendering, so it is safe to write to data that will be used by the render thread.

---

void _on_session_destroyed() virtual 

Called right before the OpenXR session is destroyed.

Note: This virtual method will be called on the main thread, however, it will be called after OpenXR is done being involved in rendering, so it is safe to write to data that was used by the render thread.

---

void _on_state_exiting() virtual 

Called when the OpenXR session state is changed to exiting.

---

void _on_state_focused() virtual 

Called when the OpenXR session state is changed to focused. This state is the active state when the game runs.

---

void _on_state_idle() virtual 

Called when the OpenXR session state is changed to idle.

---

void _on_state_loss_pending() virtual 

Called when the OpenXR session state is changed to loss pending.

---

void _on_state_ready() virtual 

Called when the OpenXR session state is changed to ready. This means OpenXR is ready to set up the session.

---

void _on_state_stopping() virtual 

Called when the OpenXR session state is changed to stopping.

---

void _on_state_synchronized() virtual 

Called when the OpenXR session state is changed to synchronized. OpenXR also returns to this state when the application loses focus.

---

void _on_state_visible() virtual 

Called when the OpenXR session state is changed to visible. This means OpenXR is now ready to receive frames.

---

void _on_sync_actions() virtual 

Called when OpenXR has performed its action sync.

---

void _on_viewport_composition_layer_destroyed(layer: const void*) virtual 

Called when a composition layer created via OpenXRCompositionLayer is destroyed.

layer is a pointer to an XrCompositionLayerBaseHeader struct.

---

void _prepare_view_configuration(view_count: int) virtual 

Called before _set_view_configuration_and_get_next_pointer() to allow the extension to reserve data for the given number of views.

---

void _print_view_configuration_info(view: int) virtual const 

Called to allow an extension to print additional information about its view configuration, if applicable. This will only be called if verbose output is enabled.

---

int _set_android_surface_swapchain_create_info_and_get_next_pointer(property_values: Dictionary, next_pointer: void*) virtual 

Add additional data structures to Android surface swapchains created by OpenXRCompositionLayer.

property_values contains the values of the properties returned by _get_viewport_composition_layer_extension_properties().

Note: This virtual method will be called on the render thread.

---

int _set_frame_end_info_and_get_next_pointer(next_pointer: void*) virtual 

Add additional data structures to XrFrameEndInfo.

This will only be called if the extension previously registered itself with OpenXRAPIExtension.register_frame_info_extension().

Note: This virtual method will be called on the render thread. Additionally, the data it returns will be used shortly after this method is called, so it needs to remain valid until the next time _on_pre_render() runs.

---

int _set_frame_wait_info_and_get_next_pointer(next_pointer: void*) virtual 

Add additional data structures to XrFrameWaitInfo.

This will only be called if the extension previously registered itself with OpenXRAPIExtension.register_frame_info_extension().

Note: This virtual method will be called on the render thread.

---

int _set_hand_joint_locations_and_get_next_pointer(hand_index: int, next_pointer: void*) virtual 

Add additional data structures when each hand tracker is created.

---

int _set_instance_create_info_and_get_next_pointer(xr_version: int, next_pointer: void*) virtual 

Add additional data structures when the OpenXR instance is created. xr_version specifies the OpenXR version we're instantiating.

---

int _set_projection_layer_and_get_next_pointer(next_pointer: void*) virtual 

Adds additional data structures to XrCompositionLayerProjection.

This will only be called if the extension previously registered itself with OpenXRAPIExtension.register_projection_layer_extension().

---

int _set_projection_views_and_get_next_pointer(view_index: int, next_pointer: void*) virtual 

Add additional data structures to the projection view of the given view_index.

Note: This virtual method will be called on the render thread. Additionally, the data it returns will be used shortly after this method is called, so it needs to remain valid until the next time _on_pre_render() runs.

---

int _set_reference_space_create_info_and_get_next_pointer(reference_space_type: int, next_pointer: void*) virtual 

Add additional data structures to XrReferenceSpaceCreateInfo.

---

int _set_session_create_and_get_next_pointer(next_pointer: void*) virtual 

Add additional data structures when the OpenXR session is created.

---

int _set_swapchain_create_info_and_get_next_pointer(next_pointer: void*) virtual 

Add additional data structures when creating OpenXR swapchains.

---

int _set_system_properties_and_get_next_pointer(next_pointer: void*) virtual 

Add additional data structures when querying OpenXR system abilities.

---

int _set_view_configuration_and_get_next_pointer(view: int, next_pointer: void*) virtual 

Add additional data structures when querying OpenXR view configuration.

---

int _set_view_locate_info_and_get_next_pointer(next_pointer: void*) virtual 

Add additional data structures to XrViewLocateInfo.

This will only be called if the extension previously registered itself with OpenXRAPIExtension.register_frame_info_extension().

Note: This virtual method will be called on the render thread. Additionally, the data it returns will be used shortly after this method is called, so it needs to remain valid until the next time _on_pre_render() runs.

---

int _set_viewport_composition_layer_and_get_next_pointer(layer: const void*, property_values: Dictionary, next_pointer: void*) virtual 

Add additional data structures to composition layers created by OpenXRCompositionLayer.

property_values contains the values of the properties returned by _get_viewport_composition_layer_extension_properties().

layer is a pointer to an XrCompositionLayerBaseHeader struct.

Note: This virtual method will be called on the render thread. Additionally, the data it returns will be used shortly after this method is called, so it needs to remain valid until the next time _on_pre_render() runs.

---

OpenXRAPIExtension get_openxr_api() 

Returns the created OpenXRAPIExtension, which can be used to access the OpenXR API.

---

void register_extension_wrapper() 

Registers the extension. This should happen at core module initialization level.

Note: This cannot be called once OpenXR has been initialized.
