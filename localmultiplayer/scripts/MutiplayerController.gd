extends Control

@export var Address = get_env_var("IP_ADDRESS")
@export var port: int = 8910
var peer

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if "--server" in OS.get_cmdline_args():
		hostGame()
	
	$ServerBrowser.joinGame.connect(JoinByIP)

func get_env_var(key: String) -> String:
	var file = FileAccess.open(".env", FileAccess.READ)
	if not file:
		return ""
	
	while not file.eof_reached():
		var line = file.get_line()
		var parts = line.strip_edges().split("=")
		if parts.size() == 2 and parts[0] == key:
			return parts[1]
	return ""

func peer_connected(id):
	print("Player Connected " + str(id))
	for i in GameServerManager.Players:
		SendPlayerInformation.rpc_id(id, GameServerManager.Players[i].name, i)

func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	GameServerManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("Player")
	for i in players:
		if i.name == str(id):
			i.queue_free()

func connected_to_server():
	print("connected To Server!")
	SendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())

# Called only from clients
func connection_failed():
	print("Couldn't Connect")

@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !GameServerManager.Players.has(id):
		GameServerManager.Players[id] = {
			"name": name,
			"id": id,
			"score": 0
		}

	if multiplayer.is_server():
		# Sende alle Spieler-Infos an den neuen Spieler
		for player_id in GameServerManager.Players:
			SendExistingPlayers.rpc_id(id, GameServerManager.Players[player_id].name, player_id)

@rpc("authority", "call_local")
func SendExistingPlayers(name, id):
	if !GameServerManager.Players.has(id):
		GameServerManager.Players[id] = {
			"name": name,
			"id": id,
			"score": 0
		}

	if get_tree().current_scene and get_tree().current_scene.has_method("add_new_player"):
		get_tree().current_scene.add_new_player(id)

@rpc("any_peer", "call_local")
func StartGame():
	var scene = load("res://localmultiplayer/scenes/testScene.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func hostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 10)
	if error != OK:
		print("Cannot host: ", error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting For Players!")

func _on_host_button_down():
	hostGame()
	SendPlayerInformation($LineEdit.text, multiplayer.get_unique_id())
	$ServerBrowser.setUpBroadCast($LineEdit.text + "'s server")

func _on_join_button_down():
	JoinByIP(Address)

func JoinByIP(ip):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

func _on_start_game_button_down():
	StartGame.rpc()

func _on_button_button_down():
	GameServerManager.Players[GameServerManager.Players.size() + 1] = {
		"name" : "test",
		"id" : 1,
		"score": 0
	}
