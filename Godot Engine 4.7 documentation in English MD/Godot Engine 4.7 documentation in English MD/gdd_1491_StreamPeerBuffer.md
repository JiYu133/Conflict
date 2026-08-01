# StreamPeerBuffer

Inherits: StreamPeer < RefCounted < Object

A stream peer used to handle binary data streams.

## Description

A data buffer stream peer that uses a byte array as the stream. This object can be used to handle binary data from network sessions. To handle binary data stored in files, FileAccess can be used directly.

A StreamPeerBuffer object keeps an internal cursor which is the offset in bytes to the start of the buffer. Get and put operations are performed at the cursor position and will move the cursor accordingly.

## Properties

PackedByteArray | data_array | PackedByteArray()

## Methods

void | clear()
StreamPeerBuffer | duplicate() const
int | get_position() const
int | get_size() const
void | resize(size: int)
void | seek(position: int)

---

## Property Descriptions

PackedByteArray data_array = PackedByteArray() 

- void set_data_array(value: PackedByteArray)
- PackedByteArray get_data_array()

The underlying data buffer. Setting this value resets the cursor.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedByteArray for more details.

---

## Method Descriptions

void clear() 

Clears the data_array and resets the cursor.

---

StreamPeerBuffer duplicate() const 

Returns a new StreamPeerBuffer with the same data_array content.

---

int get_position() const 

Returns the current cursor position.

---

int get_size() const 

Returns the size of data_array.

---

void resize(size: int) 

Resizes the data_array. This doesn't update the cursor.

---

void seek(position: int) 

Moves the cursor to the specified position. position must be a valid index of data_array.
