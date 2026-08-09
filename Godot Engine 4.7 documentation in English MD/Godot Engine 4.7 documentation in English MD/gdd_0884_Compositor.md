# Compositor

Experimental: More customization of the rendering pipeline will be added in the future.

Inherits: Resource < RefCounted < Object

Stores attributes used to customize how a Viewport is rendered.

## Description

The compositor resource stores attributes used to customize how a Viewport is rendered.

## Tutorials

- The Compositor

## Properties

Array[CompositorEffect] | compositor_effects | []

---

## Property Descriptions

Array[CompositorEffect] compositor_effects = [] 

- void set_compositor_effects(value: Array[CompositorEffect])
- Array[CompositorEffect] get_compositor_effects()

The custom CompositorEffects that are applied during rendering of viewports using this compositor.
