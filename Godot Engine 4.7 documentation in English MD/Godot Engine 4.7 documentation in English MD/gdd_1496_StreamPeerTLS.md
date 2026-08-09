# StreamPeerTLS

Inherits: StreamPeer < RefCounted < Object

A stream peer that handles TLS connections.

## Description

A stream peer that handles TLS connections. This object can be used to connect to a TLS server or accept a single TLS client connection.

Note: When exporting to Android, make sure to enable the INTERNET permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

## Tutorials

- TLS certificates

## Methods

Error | accept_stream(stream: StreamPeer, server_options: TLSOptions)
Error | connect_to_stream(stream: StreamPeer, common_name: String, client_options: TLSOptions = null)
void | disconnect_from_stream()
Status | get_status() const
StreamPeer | get_stream() const
void | poll()

---

## Enumerations

enum Status
Status STATUS_DISCONNECTED = 0

A status representing a StreamPeerTLS that is disconnected.

Status STATUS_HANDSHAKING = 1

A status representing a StreamPeerTLS during handshaking.

Status STATUS_CONNECTED = 2

A status representing a StreamPeerTLS that is connected to a host.

Status STATUS_ERROR = 3

A status representing a StreamPeerTLS in error state.

Status STATUS_ERROR_HOSTNAME_MISMATCH = 4

An error status that shows a mismatch in the TLS certificate domain presented by the host and the domain requested for validation.

---

## Method Descriptions

Error accept_stream(stream: StreamPeer, server_options: TLSOptions) 

Accepts a peer connection as a server using the given server_options. See TLSOptions.server().

---

Error connect_to_stream(stream: StreamPeer, common_name: String, client_options: TLSOptions = null) 

Connects to a peer using an underlying StreamPeer stream and verifying the remote certificate is correctly signed for the given common_name. You can pass the optional client_options parameter to customize the trusted certification authorities, or disable the common name verification. See TLSOptions.client() and TLSOptions.client_unsafe().

---

void disconnect_from_stream() 

Disconnects from host.

---

Status get_status() const 

Returns the status of the connection.

---

StreamPeer get_stream() const 

Returns the underlying StreamPeer connection, used in accept_stream() or connect_to_stream().

---

void poll() 

Poll the connection to check for incoming bytes. Call this right before StreamPeer.get_available_bytes() for it to work properly.
