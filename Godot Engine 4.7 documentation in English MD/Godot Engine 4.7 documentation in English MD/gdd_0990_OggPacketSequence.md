# OggPacketSequence

Inherits: Resource < RefCounted < Object

A sequence of Ogg packets.

## Description

A sequence of Ogg packets.

## Properties

PackedInt64Array | granule_positions | PackedInt64Array()
Array[Array] | packet_data | []
float | sampling_rate | 0.0

## Methods

float | get_length() const

---

## Property Descriptions

PackedInt64Array granule_positions = PackedInt64Array() 

- void set_packet_granule_positions(value: PackedInt64Array)
- PackedInt64Array get_packet_granule_positions()

Contains the granule positions for each page in this packet sequence.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedInt64Array for more details.

---

Array[Array] packet_data = [] 

- void set_packet_data(value: Array[Array])
- Array[Array] get_packet_data()

Contains the raw packets that make up this OggPacketSequence.

---

float sampling_rate = 0.0 

- void set_sampling_rate(value: float)
- float get_sampling_rate()

Holds sample rate information about this sequence. Must be set by another class that actually understands the codec.

---

## Method Descriptions

float get_length() const 

The length of this stream, in seconds.
