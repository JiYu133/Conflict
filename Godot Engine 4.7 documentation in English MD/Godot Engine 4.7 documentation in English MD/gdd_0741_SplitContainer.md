# SplitContainer

Inherits: Container < Control < CanvasItem < Node < Object

Inherited By: HSplitContainer, VSplitContainer

A container that arranges child controls horizontally or vertically and provides grabbers for adjusting the split ratios between them.

## Description

A container that arranges child controls horizontally or vertically and creates grabbers between them. The grabbers can be dragged around to change the size relations between the child controls.

## Tutorials

- Using Containers

## Properties

bool | collapsed | false
bool | drag_area_highlight_in_editor | false
int | drag_area_margin_begin | 0
int | drag_area_margin_end | 0
int | drag_area_offset | 0
bool | drag_nested_intersections | false
DraggerVisibility | dragger_visibility | 0
bool | dragging_enabled | true
int | split_offset | 0
PackedInt32Array | split_offsets | PackedInt32Array(0)
bool | touch_dragger_enabled | false
bool | vertical | false

## Methods

void | clamp_split_offset(priority_index: int = 0)
Control | get_drag_area_control()
Array[Control] | get_drag_area_controls()

## Theme Properties

Color | touch_dragger_color | Color(1, 1, 1, 0.3)
Color | touch_dragger_hover_color | Color(1, 1, 1, 0.6)
Color | touch_dragger_pressed_color | Color(1, 1, 1, 1)
int | autohide | 1
int | minimum_grab_thickness | 6
int | separation | 12
Texture2D | grabber |
Texture2D | h_grabber |
Texture2D | h_touch_dragger |
Texture2D | touch_dragger |
Texture2D | v_grabber |
Texture2D | v_touch_dragger |
StyleBox | split_bar_background |

---

## Signals

drag_ended() 

Emitted when the user ends dragging.

---

drag_started() 

Emitted when the user starts dragging.

---

dragged(offset: int) 

Emitted when any dragger is dragged by user.

---

## Enumerations

enum DraggerVisibility
DraggerVisibility DRAGGER_VISIBLE = 0

The split dragger icon is always visible when autohide is false, otherwise visible only when the cursor hovers it.

The size of the grabber icon determines the minimum separation.

The dragger icon is automatically hidden if the length of the grabber icon is longer than the split bar.

DraggerVisibility DRAGGER_HIDDEN = 1

The split dragger icon is never visible regardless of the value of autohide.

The size of the grabber icon determines the minimum separation.

DraggerVisibility DRAGGER_HIDDEN_COLLAPSED = 2

The split dragger icon is not visible, and the split bar is collapsed to zero thickness.

---

## Property Descriptions

bool collapsed = false 

- void set_collapsed(value: bool)
- bool is_collapsed()

If true, the draggers will be disabled and the children will be sized as if all split_offsets were 0.

---

bool drag_area_highlight_in_editor = false 

- void set_drag_area_highlight_in_editor(value: bool)
- bool is_drag_area_highlight_in_editor_enabled()

Highlights the drag area Rect2 so you can see where it is during development. The drag area is gold if dragging_enabled is true, and red if false.

---

int drag_area_margin_begin = 0 

- void set_drag_area_margin_begin(value: int)
- int get_drag_area_margin_begin()

Reduces the size of the drag area and split bar split_bar_background at the beginning of the container.

---

int drag_area_margin_end = 0 

- void set_drag_area_margin_end(value: int)
- int get_drag_area_margin_end()

Reduces the size of the drag area and split bar split_bar_background at the end of the container.

---

int drag_area_offset = 0 

- void set_drag_area_offset(value: int)
- int get_drag_area_offset()

Shifts the drag area in the axis of the container to prevent the drag area from overlapping the ScrollBar or other selectable Control of a child node.

---

bool drag_nested_intersections = false 

- void set_drag_nested_intersections(value: bool)
- bool is_dragging_nested_intersections()

Adds extra draggers at the intersection of the draggers of two SplitContainers to allow dragging both at once. This must be set to true for both SplitContainers, and one needs to be a descendant of the other. They also must be orthogonal (their vertical are different) and the descendant must be next to at least one of the ancestor's draggers (within minimum_grab_thickness).

---

DraggerVisibility dragger_visibility = 0 

- void set_dragger_visibility(value: DraggerVisibility)
- DraggerVisibility get_dragger_visibility()

Determines the dragger's visibility. This property does not determine whether dragging is enabled or not. Use dragging_enabled for that.

---

bool dragging_enabled = true 

- void set_dragging_enabled(value: bool)
- bool is_dragging_enabled()

Enables or disables split dragging.

---

int split_offset = 0 

- void set_split_offset(value: int)
- int get_split_offset()

Deprecated: Use split_offsets instead. The first element of the array is the split offset between the first two children.

The first element of split_offsets.

---

PackedInt32Array split_offsets = PackedInt32Array(0) 

- void set_split_offsets(value: PackedInt32Array)
- PackedInt32Array get_split_offsets()

Offsets for each dragger in pixels. Each one is the offset of the split between the Control nodes before and after the dragger, with 0 being the default position. The default position is based on the Control nodes expand flags and minimum sizes. See Control.size_flags_horizontal, Control.size_flags_vertical, and Control.size_flags_stretch_ratio.

If none of the Control nodes before the dragger are expanded, the default position will be at the start of the SplitContainer. If none of the Control nodes after the dragger are expanded, the default position will be at the end of the SplitContainer. If the dragger is in between expanded Control nodes, the default position will be in the middle, based on the Control.size_flags_stretch_ratios and minimum sizes.

Note: If the split offsets cause Control nodes to overlap, the first split will take priority when resolving the positions.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedInt32Array for more details.

---

bool touch_dragger_enabled = false 

- void set_touch_dragger_enabled(value: bool)
- bool is_touch_dragger_enabled()

If true, a touch-friendly drag handle will be enabled for better usability on smaller screens. Unlike the standard grabber, this drag handle overlaps the SplitContainer's children and does not affect their minimum separation. The standard grabber will no longer be drawn when this option is enabled.

---

bool vertical = false 

- void set_vertical(value: bool)
- bool is_vertical()

If true, the SplitContainer will arrange its children vertically, rather than horizontally.

Can't be changed when using HSplitContainer and VSplitContainer.

---

## Method Descriptions

void clamp_split_offset(priority_index: int = 0) 

Clamps the split_offsets values to ensure they are within valid ranges and do not overlap with each other. When overlaps occur, this method prioritizes one split offset (at index priority_index) by clamping any overlapping split offsets to it.

---

Control get_drag_area_control() 

Deprecated: Use the first element of get_drag_area_controls() instead.

Returns the drag area Control. For example, you can move a pre-configured button into the drag area Control so that it rides along with the split bar. Try setting the Button anchors to center prior to the reparent() call.

```gdscript
$BarnacleButton.reparent($SplitContainer.get_drag_area_control())
```

Note: The drag area Control is drawn over the SplitContainer's children, so CanvasItem draw objects called from the Control and children added to the Control will also appear over the SplitContainer's children. Try setting Control.mouse_filter of custom children to Control.MOUSE_FILTER_IGNORE to prevent blocking the mouse from dragging if desired.

Warning: This is a required internal node, removing and freeing it may cause a crash.

---

Array[Control] get_drag_area_controls() 

Returns an Array of the drag area Controls. These are the interactable Control nodes between each child. For example, this can be used to add a pre-configured button to a drag area Control so that it rides along with the split bar. Try setting the Button anchors to center prior to the Node.reparent() call.

```gdscript
$BarnacleButton.reparent($SplitContainer.get_drag_area_controls()[0])
```

Note: The drag area Controls are drawn over the SplitContainer's children, so CanvasItem draw objects called from a drag area and children added to it will also appear over the SplitContainer's children. Try setting Control.mouse_filter of custom children to Control.MOUSE_FILTER_IGNORE to prevent blocking the mouse from dragging if desired.

Warning: These are required internal nodes, removing or freeing them may cause a crash.

---

## Theme Property Descriptions

Color touch_dragger_color = Color(1, 1, 1, 0.3) 

The color of the touch dragger.

---

Color touch_dragger_hover_color = Color(1, 1, 1, 0.6) 

The color of the touch dragger when hovered.

---

Color touch_dragger_pressed_color = Color(1, 1, 1, 1) 

The color of the touch dragger when pressed.

---

int autohide = 1 

Boolean value. If 1 (true), the grabbers will hide automatically when they aren't under the cursor. If 0 (false), the grabbers are always visible. The dragger_visibility must be DRAGGER_VISIBLE.

---

int minimum_grab_thickness = 6 

The minimum thickness of the area users can click on to grab a split bar. This ensures that the split bar can still be dragged if separation or h_grabber / v_grabber's size is too narrow to easily select.

---

int separation = 12 

The split bar thickness, i.e., the gap between each child of the container. This is overridden by the size of the grabber icon if dragger_visibility is set to DRAGGER_VISIBLE, or DRAGGER_HIDDEN, and separation is smaller than the size of the grabber icon in the same axis.

Note: To obtain separation values less than the size of the grabber icon, for example a 1 px hairline, set h_grabber or v_grabber to a new ImageTexture, which effectively sets the grabber icon size to 0 px.

---

Texture2D grabber 

The icon used for the grabbers drawn in the separations. This is only used in HSplitContainer and VSplitContainer. For SplitContainer, see h_grabber and v_grabber instead.

---

Texture2D h_grabber 

The icon used for the grabbers drawn in the separations when vertical is false.

---

Texture2D h_touch_dragger 

The icon used for the drag handle when touch_dragger_enabled is true and vertical is false.

---

Texture2D touch_dragger 

The icon used for the drag handle when touch_dragger_enabled is true. This is only used in HSplitContainer and VSplitContainer. For SplitContainer, see h_touch_dragger and v_touch_dragger instead.

---

Texture2D v_grabber 

The icon used for the grabbers drawn in the separations when vertical is true.

---

Texture2D v_touch_dragger 

The icon used for the drag handle when touch_dragger_enabled is true and vertical is true.

---

StyleBox split_bar_background 

Determines the background of the split bar if its thickness is greater than zero.
