extends Control

var URL = "ws://localhost:8080"

@onready var host = $VBoxContainer/Connect/Host
@onready var room = $VBoxContainer/Connect/RoomSecret


func _ready():
	Client.lobby_joined.connect(_lobby_joined)
	Client.lobby_sealed.connect(_lobby_sealed)
	Client.connected.connect(_connected)
	Client.disconnected.connect(_disconnected)

	multiplayer.server_relay = false
	multiplayer.connected_to_server.connect(_mp_server_connected)
	multiplayer.connection_failed.connect(_mp_server_disconnect)
	multiplayer.server_disconnected.connect(_mp_server_disconnect)
	multiplayer.peer_connected.connect(_mp_peer_connected)
	multiplayer.peer_disconnected.connect(_mp_peer_disconnected)

@rpc("any_peer", "call_local")
func ping(argument):
	_log("[Multiplayer] Ping from peer %d: arg: %s" % [multiplayer.get_remote_sender_id(), argument])

func _mp_server_connected():
	_log("[Multiplayer] Server connected (I am %d)" % Client.rtc_mp.get_unique_id())

func _mp_server_disconnect():
	_log("[Multiplayer] Server disconnected (I am %d)" % Client.rtc_mp.get_unique_id())

func _mp_peer_connected(id: int):
	_log("[Multiplayer] Peer %d connected" % id)

func _mp_peer_disconnected(id: int):
	_log("[Multiplayer] Peer %d disconnected" % id)

func _connected(id, use_mesh):
	_log("[Signaling] Server connected with ID: %d. Mesh: %s" % [id, use_mesh])

func _disconnected():
	_log("[Signaling] Server disconnected: %d - %s" % [Client.code, Client.reason])

func _lobby_joined(lobby):
	_log("[Signaling] Lobby created %s" % lobby)
	room.text = lobby

func _lobby_sealed():
	_log("[Signaling] Lobby has been sealed")
	# Host instructs everybody to switch scenes
	Lobby.load_game.rpc("res://multiplayer/demo/level.tscn")


func _log(msg):
	print(msg)
	#$VBoxContainer/TextEdit.text += str(msg) + "\n"

func _on_join_pressed():
	Client.start(URL, "", true)

func _on_back_to_main_menu_pressed():
	get_tree().change_scene_to_file("res://UI/game_menu.tscn")

func _on_start_pressed():
	Client.seal_lobby()
