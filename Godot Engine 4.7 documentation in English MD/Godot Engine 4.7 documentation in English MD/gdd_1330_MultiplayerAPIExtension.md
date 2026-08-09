# MultiplayerAPIExtension

Inherits: MultiplayerAPI < RefCounted < Object

Base class used for extending the MultiplayerAPI.

## Description

This class can be used to extend or replace the default MultiplayerAPI implementation via script or extensions.

The following example extend the default implementation (SceneMultiplayer) by logging every RPC being made, and every object being configured for replication.

```
extends MultiplayerAPIExtension
class_name LogMultiplayer
# We want to extend the default SceneMultiplayer.
var base_multiplayer = SceneMultiplayer.new()
func _init():
    # Just passthrough base signals (copied to var to avoid cyclic reference)
    var cts = connected_to_server
    var cf = connection_failed
    var sd = server_disconnected
    var pc = peer_connected
    var pd = peer_disconnected
    base_multiplayer.connected_to_server.connect(func(): cts.emit())
    base_multiplayer.connection_failed.connect(func(): cf.emit())
    base_multiplayer.server_disconnected.connect(func(): sd.emit())
    base_multiplayer.peer_connected.connect(func(id): pc.emit(id))
    base_multiplayer.peer_disconnected.connect(func(id): pd.emit(id))
func _poll():
    return base_multiplayer.poll()
# Log RPC being made and forward it to the default multiplayer.
func _rpc(peer: int, object: Object, method: StringName, args: Array) -> Error:
    print("Got RPC for %d: %s::%s(%s)" % [peer, object, method, args])
    return base_multiplayer.rpc(peer, object, method, args)
# Log configuration add. E.g. root path (nullptr, NodePath), replication (Node, Spawner|Synchronizer), custom.
func _object_configuration_add(object, config: Variant) -> Error:
    if config is MultiplayerSynchronizer:
        print("Adding synchronization configuration for %s. Synchronizer: %s" % [object, config])
    elif config is MultiplayerSpawner:
        print("Adding node %s to the spawn list. Spawner: %s" % [object, config])
    return base_multiplayer.object_configuration_add(object, config)
# Log configuration remove. E.g. root path (nullptr, NodePath), replication (Node, Spawner|Synchronizer), custom.
func _object_configuration_remove(object, config: Variant) -> Error:
    if config is MultiplayerSynchronizer:
        print("Removing synchronization configuration for %s. Synchronizer: %s" % [object, config])
    elif config is MultiplayerSpawner:
        print("Removing node %s from the spawn list. Spawner: %s" % [object, config])
    return base_multiplayer.object_configuration_remove(object, config)
# These can be optional, but in our case we want to extend SceneMultiplayer, so forward everything.
func _set_multiplayer_peer(p_peer: MultiplayerPeer):
    base_multiplayer.multiplayer_peer = p_peer
func _get_multiplayer_peer() -> MultiplayerPeer:
    return base_multiplayer.multiplayer_peer
func _get_unique_id() -> int:
    return base_multiplayer.get_unique_id()
func _get_remote_sender_id() -> int:
    return base_multiplayer.get_remote_sender_id()
func _get_peer_ids() -> PackedInt32Array:
    return base_multiplayer.get_peers()
```

Then in your main scene or in an autoload call SceneTree.set_multiplayer() to start using your custom MultiplayerAPI:

```
# autoload.gd
func _enter_tree():
    # Sets our custom multiplayer as the main one in SceneTree.
    get_tree().set_multiplayer(LogMultiplayer.new())
```

Native extensions can alternatively use the MultiplayerAPI.set_default_interface() method during initialization to configure themselves as the default implementation.

## Methods

MultiplayerPeer | _get_multiplayer_peer() virtual
PackedInt32Array | _get_peer_ids() virtual const
int | _get_remote_sender_id() virtual const
int | _get_unique_id() virtual const
Error | _object_configuration_add(object: Object, configuration: Variant) virtual
Error | _object_configuration_remove(object: Object, configuration: Variant) virtual
Error | _poll() virtual
Error | _rpc(peer: int, object: Object, method: StringName, args: Array) virtual
void | _set_multiplayer_peer(multiplayer_peer: MultiplayerPeer) virtual

---

## Method Descriptions

MultiplayerPeer _get_multiplayer_peer() virtual 

Called when the MultiplayerAPI.multiplayer_peer is retrieved.

---

PackedInt32Array _get_peer_ids() virtual const 

Callback for MultiplayerAPI.get_peers().

---

int _get_remote_sender_id() virtual const 

Callback for MultiplayerAPI.get_remote_sender_id().

---

int _get_unique_id() virtual const 

Callback for MultiplayerAPI.get_unique_id().

---

Error _object_configuration_add(object: Object, configuration: Variant) virtual 

Callback for MultiplayerAPI.object_configuration_add().

---

Error _object_configuration_remove(object: Object, configuration: Variant) virtual 

Callback for MultiplayerAPI.object_configuration_remove().

---

Error _poll() virtual 

Callback for MultiplayerAPI.poll().

---

Error _rpc(peer: int, object: Object, method: StringName, args: Array) virtual 

Callback for MultiplayerAPI.rpc().

---

void _set_multiplayer_peer(multiplayer_peer: MultiplayerPeer) virtual 

Called when the MultiplayerAPI.multiplayer_peer is set.
