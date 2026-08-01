# Marshalls

Inherits: Object

Data transformation (marshaling) and encoding helpers.

## Description

Provides data transformation and encoding utility functions.

## Methods

PackedByteArray | base64_to_raw(base64_str: String)
String | base64_to_utf8(base64_str: String)
Variant | base64_to_variant(base64_str: String, allow_objects: bool = false)
String | raw_to_base64(array: PackedByteArray)
String | utf8_to_base64(utf8_str: String)
String | variant_to_base64(variant: Variant, full_objects: bool = false)

---

## Method Descriptions

PackedByteArray base64_to_raw(base64_str: String) 

Returns a decoded PackedByteArray corresponding to the Base64-encoded string base64_str.

---

String base64_to_utf8(base64_str: String) 

Returns a decoded string corresponding to the Base64-encoded string base64_str.

---

Variant base64_to_variant(base64_str: String, allow_objects: bool = false) 

Returns a decoded Variant corresponding to the Base64-encoded string base64_str. If allow_objects is true, decoding objects is allowed.

Internally, this uses the same decoding mechanism as the @GlobalScope.bytes_to_var() method.

Warning: Deserialized objects can contain code which gets executed. Do not use this option if the serialized object comes from untrusted sources to avoid potential security threats such as remote code execution.

---

String raw_to_base64(array: PackedByteArray) 

Returns a Base64-encoded string of a given PackedByteArray.

---

String utf8_to_base64(utf8_str: String) 

Returns a Base64-encoded string of the UTF-8 string utf8_str.

---

String variant_to_base64(variant: Variant, full_objects: bool = false) 

Returns a Base64-encoded string of the Variant variant. If full_objects is true, encoding objects is allowed (and can potentially include code).

Internally, this uses the same encoding mechanism as the @GlobalScope.var_to_bytes() method.
