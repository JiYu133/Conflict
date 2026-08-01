# Separator

Inherits: Control < CanvasItem < Node < Object

Inherited By: HSeparator, VSeparator

Abstract base class for separators.

## Description

Abstract base class for separators, used for separating other controls. Separators are purely visual and normally drawn as a StyleBoxLine.

## Theme Properties

int | separation | 0
StyleBox | separator |

---

## Theme Property Descriptions

int separation = 0 

The size of the area covered by the separator. Effectively works like a minimum width/height.

---

StyleBox separator 

The style for the separator line. Works best with StyleBoxLine (remember to enable StyleBoxLine.vertical for VSeparator).
