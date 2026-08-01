# FlowContainer

Inherits: Container < Control < CanvasItem < Node < Object

Inherited By: HFlowContainer, VFlowContainer

A container that arranges its child controls horizontally or vertically and wraps them around at the borders.

## Description

A container that arranges its child controls horizontally or vertically and wraps them around at the borders. This is similar to how text in a book wraps around when no more words can fit on a line.

## Tutorials

- Using Containers

## Properties

AlignmentMode | alignment | 0
LastWrapAlignmentMode | last_wrap_alignment | 0
bool | reverse_fill | false
bool | vertical | false

## Methods

int | get_line_count() const

## Theme Properties

int | h_separation | 4
int | v_separation | 4

---

## Enumerations

enum AlignmentMode
AlignmentMode ALIGNMENT_BEGIN = 0

The child controls will be arranged at the beginning of the container, i.e. top if orientation is vertical, left if orientation is horizontal (right for RTL layout).

AlignmentMode ALIGNMENT_CENTER = 1

The child controls will be centered in the container.

AlignmentMode ALIGNMENT_END = 2

The child controls will be arranged at the end of the container, i.e. bottom if orientation is vertical, right if orientation is horizontal (left for RTL layout).

---

enum LastWrapAlignmentMode
LastWrapAlignmentMode LAST_WRAP_ALIGNMENT_INHERIT = 0

The last partially filled row or column will wrap aligned to the previous row or column in accordance with alignment.

LastWrapAlignmentMode LAST_WRAP_ALIGNMENT_BEGIN = 1

The last partially filled row or column will wrap aligned to the beginning of the previous row or column.

LastWrapAlignmentMode LAST_WRAP_ALIGNMENT_CENTER = 2

The last partially filled row or column will wrap aligned to the center of the previous row or column.

LastWrapAlignmentMode LAST_WRAP_ALIGNMENT_END = 3

The last partially filled row or column will wrap aligned to the end of the previous row or column.

---

## Property Descriptions

AlignmentMode alignment = 0 

- void set_alignment(value: AlignmentMode)
- AlignmentMode get_alignment()

The alignment of the container's children (must be one of ALIGNMENT_BEGIN, ALIGNMENT_CENTER, or ALIGNMENT_END).

---

LastWrapAlignmentMode last_wrap_alignment = 0 

- void set_last_wrap_alignment(value: LastWrapAlignmentMode)
- LastWrapAlignmentMode get_last_wrap_alignment()

The wrap behavior of the last, partially filled row or column (must be one of LAST_WRAP_ALIGNMENT_INHERIT, LAST_WRAP_ALIGNMENT_BEGIN, LAST_WRAP_ALIGNMENT_CENTER, or LAST_WRAP_ALIGNMENT_END).

---

bool reverse_fill = false 

- void set_reverse_fill(value: bool)
- bool is_reverse_fill()

If true, reverses fill direction. Horizontal FlowContainers will fill rows bottom to top, vertical FlowContainers will fill columns right to left.

When using a vertical FlowContainer with a right to left Control.layout_direction, columns will fill left to right instead.

---

bool vertical = false 

- void set_vertical(value: bool)
- bool is_vertical()

If true, the FlowContainer will arrange its children vertically, rather than horizontally.

Can't be changed when using HFlowContainer and VFlowContainer.

---

## Method Descriptions

int get_line_count() const 

Returns the current line count.

---

## Theme Property Descriptions

int h_separation = 4 

The horizontal separation of child nodes.

---

int v_separation = 4 

The vertical separation of child nodes.
