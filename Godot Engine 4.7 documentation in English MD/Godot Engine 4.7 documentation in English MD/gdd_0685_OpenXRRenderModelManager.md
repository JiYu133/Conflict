# OpenXRRenderModelManager

Inherits: Node3D < Node < Object

Helper node that will automatically manage displaying render models.

## Description

This helper node will automatically manage displaying render models. It will create new OpenXRRenderModel nodes as controllers and other hand held devices are detected, and remove those nodes when they are deactivated.

Note: If you want more control over this logic you can alternatively call OpenXRRenderModelExtension.render_model_get_all() to obtain a list of active render model ids and create OpenXRRenderModel instances for each render model id provided.

## Properties

String | make_local_to_pose | ""
RenderModelTracker | tracker | 0

---

## Signals

render_model_added(render_model: OpenXRRenderModel) 

Emitted when a render model node is added as a child to this node.

---

render_model_removed(render_model: OpenXRRenderModel) 

Emitted when a render model child node is about to be removed from this node.

---

## Enumerations

enum RenderModelTracker
RenderModelTracker RENDER_MODEL_TRACKER_ANY = 0

All active render models are shown regardless of what tracker they relate to.

RenderModelTracker RENDER_MODEL_TRACKER_NONE_SET = 1

Only active render models are shown that are not related to any tracker we manage.

RenderModelTracker RENDER_MODEL_TRACKER_LEFT_HAND = 2

Only active render models are shown that are related to the left hand tracker.

RenderModelTracker RENDER_MODEL_TRACKER_RIGHT_HAND = 3

Only active render models are shown that are related to the right hand tracker.

---

## Property Descriptions

String make_local_to_pose = "" 

- void set_make_local_to_pose(value: String)
- String get_make_local_to_pose()

Position render models local to this pose (this will adjust the position of the render models container node).

---

RenderModelTracker tracker = 0 

- void set_tracker(value: RenderModelTracker)
- RenderModelTracker get_tracker()

Limits render models to the specified tracker. Include: 0 = All render models, 1 = Render models not related to a tracker, 2 = Render models related to the left hand tracker, 3 = Render models related to the right hand tracker.
