# MultiplayerPeer

Inherits: PacketPeer < RefCounted < Object

Inherited By: ENetMultiplayerPeer, MultiplayerPeerExtension, OfflineMultiplayerPeer, WebRTCMultiplayerPeer, WebSocketMultiplayerPeer

Abstract class for specialized PacketPeers used by the MultiplayerAPI.

## Description

Manages the connection with one or more remote peers acting as server or client and assigning unique IDs to each of them. See also MultiplayerAPI.

Note: The MultiplayerAPI protocol is an implementation detail and isn't meant to be used by non-Godot servers. It may change without notice.

Note: When exporting to Android, make sure to enable the INTERNET permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

## Tutorials

- High-level multiplayer

## Properties

bool | refuse_new_connections | false
int | transfer_channel | 0
TransferMode | transfer_mode | 2

## Methods

void | close()
void | disconnect_peer(peer: int, force: bool = false)
int | generate_unique_id() const
ConnectionStatus | get_connection_status() const
int | get_packet_channel() const
TransferMode | get_packet_mode() const
int | get_packet_peer() const
int | get_unique_id() const
bool | is_server_relay_supported() const
void | poll()
void | set_target_peer(id: int)

---

## Signals

peer_connected(id: int) 

Emitted when a remote peer connects.

---

peer_disconnected(id: int) 

Emitted when a remote peer has disconnected.

---

## Enumerations

enum ConnectionStatus
ConnectionStatus CONNECTION_DISCONNECTED = 0

The MultiplayerPeer is disconnected.

ConnectionStatus CONNECTION_CONNECTING = 1

The MultiplayerPeer is currently connecting to a server.

ConnectionStatus CONNECTION_CONNECTED = 2

This MultiplayerPeer is connected.

---

enum TransferMode
TransferMode TRANSFER_MODE_UNRELIABLE = 0

Packets are not acknowledged, no resend attempts are made for lost packets. Packets may arrive in any order. Potentially faster than TRANSFER_MODE_UNRELIABLE_ORDERED. Use for non-critical data, and always consider whether the order matters.

TransferMode TRANSFER_MODE_UNRELIABLE_ORDERED = 1

Packets are not acknowledged, no resend attempts are made for lost packets. Packets are received in the order they were sent in. Potentially faster than TRANSFER_MODE_RELIABLE. Use for non-critical data or data that would be outdated if received late due to resend attempt(s) anyway, for example movement and positional data.

TransferMode TRANSFER_MODE_RELIABLE = 2

Packets must be received and resend attempts should be made until the packets are acknowledged. Packets must be received in the order they were sent in. Most reliable transfer mode, but potentially the slowest due to the overhead. Use for critical data that must be transmitted and arrive in order, for example an ability being triggered or a chat message. Consider carefully if the information really is critical, and use sparingly.

---

## Constants

TARGET_PEER_BROADCAST = 0 

Packets are sent to all connected peers.

TARGET_PEER_SERVER = 1 

Packets are sent to the remote peer acting as server.

---

## Property Descriptions

bool refuse_new_connections = false 

- void set_refuse_new_connections(value: bool)
- bool is_refusing_new_connections()

If true, this MultiplayerPeer refuses new connections.

---

int transfer_channel = 0 

- void set_transfer_channel(value: int)
- int get_transfer_channel()

The channel to use to send packets. Many network APIs such as ENet and WebRTC allow the creation of multiple independent channels which behaves, in a way, like separate connections. This means that reliable data will only block delivery of other packets on that channel, and ordering will only be in respect to the channel the packet is being sent on. Using different channels to send different and independent state updates is a common way to optimize network usage and decrease latency in fast-paced games.

Note: The default channel (0) actually works as 3 separate channels (one for each TransferMode) so that TRANSFER_MODE_RELIABLE and TRANSFER_MODE_UNRELIABLE_ORDERED does not interact with each other by default. Refer to the specific network API documentation (e.g. ENet or WebRTC) to learn how to set up channels correctly.

---

TransferMode transfer_mode = 2 

- void set_transfer_mode(value: TransferMode)
- TransferMode get_transfer_mode()

The manner in which to send packets to the target peer. See the set_target_peer() method.

---

## Method Descriptions

void close() 

Immediately close the multiplayer peer returning to the state CONNECTION_DISCONNECTED. Connected peers will be dropped without emitting peer_disconnected.

---

void disconnect_peer(peer: int, force: bool = false) 

Disconnects the given peer from this host. If force is true the peer_disconnected signal will not be emitted for this peer.

---

int generate_unique_id() const 

Returns a randomly generated integer that can be used as a network unique ID.

---

ConnectionStatus get_connection_status() const 

Returns the current state of the connection.

---

int get_packet_channel() const 

Returns the channel over which the next available packet was received. See PacketPeer.get_available_packet_count().

---

TransferMode get_packet_mode() const 

Returns the transfer mode the remote peer used to send the next available packet. See PacketPeer.get_available_packet_count().

---

int get_packet_peer() const 

Returns the ID of the MultiplayerPeer who sent the next available packet. See PacketPeer.get_available_packet_count().

---

int get_unique_id() const 

Returns the ID of this MultiplayerPeer.

---

bool is_server_relay_supported() const 

Returns true if the server can act as a relay in the current configuration. That is, if the higher level MultiplayerAPI should notify connected clients of other peers, and implement a relay protocol to allow communication between them.

---

void poll() 

Waits up to 1 second to receive a new network event.

---

void set_target_peer(id: int) 

Sets the peer to which packets will be sent.

The id can be one of: TARGET_PEER_BROADCAST to send to all connected peers, TARGET_PEER_SERVER to send to the peer acting as server, a valid peer ID to send to that specific peer, a negative peer ID to send to all peers except that one. By default, the target peer is TARGET_PEER_BROADCAST.
