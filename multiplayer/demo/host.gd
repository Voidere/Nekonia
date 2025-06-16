extends Control

var URL = "ws://localhost:8080"

@onready var host = $VBoxContainer/Connect/Host
@onready var room = $VBoxContainer/Connect/RoomSecret


func _ready():
	Client.lobby_joined.connect(_lobby_joined)
	Client.lobby_sealed.connect(_lobby_sealed)
	Client.connected.connect(_connected)
	Client.disconnected.connect(_disconnected)

	multiplayer.server_relay = false # This seems correct for P2P WebRTC
	multiplayer.connected_to_server.connect(_mp_server_connected)
	multiplayer.connection_failed.connect(_mp_server_disconnect)
	multiplayer.server_disconnected.connect(_mp_server_disconnect)
	multiplayer.peer_connected.connect(_mp_peer_connected) # Standard MultiplayerAPI signal
	multiplayer.peer_disconnected.connect(_mp_peer_disconnected) # Standard MultiplayerAPI signal


@rpc("any_peer", "call_local")
func ping(argument):
	_log("[Multiplayer] Ping from peer %d: arg: %s" % [multiplayer.get_remote_sender_id(), argument])


func _mp_server_connected():
	_log("[Multiplayer] Server connected (I am %d)" % Client.rtc_mp.get_unique_id())


func _mp_server_disconnect():
	_log("[Multiplayer] Server disconnected (I am %d)" % Client.rtc_mp.get_unique_id())


func _mp_peer_connected(id: int):
	# This is the MultiplayerAPI.peer_connected signal.
	# If this signal works here in host.gd on the server, it's even more puzzling why it doesn't work in level.gd.
	# For now, we are shifting the logic for spawning all players to a direct call after lobby is sealed.
	# However, let's add a log here to see if the server's host.gd receives this.
	if multiplayer.is_server():
		_log("[Host.gd - Server] MultiplayerAPI.peer_connected detected peer: " + str(id))
	else:
		_log("[Host.gd - Client] MultiplayerAPI.peer_connected detected peer: " + str(id))


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
	# The call_deferred is important here to ensure the scene change happens safely.
	call_deferred("start_game")


func _log(msg):
	print(msg)
	# Assuming TextEdit is $VBoxContainer/TextEdit
	var text_edit = $VBoxContainer.get_node_or_null("TextEdit")
	if text_edit:
		text_edit.text += str(msg) + "\n"
	else:
		print("[Host.gd] _log: TextEdit node not found!")


func _on_join_pressed():
	Client.start(URL, "", true)


func _on_back_to_main_menu_pressed():
	get_tree().change_scene_to_file("res://UI/game_menu.tscn") # Make sure this path is correct


func _on_start_pressed():
	Client.seal_lobby() # This will trigger _lobby_sealed eventually


func start_game():
	_log("[Host.gd] Starting game, changing scene to level.tscn")
	get_tree().change_scene_to_file("res://multiplayer/demo/level.tscn")
