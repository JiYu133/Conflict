class_name PlayerAudioController
extends Node3D

## Reserved player-audio integration point.
##
## BasePlayer creates this subsystem for players and bots. Playback, resource
## loading, signal subscriptions, and per-frame audio work are intentionally
## disabled until the audio implementation is reintroduced.

var _player: BasePlayer
var _settings_service = null


func initialize(player: BasePlayer, settings_service = null) -> void:
	_player = player
	_settings_service = settings_service
	process_mode = Node.PROCESS_MODE_DISABLED
