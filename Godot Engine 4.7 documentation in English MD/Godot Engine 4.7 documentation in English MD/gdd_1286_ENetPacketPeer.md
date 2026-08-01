# ENetPacketPeer

Inherits: PacketPeer < RefCounted < Object

A wrapper class for an ENetPeer [http://enet.bespin.org/group__peer.html].

## Description

A PacketPeer implementation representing a peer of an ENetConnection.

This class cannot be instantiated directly but can be retrieved during ENetConnection.service() or via ENetConnection.get_peers().

Note: When exporting to Android, make sure to enable the INTERNET permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

## Tutorials

- API documentation on the ENet website [http://enet.bespin.org/usergroup0.html]

## Methods

int | get_channels() const
int | get_packet_flags() const
String | get_remote_address() const
int | get_remote_port() const
PeerState | get_state() const
float | get_statistic(statistic: PeerStatistic)
bool | is_active() const
void | peer_disconnect(data: int = 0)
void | peer_disconnect_later(data: int = 0)
void | peer_disconnect_now(data: int = 0)
void | ping()
void | ping_interval(ping_interval: int)
void | reset()
Error | send(channel: int, packet: PackedByteArray, flags: int)
void | set_timeout(timeout: int, timeout_min: int, timeout_max: int)
void | throttle_configure(interval: int, acceleration: int, deceleration: int)

---

## Enumerations

enum PeerState
PeerState STATE_DISCONNECTED = 0

The peer is disconnected.

PeerState STATE_CONNECTING = 1

The peer is currently attempting to connect.

PeerState STATE_ACKNOWLEDGING_CONNECT = 2

The peer has acknowledged the connection request.

PeerState STATE_CONNECTION_PENDING = 3

The peer is currently connecting.

PeerState STATE_CONNECTION_SUCCEEDED = 4

The peer has successfully connected, but is not ready to communicate with yet (STATE_CONNECTED).

PeerState STATE_CONNECTED = 5

The peer is currently connected and ready to communicate with.

PeerState STATE_DISCONNECT_LATER = 6

The peer is expected to disconnect after it has no more outgoing packets to send.

PeerState STATE_DISCONNECTING = 7

The peer is currently disconnecting.

PeerState STATE_ACKNOWLEDGING_DISCONNECT = 8

The peer has acknowledged the disconnection request.

PeerState STATE_ZOMBIE = 9

The peer has lost connection, but is not considered truly disconnected (as the peer didn't acknowledge the disconnection request).

---

enum PeerStatistic
PeerStatistic PEER_PACKET_LOSS = 0

Mean packet loss of reliable packets as a ratio with respect to the PACKET_LOSS_SCALE.

PeerStatistic PEER_PACKET_LOSS_VARIANCE = 1

Packet loss variance.

PeerStatistic PEER_PACKET_LOSS_EPOCH = 2

The time at which packet loss statistics were last updated (in milliseconds since the connection started). The interval for packet loss statistics updates is 10 seconds, and at least one packet must have been sent since the last statistics update.

PeerStatistic PEER_ROUND_TRIP_TIME = 3

Mean packet round trip time for reliable packets.

PeerStatistic PEER_ROUND_TRIP_TIME_VARIANCE = 4

Variance of the mean round trip time.

PeerStatistic PEER_LAST_ROUND_TRIP_TIME = 5

Last recorded round trip time for a reliable packet.

PeerStatistic PEER_LAST_ROUND_TRIP_TIME_VARIANCE = 6

Variance of the last trip time recorded.

PeerStatistic PEER_PACKET_THROTTLE = 7

The peer's current throttle status.

PeerStatistic PEER_PACKET_THROTTLE_LIMIT = 8

The maximum number of unreliable packets that should not be dropped. This value is always greater than or equal to 1. The initial value is equal to PACKET_THROTTLE_SCALE.

PeerStatistic PEER_PACKET_THROTTLE_COUNTER = 9

Internal value used to increment the packet throttle counter. The value is hardcoded to 7 and cannot be changed. You probably want to look at PEER_PACKET_THROTTLE_ACCELERATION instead.

PeerStatistic PEER_PACKET_THROTTLE_EPOCH = 10

The time at which throttle statistics were last updated (in milliseconds since the connection started). The interval for throttle statistics updates is PEER_PACKET_THROTTLE_INTERVAL.

PeerStatistic PEER_PACKET_THROTTLE_ACCELERATION = 11

The throttle's acceleration factor. Higher values will make ENet adapt to fluctuating network conditions faster, causing unrelaible packets to be sent more often. The default value is 2.

PeerStatistic PEER_PACKET_THROTTLE_DECELERATION = 12

The throttle's deceleration factor. Higher values will make ENet adapt to fluctuating network conditions faster, causing unrelaible packets to be sent less often. The default value is 2.

PeerStatistic PEER_PACKET_THROTTLE_INTERVAL = 13

The interval over which the lowest mean round trip time should be measured for use by the throttle mechanism (in milliseconds). The default value is 5000.

---

## Constants

PACKET_LOSS_SCALE = 65536 

The reference scale for packet loss. See get_statistic() and PEER_PACKET_LOSS.

PACKET_THROTTLE_SCALE = 32 

The reference value for throttle configuration. The default value is 32. See throttle_configure().

FLAG_RELIABLE = 1 

Mark the packet to be sent as reliable.

FLAG_UNSEQUENCED = 2 

Mark the packet to be sent unsequenced (unreliable).

FLAG_UNRELIABLE_FRAGMENT = 8 

Mark the packet to be sent unreliable even if the packet is too big and needs fragmentation (increasing the chance of it being dropped).

---

## Method Descriptions

int get_channels() const 

Returns the number of channels allocated for communication with peer.

---

int get_packet_flags() const 

Returns the ENet flags of the next packet in the received queue. See FLAG_* constants for available packet flags. Note that not all flags are replicated from the sending peer to the receiving peer.

---

String get_remote_address() const 

Returns the IP address of this peer.

---

int get_remote_port() const 

Returns the remote port of this peer.

---

PeerState get_state() const 

Returns the current peer state.

---

float get_statistic(statistic: PeerStatistic) 

Returns the requested statistic for this peer.

---

bool is_active() const 

Returns true if the peer is currently active (i.e. the associated ENetConnection is still valid).

---

void peer_disconnect(data: int = 0) 

Request a disconnection from a peer. An ENetConnection.EVENT_DISCONNECT will be generated during ENetConnection.service() once the disconnection is complete.

---

void peer_disconnect_later(data: int = 0) 

Request a disconnection from a peer, but only after all queued outgoing packets are sent. An ENetConnection.EVENT_DISCONNECT will be generated during ENetConnection.service() once the disconnection is complete.

---

void peer_disconnect_now(data: int = 0) 

Force an immediate disconnection from a peer. No ENetConnection.EVENT_DISCONNECT will be generated. The foreign peer is not guaranteed to receive the disconnect notification, and is reset immediately upon return from this function.

---

void ping() 

Sends a ping request to a peer. ENet automatically pings all connected peers at regular intervals, however, this function may be called to ensure more frequent ping requests.

---

void ping_interval(ping_interval: int) 

Sets the ping_interval in milliseconds at which pings will be sent to a peer. Pings are used both to monitor the liveness of the connection and also to dynamically adjust the throttle during periods of low traffic so that the throttle has reasonable responsiveness during traffic spikes. The default ping interval is 500 milliseconds.

---

void reset() 

Forcefully disconnects a peer. The foreign host represented by the peer is not notified of the disconnection and will timeout on its connection to the local host.

---

Error send(channel: int, packet: PackedByteArray, flags: int) 

Queues a packet to be sent over the specified channel. See FLAG_* constants for available packet flags.

---

void set_timeout(timeout: int, timeout_min: int, timeout_max: int) 

Sets the timeout parameters for a peer. The timeout parameters control how and when a peer will timeout from a failure to acknowledge reliable traffic. Timeout values are expressed in milliseconds.

The timeout is a factor that, multiplied by a value based on the average round trip time, will determine the timeout limit for a reliable packet. When that limit is reached, the timeout will be doubled, and the peer will be disconnected if that limit has reached timeout_min. The timeout_max parameter, on the other hand, defines a fixed timeout for which any packet must be acknowledged or the peer will be dropped.

---

void throttle_configure(interval: int, acceleration: int, deceleration: int) 

Configures throttle parameter for a peer.

Unreliable packets are dropped by ENet in response to the varying conditions of the Internet connection to the peer. The throttle represents a probability that an unreliable packet should not be dropped and thus sent by ENet to the peer. By measuring fluctuations in round trip times of reliable packets over the specified interval, ENet will either increase the probability by the amount specified in the acceleration parameter, or decrease it by the amount specified in the deceleration parameter (both are ratios to PACKET_THROTTLE_SCALE).

When the throttle has a value of PACKET_THROTTLE_SCALE, no unreliable packets are dropped by ENet, and so 100% of all unreliable packets will be sent.

When the throttle has a value of 0, all unreliable packets are dropped by ENet, and so 0% of all unreliable packets will be sent.

Intermediate values for the throttle represent intermediate probabilities between 0% and 100% of unreliable packets being sent. The bandwidth limits of the local and foreign hosts are taken into account to determine a sensible limit for the throttle probability above which it should not raise even in the best of conditions.
