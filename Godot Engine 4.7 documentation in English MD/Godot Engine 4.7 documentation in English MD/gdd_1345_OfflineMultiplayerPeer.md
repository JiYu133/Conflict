# OfflineMultiplayerPeer

Inherits: MultiplayerPeer < PacketPeer < RefCounted < Object

A MultiplayerPeer which is always connected and acts as a server.

## Description

This is the default MultiplayerAPI.multiplayer_peer for the Node.multiplayer. It mimics the behavior of a server with no peers connected.

This means that the SceneTree will act as the multiplayer authority by default. Calls to MultiplayerAPI.is_server() will return true, and calls to MultiplayerAPI.get_unique_id() will return MultiplayerPeer.TARGET_PEER_SERVER.
