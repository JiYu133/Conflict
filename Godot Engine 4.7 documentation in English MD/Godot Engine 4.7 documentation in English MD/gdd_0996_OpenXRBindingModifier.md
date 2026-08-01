# OpenXRBindingModifier

Inherits: Resource < RefCounted < Object

Inherited By: OpenXRActionBindingModifier, OpenXRIPBindingModifier

Binding modifier base class.

## Description

Binding modifier base class. Subclasses implement various modifiers that alter how an OpenXR runtime processes inputs.

## Methods

String | _get_description() virtual required const
PackedByteArray | _get_ip_modification() virtual required

---

## Method Descriptions

String _get_description() virtual required const 

Return the description of this class that is used for the title bar of the binding modifier editor.

---

PackedByteArray _get_ip_modification() virtual required 

Returns the data that is sent to OpenXR when submitting the suggested interacting bindings this modifier is a part of.

Note: This must be data compatible with an XrBindingModificationBaseHeaderKHR structure.
