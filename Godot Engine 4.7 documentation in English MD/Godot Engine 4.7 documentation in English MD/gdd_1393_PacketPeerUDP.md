# PacketPeerUDP

Inherits: PacketPeer < RefCounted < Object

UDP packet peer.

## Description

UDP packet peer. Can be used to send and receive raw UDP packets as well as Variants.

Example: Send a packet:

```gdscript
var peer = PacketPeerUDP.new()
# Optionally, you can select the local port used to send the packet.
peer.bind(4444)
peer.set_dest_address("1.1.1.1", 4433)
peer.put_packet("hello".to_utf8_buffer())
```

Example: Listen for packets:

```gdscript
var peer
func _ready():
    peer = PacketPeerUDP.new()
    peer.bind(4433)
func _process(_delta):
    if peer.get_available_packet_count() > 0:
        var array_bytes = peer.get_packet()
        var packet_string = array_bytes.get_string_from_ascii()
        print("Received message: ", packet_string)
```

Note: When exporting to Android, make sure to enable the INTERNET permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

## Methods

Error | bind(port: int, bind_address: String = "*", recv_buf_size: int = 65536)
void | close()
Error | connect_to_host(host: String, port: int)
int | get_local_port() const
String | get_packet_ip() const
int | get_packet_port() const
bool | is_bound() const
bool | is_socket_connected() const
Error | join_multicast_group(multicast_address: String, interface_name: String)
Error | leave_multicast_group(multicast_address: String, interface_name: String)
void | set_broadcast_enabled(enabled: bool)
Error | set_dest_address(host: String, port: int)
Error | wait()

---

## Method Descriptions

Error bind(port: int, bind_address: String = "*", recv_buf_size: int = 65536) 

Binds this PacketPeerUDP to the specified port and bind_address with a buffer size recv_buf_size, allowing it to receive incoming packets.

If bind_address is set to "*" (default), the peer will be bound on all available addresses (both IPv4 and IPv6).

If bind_address is set to "0.0.0.0" (for IPv4) or "::" (for IPv6), the peer will be bound to all available addresses matching that IP type.

If bind_address is set to any valid address (e.g. "192.168.1.101", "::1", etc.), the peer will only be bound to the interface with that address (or fail if no interface with the given address exists).

---

void close() 

Closes the PacketPeerUDP's underlying UDP socket.

---

Error connect_to_host(host: String, port: int) 

Calling this method connects this UDP peer to the given host/port pair. UDP is in reality connectionless, so this option only means that incoming packets from different addresses are automatically discarded, and that outgoing packets are always sent to the connected address (future calls to set_dest_address() are not allowed). This method does not send any data to the remote peer, to do that, use PacketPeer.put_var() or PacketPeer.put_packet() as usual. See also UDPServer.

Note: Connecting to the remote peer does not help to protect from malicious attacks like IP spoofing, etc. Think about using an encryption technique like TLS or DTLS if you feel like your application is transferring sensitive information.

---

int get_local_port() const 

Returns the local port to which this peer is bound.

---

String get_packet_ip() const 

Returns the IP of the remote peer that sent the last packet(that was received with PacketPeer.get_packet() or PacketPeer.get_var()).

---

int get_packet_port() const 

Returns the port of the remote peer that sent the last packet(that was received with PacketPeer.get_packet() or PacketPeer.get_var()).

---

bool is_bound() const 

Returns whether this PacketPeerUDP is bound to an address and can receive packets.

---

bool is_socket_connected() const 

Returns true if the UDP socket is open and has been connected to a remote address. See connect_to_host().

---

Error join_multicast_group(multicast_address: String, interface_name: String) 

Joins the multicast group specified by multicast_address using the interface identified by interface_name.

You can join the same multicast group with multiple interfaces. Use IP.get_local_interfaces() to know which are available.

Note: Some Android devices might require the CHANGE_WIFI_MULTICAST_STATE permission for multicast to work.

---

Error leave_multicast_group(multicast_address: String, interface_name: String) 

Removes the interface identified by interface_name from the multicast group specified by multicast_address.

---

void set_broadcast_enabled(enabled: bool) 

Enable or disable sending of broadcast packets (e.g. set_dest_address("255.255.255.255", 4343). This option is disabled by default.

Note: Some Android devices might require the CHANGE_WIFI_MULTICAST_STATE permission and this option to be enabled to receive broadcast packets too.

---

Error set_dest_address(host: String, port: int) 

Sets the destination address and port for sending packets and variables. A hostname will be resolved using DNS if needed.

Note: set_broadcast_enabled() must be enabled before sending packets to a broadcast address (e.g. 255.255.255.255).

---

Error wait() 

Waits for a packet to arrive on the bound address. See bind().

Note: wait() can't be interrupted once it has been called. This can be worked around by allowing the other party to send a specific "death pill" packet like this:

```
socket = PacketPeerUDP.new()
# Server
socket.set_dest_address("127.0.0.1", 789)
socket.put_packet("Time to stop".to_ascii_buffer())
# Client
while socket.wait() == OK:
    var data = socket.get_packet().get_string_from_ascii()
    if data == "Time to stop":
        return
```

```
var socket = new PacketPeerUdp();
// Server
socket.SetDestAddress("127.0.0.1", 789);
socket.PutPacket("Time to stop".ToAsciiBuffer());
// Client
while (socket.Wait() == OK)
{
    string data = socket.GetPacket().GetStringFromASCII();
    if (data == "Time to stop")
    {
        return;
    }
}
```
