# PacketPeerDTLS

Inherits: PacketPeer < RefCounted < Object

DTLS packet peer.

## Description

This class represents a DTLS peer connection. It can be used to connect to a DTLS server, and is returned by DTLSServer.take_connection().

Note: When exporting to Android, make sure to enable the INTERNET permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

Warning: TLS certificate revocation and certificate pinning are currently not supported. Revoked certificates are accepted as long as they are otherwise valid. If this is a concern, you may want to use automatically managed certificates with a short validity period.

## Methods

Error | connect_to_peer(packet_peer: PacketPeerUDP, hostname: String, client_options: TLSOptions = null)
void | disconnect_from_peer()
Status | get_status() const
void | poll()

---

## Enumerations

enum Status
Status STATUS_DISCONNECTED = 0

A status representing a PacketPeerDTLS that is disconnected.

Status STATUS_HANDSHAKING = 1

A status representing a PacketPeerDTLS that is currently performing the handshake with a remote peer.

Status STATUS_CONNECTED = 2

A status representing a PacketPeerDTLS that is connected to a remote peer.

Status STATUS_ERROR = 3

A status representing a PacketPeerDTLS in a generic error state.

Status STATUS_ERROR_HOSTNAME_MISMATCH = 4

An error status that shows a mismatch in the DTLS certificate domain presented by the host and the domain requested for validation.

---

## Method Descriptions

Error connect_to_peer(packet_peer: PacketPeerUDP, hostname: String, client_options: TLSOptions = null) 

Connects a packet_peer beginning the DTLS handshake using the underlying PacketPeerUDP which must be connected (see PacketPeerUDP.connect_to_host()). You can optionally specify the client_options to be used while verifying the TLS connections. See TLSOptions.client() and TLSOptions.client_unsafe().

---

void disconnect_from_peer() 

Disconnects this peer, terminating the DTLS session.

---

Status get_status() const 

Returns the status of the connection.

---

void poll() 

Poll the connection to check for incoming packets. Call this frequently to update the status and keep the connection working.
