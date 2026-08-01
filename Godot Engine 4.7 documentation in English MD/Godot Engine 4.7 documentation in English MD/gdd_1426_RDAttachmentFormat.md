# RDAttachmentFormat

Inherits: RefCounted < Object

Attachment format (used by RenderingDevice).

## Description

This object is used by RenderingDevice.

## Properties

DataFormat | format | 36
TextureSamples | samples | 0
int | usage_flags | 0

---

## Property Descriptions

DataFormat format = 36 

- void set_format(value: DataFormat)
- DataFormat get_format()

The attachment's data format.

---

TextureSamples samples = 0 

- void set_samples(value: TextureSamples)
- TextureSamples get_samples()

The number of samples used when sampling the attachment.

---

int usage_flags = 0 

- void set_usage_flags(value: int)
- int get_usage_flags()

The attachment's usage flags, which determine what can be done with it.
