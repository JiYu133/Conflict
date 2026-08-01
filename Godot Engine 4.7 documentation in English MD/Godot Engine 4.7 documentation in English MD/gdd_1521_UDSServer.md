# UDSServer

Inherits: SocketServer < RefCounted < Object

A Unix Domain Socket (UDS) server.

## Description

A Unix Domain Socket (UDS) server. Listens to connections on a socket path and returns a StreamPeerUDS when it gets an incoming connection. Unix Domain Sockets provide inter-process communication on the same machine using the filesystem namespace.

Note: Unix Domain Sockets are only available on Unix-like systems (Linux, macOS, etc.) and are not supported on Windows.

## Methods

Error | listen(path: String)
StreamPeerUDS | take_connection()

---

## Method Descriptions

Error listen(path: String) 

Listens on the socket at path. The socket file will be created at the specified path.

Note: The socket file must not already exist at the specified path. You may need to remove any existing socket file before calling this method.

---

StreamPeerUDS take_connection() 

If a connection is available, returns a StreamPeerUDS with the connection.
