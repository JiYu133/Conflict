# ColorPalette

Inherits: Resource < RefCounted < Object

A resource class for managing a palette of colors, which can be loaded and saved using ColorPicker.

## Description

The ColorPalette resource is designed to store and manage a collection of colors. This resource is useful in scenarios where a predefined set of colors is required, such as for creating themes, designing user interfaces, or managing game assets. The built-in ColorPicker control can also make use of ColorPalette without additional code.

## Properties

PackedColorArray | colors | PackedColorArray()

---

## Property Descriptions

PackedColorArray colors = PackedColorArray() 

- void set_colors(value: PackedColorArray)
- PackedColorArray get_colors()

A PackedColorArray containing the colors in the palette.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedColorArray for more details.
