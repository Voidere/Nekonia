extends Node

@export var player_scene: PackedScene

func _ready():
	print("[Level] Ready - My ID: ", multiplayer.get_unique_id())
	print("[Level] Is Server: ", multiplayer.is_server())
	
	# Wait a frame to ensure multiplayer is properly initialized
	await get_tree().process_frame
	
	# Spawn the host player for everyone
	if multiplayer.is_server():
		print("[Level] Server spawning host player")
		spawn_player.rpc(1)
	
	# When a new peer connects, spawn their player
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected(id: int):
	print("[Level] Peer connected: ", id)
	# Only the server should spawn new players
	if multiplayer.is_server():
		print("[Level] Server spawning player for peer: ", id)
		spawn_player.rpc(id)
	else:
		print("[Level] Client received peer connection: ", id)

func _on_peer_disconnected(id: int):
	print("[Level] Peer disconnected: ", id)
	# Remove the disconnected player
	if has_node(str(id)):
		get_node(str(id)).queue_free()

@rpc("any_peer")
func request_player_spawn(id: int):
	print("[Level] Received spawn request for player: ", id)
	if multiplayer.is_server():
		spawn_player.rpc(id)

@rpc("any_peer", "call_local")
func spawn_player(id: int):
	print("[Level] Attempting to spawn player: ", id)
	print("[Level] Current children: ", get_children().map(func(n): return n.name))
	
	# Don't spawn if player already exists
	if has_node(str(id)):
		print("[Level] Player already exists: ", id)
		return
		
	var player = player_scene.instantiate()
	player.name = str(id)
	add_child(player, true)
	
	# Set the player's position based on their ID
	player.position = Vector2(100 + (id * 50), 100)
	
	# Set multiplayer authority
	player.set_multiplayer_authority(id)
	print("[Level] Successfully spawned player: ", id)
	print("[Level] New children: ", get_children().map(func(n): return n.name))
