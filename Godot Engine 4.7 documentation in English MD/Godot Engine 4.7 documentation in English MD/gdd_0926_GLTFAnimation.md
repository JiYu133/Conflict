# GLTFAnimation

Inherits: Resource < RefCounted < Object

There is currently no description for this class. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

## Tutorials

- Runtime file loading and saving

## Properties

bool | loop | false
String | original_name | ""

## Methods

Variant | get_additional_data(extension_name: StringName)
void | set_additional_data(extension_name: StringName, additional_data: Variant)

---

## Property Descriptions

bool loop = false 

- void set_loop(value: bool)
- bool get_loop()

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

String original_name = "" 

- void set_original_name(value: String)
- String get_original_name()

The original name of the animation.

---

## Method Descriptions

Variant get_additional_data(extension_name: StringName) 

Gets additional arbitrary data in this GLTFAnimation instance. This can be used to keep per-node state data in GLTFDocumentExtension classes, which is important because they are stateless.

The argument should be the GLTFDocumentExtension name (does not have to match the extension name in the glTF file), and the return value can be anything you set. If nothing was set, the return value is null.

---

void set_additional_data(extension_name: StringName, additional_data: Variant) 

Sets additional arbitrary data in this GLTFAnimation instance. This can be used to keep per-node state data in GLTFDocumentExtension classes, which is important because they are stateless.

The first argument should be the GLTFDocumentExtension name (does not have to match the extension name in the glTF file), and the second argument can be anything you want.
