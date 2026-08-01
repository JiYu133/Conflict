# TCPServer

Inherits: SocketServer < RefCounted < Object

A TCP server.

## Description

A TCP server. Listens to connections on a port and returns a StreamPeerTCP when it gets an incoming connection.

Note: When exporting to Android, make sure to enable the INTERNET permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

## Methods

int | get_local_port() const
Error | listen(port: int, bind_address: String = "*")
StreamPeerTCP | take_connection()

---

## Method Descriptions

int get_local_port() const 

Returns the local port this server is listening to.

---

Error listen(port: int, bind_address: String = "*") 

Listen on the port binding to bind_address.

If bind_address is set as "*" (default), the server will listen on all available addresses (both IPv4 and IPv6).

If bind_address is set as "0.0.0.0" (for IPv4) or "::" (for IPv6), the server will listen on all available addresses matching that IP type.

If bind_address is set to any valid address (e.g. "192.168.1.101", "::1", etc.), the server will only listen on the interface with that address (or fail if no interface with the given address exists).

---

StreamPeerTCP take_connection() 

If a connection is available, returns a StreamPeerTCP with the connection.
