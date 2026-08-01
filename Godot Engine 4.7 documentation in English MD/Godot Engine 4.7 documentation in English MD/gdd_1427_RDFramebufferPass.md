# RDFramebufferPass

Inherits: RefCounted < Object

Framebuffer pass attachment description (used by RenderingDevice).

## Description

This class contains the list of attachment descriptions for a framebuffer pass. Each points with an index to a previously supplied list of texture attachments.

Multipass framebuffers can optimize some configurations in mobile. On desktop, they provide little to no advantage.

This object is used by RenderingDevice.

## Properties

PackedInt32Array | color_attachments | PackedInt32Array()
int | depth_attachment | -1
PackedInt32Array | input_attachments | PackedInt32Array()
PackedInt32Array | preserve_attachments | PackedInt32Array()
PackedInt32Array | resolve_attachments | PackedInt32Array()

---

## Constants

ATTACHMENT_UNUSED = -1 

Attachment is unused.

---

## Property Descriptions

PackedInt32Array color_attachments = PackedInt32Array() 

- void set_color_attachments(value: PackedInt32Array)
- PackedInt32Array get_color_attachments()

Color attachments in order starting from 0. If this attachment is not used by the shader, pass ATTACHMENT_UNUSED to skip.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedInt32Array for more details.

---

int depth_attachment = -1 

- void set_depth_attachment(value: int)
- int get_depth_attachment()

Depth attachment. ATTACHMENT_UNUSED should be used if no depth buffer is required for this pass.

---

PackedInt32Array input_attachments = PackedInt32Array() 

- void set_input_attachments(value: PackedInt32Array)
- PackedInt32Array get_input_attachments()

Used for multipass framebuffers (more than one render pass). Converts an attachment to an input. Make sure to also supply it properly in the RDUniform for the uniform set.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedInt32Array for more details.

---

PackedInt32Array preserve_attachments = PackedInt32Array() 

- void set_preserve_attachments(value: PackedInt32Array)
- PackedInt32Array get_preserve_attachments()

Attachments to preserve in this pass (otherwise they are erased).

Note: The returned array is copied and any changes to it will not update the original property value. See PackedInt32Array for more details.

---

PackedInt32Array resolve_attachments = PackedInt32Array() 

- void set_resolve_attachments(value: PackedInt32Array)
- PackedInt32Array get_resolve_attachments()

If the color attachments are multisampled, non-multisampled resolve attachments can be provided.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedInt32Array for more details.
