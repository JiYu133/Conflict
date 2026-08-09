# StyleBox

Inherits: Resource < RefCounted < Object

Inherited By: StyleBoxEmpty, StyleBoxFlat, StyleBoxLine, StyleBoxTexture

Abstract base class for defining stylized boxes for UI elements.

## Description

StyleBox is an abstract base class for drawing stylized boxes for UI elements. It is used for panels, buttons, LineEdit backgrounds, Tree backgrounds, etc. and also for testing a transparency mask for pointer signals. If mask test fails on a StyleBox assigned as mask to a control, clicks and motion signals will go through it to the one below.

Note: For control nodes that have Theme Properties, the focus StyleBox is displayed over the normal, hover or pressed StyleBox. This makes the focus StyleBox more reusable across different nodes.

## Properties

float | content_margin_bottom | -1.0
float | content_margin_left | -1.0
float | content_margin_right | -1.0
float | content_margin_top | -1.0

## Methods

void | _draw(to_canvas_item: RID, rect: Rect2) virtual required const
Rect2 | _get_draw_rect(rect: Rect2) virtual const
Vector2 | _get_minimum_size() virtual const
bool | _test_mask(point: Vector2, rect: Rect2) virtual const
void | draw(canvas_item: RID, rect: Rect2) const
float | get_content_margin(margin: Side) const
CanvasItem | get_current_item_drawn() const
float | get_margin(margin: Side) const
Vector2 | get_minimum_size() const
Vector2 | get_offset() const
void | set_content_margin(margin: Side, offset: float)
void | set_content_margin_all(offset: float)
bool | test_mask(point: Vector2, rect: Rect2) const

---

## Property Descriptions

float content_margin_bottom = -1.0 

- void set_content_margin(margin: Side, offset: float)
- float get_content_margin(margin: Side) const

The bottom margin for the contents of this style box. Increasing this value reduces the space available to the contents from the bottom.

If this value is negative, it is ignored and a child-specific margin is used instead. For example, for StyleBoxFlat, the border thickness (if any) is used instead.

It is up to the code using this style box to decide what these contents are: for example, a Button respects this content margin for the textual contents of the button.

get_margin() should be used to fetch this value as consumer instead of reading these properties directly. This is because it correctly respects negative values and the fallback mentioned above.

---

float content_margin_left = -1.0 

- void set_content_margin(margin: Side, offset: float)
- float get_content_margin(margin: Side) const

The left margin for the contents of this style box. Increasing this value reduces the space available to the contents from the left.

Refer to content_margin_bottom for extra considerations.

---

float content_margin_right = -1.0 

- void set_content_margin(margin: Side, offset: float)
- float get_content_margin(margin: Side) const

The right margin for the contents of this style box. Increasing this value reduces the space available to the contents from the right.

Refer to content_margin_bottom for extra considerations.

---

float content_margin_top = -1.0 

- void set_content_margin(margin: Side, offset: float)
- float get_content_margin(margin: Side) const

The top margin for the contents of this style box. Increasing this value reduces the space available to the contents from the top.

Refer to content_margin_bottom for extra considerations.

---

## Method Descriptions

void _draw(to_canvas_item: RID, rect: Rect2) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Rect2 _get_draw_rect(rect: Rect2) virtual const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector2 _get_minimum_size() virtual const 

Virtual method to be implemented by the user. Returns a custom minimum size that the stylebox must respect when drawing. By default get_minimum_size() only takes content margins into account. This method can be overridden to add another size restriction. A combination of the default behavior and the output of this method will be used, to account for both sizes.

---

bool _test_mask(point: Vector2, rect: Rect2) virtual const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void draw(canvas_item: RID, rect: Rect2) const 

Draws this stylebox using a canvas item identified by the given RID.

The RID value can either be the result of CanvasItem.get_canvas_item() called on an existing CanvasItem-derived node, or directly from creating a canvas item in the RenderingServer with RenderingServer.canvas_item_create().

---

float get_content_margin(margin: Side) const 

Returns the default margin of the specified Side.

---

CanvasItem get_current_item_drawn() const 

Returns the CanvasItem that handles its CanvasItem.NOTIFICATION_DRAW or CanvasItem._draw() callback at this moment.

---

float get_margin(margin: Side) const 

Returns the content margin offset for the specified Side.

Positive values reduce size inwards, unlike Control's margin values.

---

Vector2 get_minimum_size() const 

Returns the minimum size that this stylebox can be shrunk to.

---

Vector2 get_offset() const 

Returns the "offset" of a stylebox. This helper function returns a value equivalent to Vector2(style.get_margin(MARGIN_LEFT), style.get_margin(MARGIN_TOP)).

---

void set_content_margin(margin: Side, offset: float) 

Sets the default value of the specified Side to offset pixels.

---

void set_content_margin_all(offset: float) 

Sets the default margin to offset pixels for all sides.

---

bool test_mask(point: Vector2, rect: Rect2) const 

Test a position in a rectangle, return whether it passes the mask test.
