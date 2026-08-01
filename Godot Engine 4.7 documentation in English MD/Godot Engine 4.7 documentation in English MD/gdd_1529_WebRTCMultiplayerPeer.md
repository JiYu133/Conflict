# WebRTCMultiplayerPeer

Inherits: MultiplayerPeer < PacketPeer < RefCounted < Object

A simple interface to create a peer-to-peer mesh network composed of WebRTCPeerConnection that is compatible with the MultiplayerAPI.

## Description

This class constructs a full mesh of WebRTCPeerConnection (one connection for each peer) that can be used as a MultiplayerAPI.multiplayer_peer.

You can add each WebRTCPeerConnection via add_peer() or remove them via remove_peer(). Peers must be added in WebRTCPeerConnection.STATE_NEW state to allow it to create the appropriate channels. This class will not create offers nor set descriptions, it will only poll them, and notify connections and disconnections.

When creating the peer via create_client() or create_server() the MultiplayerPeer.is_server_relay_supported() method will return true enabling peer exchange and packet relaying when supported by the MultiplayerAPI implementation.

Note: When exporting to Android, make sure to enable the INTERNET permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

## Methods

Error | add_peer(peer: WebRTCPeerConnection, peer_id: int, unreliable_lifetime: int = 1)
Error | create_client(peer_id: int, channels_config: Array = [])
Error | create_mesh(peer_id: int, channels_config: Array = [])
Error | create_server(channels_config: Array = [])
Dictionary | get_peer(peer_id: int)
Dictionary | get_peers()
bool | has_peer(peer_id: int)
void | remove_peer(peer_id: int)

---

## Method Descriptions

Error add_peer(peer: WebRTCPeerConnection, peer_id: int, unreliable_lifetime: int = 1) 

Add a new peer to the mesh with the given peer_id. The WebRTCPeerConnection must be in state WebRTCPeerConnection.STATE_NEW.

Three channels will be created for reliable, unreliable, and ordered transport. The value of unreliable_lifetime will be passed to the "maxPacketLifetime" option when creating unreliable and ordered channels (see WebRTCPeerConnection.create_data_channel()).

---

Error create_client(peer_id: int, channels_config: Array = []) 

Initialize the multiplayer peer as a client with the given peer_id (must be between 2 and 2147483647). In this mode, you should only call add_peer() once and with peer_id of 1. This mode enables MultiplayerPeer.is_server_relay_supported(), allowing the upper MultiplayerAPI layer to perform peer exchange and packet relaying.

You can optionally specify a channels_config array of TransferMode which will be used to create extra channels (WebRTC only supports one transfer mode per channel).

---

Error create_mesh(peer_id: int, channels_config: Array = []) 

Initialize the multiplayer peer as a mesh (i.e. all peers connect to each other) with the given peer_id (must be between 1 and 2147483647).

---

Error create_server(channels_config: Array = []) 

Initialize the multiplayer peer as a server (with unique ID of 1). This mode enables MultiplayerPeer.is_server_relay_supported(), allowing the upper MultiplayerAPI layer to perform peer exchange and packet relaying.

You can optionally specify a channels_config array of TransferMode which will be used to create extra channels (WebRTC only supports one transfer mode per channel).

---

Dictionary get_peer(peer_id: int) 

Returns a dictionary representation of the peer with given peer_id with three keys. "connection" containing the WebRTCPeerConnection to this peer, "channels" an array of three WebRTCDataChannel, and "connected" a boolean representing if the peer connection is currently connected (all three channels are open).

---

Dictionary get_peers() 

Returns a dictionary which keys are the peer ids and values the peer representation as in get_peer().

---

bool has_peer(peer_id: int) 

Returns true if the given peer_id is in the peers map (it might not be connected though).

---

void remove_peer(peer_id: int) 

Remove the peer with given peer_id from the mesh. If the peer was connected, and MultiplayerPeer.peer_connected was emitted for it, then MultiplayerPeer.peer_disconnected will be emitted.
