# Popup

Inherits: Window < Viewport < Node < Object

Inherited By: PopupMenu, PopupPanel

Base class for contextual windows and panels with fixed position.

## Description

Popup is a base class for contextual windows and panels with fixed position. It's a modal by default (see Window.popup_window) and provides methods for implementing custom popup behavior.

Note: Popup is invisible by default. To make it visible, call one of the popup_* methods from Window on the node, such as Window.popup_centered_clamped().

## Properties

bool | borderless | true (overrides Window)
bool | maximize_disabled | true (overrides Window)
bool | minimize_disabled | true (overrides Window)
bool | popup_window | true (overrides Window)
bool | popup_wm_hint | true (overrides Window)
bool | transient | true (overrides Window)
bool | unresizable | true (overrides Window)
bool | visible | false (overrides Window)
bool | wrap_controls | true (overrides Window)

---

## Signals

popup_hide() 

Emitted when the popup is hidden.
