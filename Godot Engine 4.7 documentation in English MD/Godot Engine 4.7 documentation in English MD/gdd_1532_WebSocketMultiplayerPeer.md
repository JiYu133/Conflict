# WebSocketMultiplayerPeer

Inherits: MultiplayerPeer < PacketPeer < RefCounted < Object

Base class for WebSocket server and client.

## Description

Base class for WebSocket server and client, allowing them to be used as multiplayer peer for the MultiplayerAPI.

Note: When exporting to Android, make sure to enable the INTERNET permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

## Properties

PackedStringArray | handshake_headers | PackedStringArray()
float | handshake_timeout | 3.0
int | inbound_buffer_size | 65535
int | max_queued_packets | 4096
int | outbound_buffer_size | 65535
PackedStringArray | supported_protocols | PackedStringArray()

## Methods

Error | create_client(url: String, tls_client_options: TLSOptions = null)
Error | create_server(port: int, bind_address: String = "*", tls_server_options: TLSOptions = null)
WebSocketPeer | get_peer(peer_id: int) const
String | get_peer_address(id: int) const
int | get_peer_port(id: int) const

---

## Property Descriptions

PackedStringArray handshake_headers = PackedStringArray() 

- void set_handshake_headers(value: PackedStringArray)
- PackedStringArray get_handshake_headers()

The extra headers to use during handshake. See WebSocketPeer.handshake_headers for more details.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedStringArray for more details.

---

float handshake_timeout = 3.0 

- void set_handshake_timeout(value: float)
- float get_handshake_timeout()

The maximum time each peer can stay in a connecting state before being dropped.

---

int inbound_buffer_size = 65535 

- void set_inbound_buffer_size(value: int)
- int get_inbound_buffer_size()

The inbound buffer size for connected peers. See WebSocketPeer.inbound_buffer_size for more details.

---

int max_queued_packets = 4096 

- void set_max_queued_packets(value: int)
- int get_max_queued_packets()

The maximum number of queued packets for connected peers. See WebSocketPeer.max_queued_packets for more details.

---

int outbound_buffer_size = 65535 

- void set_outbound_buffer_size(value: int)
- int get_outbound_buffer_size()

The outbound buffer size for connected peers. See WebSocketPeer.outbound_buffer_size for more details.

---

PackedStringArray supported_protocols = PackedStringArray() 

- void set_supported_protocols(value: PackedStringArray)
- PackedStringArray get_supported_protocols()

The supported WebSocket sub-protocols. See WebSocketPeer.supported_protocols for more details.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedStringArray for more details.

---

## Method Descriptions

Error create_client(url: String, tls_client_options: TLSOptions = null) 

Starts a new multiplayer client connecting to the given url. TLS certificates will be verified against the hostname when connecting using the wss:// protocol. You can pass the optional tls_client_options parameter to customize the trusted certification authorities, or disable the common name verification. See TLSOptions.client() and TLSOptions.client_unsafe().

Note: It is recommended to specify the scheme part of the URL, i.e. the url should start with either ws:// or wss://.

---

Error create_server(port: int, bind_address: String = "*", tls_server_options: TLSOptions = null) 

Starts a new multiplayer server listening on the given port. You can optionally specify a bind_address, and provide valid tls_server_options to use TLS. See TLSOptions.server().

---

WebSocketPeer get_peer(peer_id: int) const 

Returns the WebSocketPeer associated to the given peer_id.

---

String get_peer_address(id: int) const 

Returns the IP address of the given peer.

---

int get_peer_port(id: int) const 

Returns the remote port of the given peer.
