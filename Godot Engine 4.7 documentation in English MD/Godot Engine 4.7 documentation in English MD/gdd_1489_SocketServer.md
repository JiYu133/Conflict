# SocketServer

Inherits: RefCounted < Object

Inherited By: TCPServer, UDSServer

An abstract class for servers based on sockets.

## Description

A socket server.

## Methods

bool | is_connection_available() const
bool | is_listening() const
void | stop()
StreamPeerSocket | take_socket_connection()

---

## Method Descriptions

bool is_connection_available() const 

Returns true if a connection is available for taking.

---

bool is_listening() const 

Returns true if the server is currently listening for connections.

---

void stop() 

Stops listening.

---

StreamPeerSocket take_socket_connection() 

If a connection is available, returns a StreamPeerSocket with the connection.
