# EditorToaster

Inherits: HBoxContainer < BoxContainer < Container < Control < CanvasItem < Node < Object

Manages toast notifications within the editor.

## Description

This object manages the functionality and display of toast notifications within the editor, ensuring immediate and informative alerts are presented to the user.

Note: This class shouldn't be instantiated directly. Instead, access the singleton using EditorInterface.get_editor_toaster().

## Methods

void | push_toast(message: String, severity: Severity = 0, tooltip: String = "")

---

## Enumerations

enum Severity
Severity SEVERITY_INFO = 0

Toast will display with an INFO severity.

Severity SEVERITY_WARNING = 1

Toast will display with a WARNING severity and have a corresponding color.

Severity SEVERITY_ERROR = 2

Toast will display with an ERROR severity and have a corresponding color.

---

## Method Descriptions

void push_toast(message: String, severity: Severity = 0, tooltip: String = "") 

Pushes a toast notification to the editor for display.
