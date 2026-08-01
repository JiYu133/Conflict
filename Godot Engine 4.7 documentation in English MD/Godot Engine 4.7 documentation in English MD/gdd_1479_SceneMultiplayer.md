# SceneMultiplayer

Inherits: MultiplayerAPI < RefCounted < Object

High-level multiplayer API implementation.

## Description

This class is the default implementation of MultiplayerAPI, used to provide multiplayer functionalities in Godot Engine.

This implementation supports RPCs via Node.rpc() and Node.rpc_id() and requires MultiplayerAPI.rpc() to be passed a Node (it will fail for other object types).

This implementation additionally provide SceneTree replication via the MultiplayerSpawner and MultiplayerSynchronizer nodes, and the SceneReplicationConfig resource.

Note: The high-level multiplayer API protocol is an implementation detail and isn't meant to be used by non-Godot servers. It may change without notice.

Note: When exporting to Android, make sure to enable the INTERNET permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

## Properties

bool | allow_object_decoding | false
Callable | auth_callback | Callable()
float | auth_timeout | 3.0
int | max_delta_packet_size | 65535
int | max_sync_packet_size | 1350
bool | refuse_new_connections | false
NodePath | root_path | NodePath("")
bool | server_relay | true

## Methods

void | clear()
Error | complete_auth(id: int)
void | disconnect_peer(id: int)
PackedInt32Array | get_authenticating_peers()
Error | send_auth(id: int, data: PackedByteArray)
Error | send_bytes(bytes: PackedByteArray, id: int = 0, mode: TransferMode = 2, channel: int = 0)

---

## Signals

peer_authenticating(id: int) 

Emitted when this MultiplayerAPI's MultiplayerAPI.multiplayer_peer connects to a new peer and a valid auth_callback is set. In this case, the MultiplayerAPI.peer_connected will not be emitted until complete_auth() is called with given peer id. While in this state, the peer will not be included in the list returned by MultiplayerAPI.get_peers() (but in the one returned by get_authenticating_peers()), and only authentication data will be sent or received. See send_auth() for sending authentication data.

---

peer_authentication_failed(id: int) 

Emitted when this MultiplayerAPI's MultiplayerAPI.multiplayer_peer disconnects from a peer for which authentication had not yet completed. See peer_authenticating.

---

peer_packet(id: int, packet: PackedByteArray) 

Emitted when this MultiplayerAPI's MultiplayerAPI.multiplayer_peer receives a packet with custom data (see send_bytes()). ID is the peer ID of the peer that sent the packet.

---

## Property Descriptions

bool allow_object_decoding = false 

- void set_allow_object_decoding(value: bool)
- bool is_object_decoding_allowed()

If true, the MultiplayerAPI will allow encoding and decoding of object during RPCs.

Warning: Deserialized objects can contain code which gets executed. Do not use this option if the serialized object comes from untrusted sources to avoid potential security threat such as remote code execution.

---

Callable auth_callback = Callable() 

- void set_auth_callback(value: Callable)
- Callable get_auth_callback()

The callback to execute when receiving authentication data sent via send_auth(). If the Callable is empty (default), peers will be automatically accepted as soon as they connect.

---

float auth_timeout = 3.0 

- void set_auth_timeout(value: float)
- float get_auth_timeout()

If set to a value greater than 0.0, the maximum duration in seconds peers can stay in the authenticating state, after which the authentication will automatically fail. See the peer_authenticating and peer_authentication_failed signals.

---

int max_delta_packet_size = 65535 

- void set_max_delta_packet_size(value: int)
- int get_max_delta_packet_size()

Maximum size of each delta packet. Higher values increase the chance of receiving full updates in a single frame, but also the chance of causing networking congestion (higher latency, disconnections). See MultiplayerSynchronizer.

---

int max_sync_packet_size = 1350 

- void set_max_sync_packet_size(value: int)
- int get_max_sync_packet_size()

Maximum size of each synchronization packet. Higher values increase the chance of receiving full updates in a single frame, but also the chance of packet loss. See MultiplayerSynchronizer.

---

bool refuse_new_connections = false 

- void set_refuse_new_connections(value: bool)
- bool is_refusing_new_connections()

If true, the MultiplayerAPI's MultiplayerAPI.multiplayer_peer refuses new incoming connections.

---

NodePath root_path = NodePath("") 

- void set_root_path(value: NodePath)
- NodePath get_root_path()

The root path to use for RPCs and replication. Instead of an absolute path, a relative path will be used to find the node upon which the RPC should be executed.

This effectively allows to have different branches of the scene tree to be managed by different MultiplayerAPI, allowing for example to run both client and server in the same scene.

---

bool server_relay = true 

- void set_server_relay_enabled(value: bool)
- bool is_server_relay_enabled()

Enable or disable the server feature that notifies clients of other peers' connection/disconnection, and relays messages between them. When this option is false, clients won't be automatically notified of other peers and won't be able to send them packets through the server.

Note: Changing this option while other peers are connected may lead to unexpected behaviors.

Note: Support for this feature may depend on the current MultiplayerPeer configuration. See MultiplayerPeer.is_server_relay_supported().

---

## Method Descriptions

void clear() 

Clears the current SceneMultiplayer network state (you shouldn't call this unless you know what you are doing).

---

Error complete_auth(id: int) 

Mark the authentication step as completed for the remote peer identified by id. The MultiplayerAPI.peer_connected signal will be emitted for this peer once the remote side also completes the authentication. No further authentication messages are expected to be received from this peer.

If a peer disconnects before completing authentication, either due to a network issue, the auth_timeout expiring, or manually calling disconnect_peer(), the peer_authentication_failed signal will be emitted instead of MultiplayerAPI.peer_disconnected.

---

void disconnect_peer(id: int) 

Disconnects the peer identified by id, removing it from the list of connected peers, and closing the underlying connection with it.

---

PackedInt32Array get_authenticating_peers() 

Returns the IDs of the peers currently trying to authenticate with this MultiplayerAPI.

---

Error send_auth(id: int, data: PackedByteArray) 

Sends the specified data to the remote peer identified by id as part of an authentication message. This can be used to authenticate peers, and control when MultiplayerAPI.peer_connected is emitted (and the remote peer accepted as one of the connected peers).

---

Error send_bytes(bytes: PackedByteArray, id: int = 0, mode: TransferMode = 2, channel: int = 0) 

Sends the given raw bytes to a specific peer identified by id (see MultiplayerPeer.set_target_peer()). Default ID is 0, i.e. broadcast to all peers.
