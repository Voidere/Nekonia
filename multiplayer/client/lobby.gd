# File: lobby.gd
extends Node

## ───────── Signals you can hook from menus or World ─────────
signal player_connected(peer_id: int, info: Dictionary)
signal player_disconnected(peer_id: int)
signal server_disconnected

## ───────── Runtime data ─────────
var players: Dictionary     # peer_id → info
var player_info := {"name": "Name"}  # set this in the menu!
var players_loaded = 0 # counter for player_loaded()

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

## -------------------------------- RPCs --------------------------------
@rpc("any_peer", "call_local", "reliable")
func load_game(scene_path: String) -> void:
	print("Lobby.load_game →", scene_path)
	get_tree().change_scene_to_file(scene_path)

@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			players_loaded = 0
			get_tree().current_scene.call_deferred("start_game")

## ------------- Helpers called from Host / Client scripts --------------
func register_self(id: int) -> void:
	players[id] = player_info.duplicate()
	player_connected.emit(id, player_info)

## ----------------------------------------------------------------------
func _on_peer_connected(id: int) -> void:
	_register_player.rpc_id(id, player_info)

@rpc("any_peer", "reliable")
func _register_player(info: Dictionary) -> void:
	var from_id := multiplayer.get_remote_sender_id()
	players[from_id] = info
	player_connected.emit(from_id, info)

func _on_peer_disconnected(id: int) -> void:
	players.erase(id)
	player_disconnected.emit(id)

func _on_server_disconnected() -> void:
	players.clear()
	server_disconnected.emit()
