# WebRTCDataChannel

Inherits: PacketPeer < RefCounted < Object

Inherited By: WebRTCDataChannelExtension

There is currently no description for this class. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

## Properties

WriteMode | write_mode | 1

## Methods

void | close()
int | get_buffered_amount() const
int | get_id() const
String | get_label() const
int | get_max_packet_life_time() const
int | get_max_retransmits() const
String | get_protocol() const
ChannelState | get_ready_state() const
bool | is_negotiated() const
bool | is_ordered() const
Error | poll()
bool | was_string_packet() const

---

## Enumerations

enum WriteMode
WriteMode WRITE_MODE_TEXT = 0

Tells the channel to send data over this channel as text. An external peer (non-Godot) would receive this as a string.

WriteMode WRITE_MODE_BINARY = 1

Tells the channel to send data over this channel as binary. An external peer (non-Godot) would receive this as array buffer or blob.

---

enum ChannelState
ChannelState STATE_CONNECTING = 0

The channel was created, but it's still trying to connect.

ChannelState STATE_OPEN = 1

The channel is currently open, and data can flow over it.

ChannelState STATE_CLOSING = 2

The channel is being closed, no new messages will be accepted, but those already in queue will be flushed.

ChannelState STATE_CLOSED = 3

The channel was closed, or connection failed.

---

## Property Descriptions

WriteMode write_mode = 1 

- void set_write_mode(value: WriteMode)
- WriteMode get_write_mode()

The transfer mode to use when sending outgoing packet. Either text or binary.

---

## Method Descriptions

void close() 

Closes this data channel, notifying the other peer.

---

int get_buffered_amount() const 

Returns the number of bytes currently queued to be sent over this channel.

---

int get_id() const 

Returns the ID assigned to this channel during creation (or auto-assigned during negotiation).

If the channel is not negotiated out-of-band the ID will only be available after the connection is established (will return 65535 until then).

---

String get_label() const 

Returns the label assigned to this channel during creation.

---

int get_max_packet_life_time() const 

Returns the maxPacketLifeTime value assigned to this channel during creation.

Will be 65535 if not specified.

---

int get_max_retransmits() const 

Returns the maxRetransmits value assigned to this channel during creation.

Will be 65535 if not specified.

---

String get_protocol() const 

Returns the sub-protocol assigned to this channel during creation. An empty string if not specified.

---

ChannelState get_ready_state() const 

Returns the current state of this channel.

---

bool is_negotiated() const 

Returns true if this channel was created with out-of-band configuration.

---

bool is_ordered() const 

Returns true if this channel was created with ordering enabled (default).

---

Error poll() 

Reserved, but not used for now.

---

bool was_string_packet() const 

Returns true if the last received packet was transferred as text. See write_mode.
