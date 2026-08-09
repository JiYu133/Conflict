# ENetMultiplayerPeer

Inherits: MultiplayerPeer < PacketPeer < RefCounted < Object

A MultiplayerPeer implementation using the ENet [http://enet.bespin.org/index.html] library.

## Description

A MultiplayerPeer implementation that should be passed to MultiplayerAPI.multiplayer_peer after being initialized as either a client, server, or mesh. Events can then be handled by connecting to MultiplayerAPI signals. See ENetConnection for more information on the ENet library wrapper.

Note: ENet only uses UDP, not TCP. When forwarding the server port to make your server accessible on the public Internet, you only need to forward the server port in UDP. You can use the UPNP class to try to forward the server port automatically when starting the server.

## Tutorials

- High-level multiplayer
- API documentation on the ENet website [http://enet.bespin.org/usergroup0.html]

## Properties

ENetConnection | host

## Methods

Error | add_mesh_peer(peer_id: int, host: ENetConnection)
Error | create_client(address: String, port: int, channel_count: int = 0, in_bandwidth: int = 0, out_bandwidth: int = 0, local_port: int = 0)
Error | create_mesh(unique_id: int)
Error | create_server(port: int, max_clients: int = 32, max_channels: int = 0, in_bandwidth: int = 0, out_bandwidth: int = 0)
ENetPacketPeer | get_peer(id: int) const
void | set_bind_ip(ip: String)

---

## Property Descriptions

ENetConnection host 

- ENetConnection get_host()

The underlying ENetConnection created after create_client() and create_server().

---

## Method Descriptions

Error add_mesh_peer(peer_id: int, host: ENetConnection) 

Add a new remote peer with the given peer_id connected to the given host.

Note: The host must have exactly one peer in the ENetPacketPeer.STATE_CONNECTED state.

---

Error create_client(address: String, port: int, channel_count: int = 0, in_bandwidth: int = 0, out_bandwidth: int = 0, local_port: int = 0) 

Create client that connects to a server at address using specified port. The given address needs to be either a fully qualified domain name (e.g. "www.example.com") or an IP address in IPv4 or IPv6 format (e.g. "192.168.1.1"). The port is the port the server is listening on. The channel_count parameter can be used to specify the number of ENet channels allocated for the connection. The in_bandwidth and out_bandwidth parameters can be used to limit the incoming and outgoing bandwidth to the given number of bytes per second. The default of 0 means unlimited bandwidth. Note that ENet will strategically drop packets on specific sides of a connection between peers to ensure the peer's bandwidth is not overwhelmed. The bandwidth parameters also determine the window size of a connection which limits the amount of reliable packets that may be in transit at any given time. Returns @GlobalScope.OK if a client was created, @GlobalScope.ERR_ALREADY_IN_USE if this ENetMultiplayerPeer instance already has an open connection (in which case you need to call MultiplayerPeer.close() first) or @GlobalScope.ERR_CANT_CREATE if the client could not be created. If local_port is specified, the client will also listen to the given port; this is useful for some NAT traversal techniques.

---

Error create_mesh(unique_id: int) 

Initialize this MultiplayerPeer in mesh mode. The provided unique_id will be used as the local peer network unique ID once assigned as the MultiplayerAPI.multiplayer_peer. In the mesh configuration you will need to set up each new peer manually using ENetConnection before calling add_mesh_peer(). While this technique is more advanced, it allows for better control over the connection process (e.g. when dealing with NAT punch-through) and for better distribution of the network load (which would otherwise be more taxing on the server).

---

Error create_server(port: int, max_clients: int = 32, max_channels: int = 0, in_bandwidth: int = 0, out_bandwidth: int = 0) 

Create server that listens to connections via port. The port needs to be an available, unused port between 0 and 65535. Note that ports below 1024 are privileged and may require elevated permissions depending on the platform. To change the interface the server listens on, use set_bind_ip(). The default IP is the wildcard "*", which listens on all available interfaces. max_clients is the maximum number of clients that are allowed at once, any number up to 4095 may be used, although the achievable number of simultaneous clients may be far lower and depends on the application. For additional details on the bandwidth parameters, see create_client(). Returns @GlobalScope.OK if a server was created, @GlobalScope.ERR_ALREADY_IN_USE if this ENetMultiplayerPeer instance already has an open connection (in which case you need to call MultiplayerPeer.close() first) or @GlobalScope.ERR_CANT_CREATE if the server could not be created.

---

ENetPacketPeer get_peer(id: int) const 

Returns the ENetPacketPeer associated to the given id.

---

void set_bind_ip(ip: String) 

The IP used when creating a server. This is set to the wildcard "*" by default, which binds to all available interfaces. The given IP needs to be in IPv4 or IPv6 address format, for example: "192.168.1.1".
