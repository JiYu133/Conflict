# BackBufferCopy

Inherits: Node2D < CanvasItem < Node < Object

A node that copies a region of the screen to a buffer for access in shader code.

## Description

Node for back-buffering the currently-displayed screen. The region defined in the BackBufferCopy node is buffered with the content of the screen it covers, or the entire screen according to the copy_mode. It can be accessed in shader scripts using the screen texture (i.e. a uniform sampler with hint_screen_texture).

Note: Since this node inherits from Node2D (and not Control), anchors and margins won't apply to child Control-derived nodes. This can be problematic when resizing the window. To avoid this, add Control-derived nodes as siblings to the BackBufferCopy node instead of adding them as children.

## Tutorials

- Screen-reading shaders

## Properties

CopyMode | copy_mode | 1
Rect2 | rect | Rect2(-100, -100, 200, 200)

---

## Enumerations

enum CopyMode
CopyMode COPY_MODE_DISABLED = 0

Disables the buffering mode. This means the BackBufferCopy node will directly use the portion of screen it covers.

CopyMode COPY_MODE_RECT = 1

BackBufferCopy buffers a rectangular region.

CopyMode COPY_MODE_VIEWPORT = 2

BackBufferCopy buffers the entire screen.

---

## Property Descriptions

CopyMode copy_mode = 1 

- void set_copy_mode(value: CopyMode)
- CopyMode get_copy_mode()

Buffer mode.

---

Rect2 rect = Rect2(-100, -100, 200, 200) 

- void set_rect(value: Rect2)
- Rect2 get_rect()

The area covered by the BackBufferCopy. Only used if copy_mode is COPY_MODE_RECT.
