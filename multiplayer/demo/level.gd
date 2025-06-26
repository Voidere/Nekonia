extends Node

@export var player_scene: PackedScene

func _ready():
	print("[Level:%s] Level ready. Is Server: %s" % [multiplayer.get_unique_id(), multiplayer.is_server()])
	
	# Wait a frame to ensure multiplayer is properly initialized, especially for clients.
	await get_tree().process_frame
	
	if multiplayer.is_server():
		# Server spawns itself for everyone. ID 1 is typically the server/host.
		print("[Level:1] Server is spawning itself.")
		spawn_player_for_everyone.rpc(create_player_info(1))
	
	multiplayer.peer_connected.connect(_on_player_joined_network)
	multiplayer.peer_disconnected.connect(_on_player_left_network)


func create_player_info(peer_id: int) -> Dictionary:
	# For now, player_info is just the ID. Can be expanded later (e.g., name, color).
	return {"id": peer_id}


# Called when the multiplayer API signals a new peer has connected.
func _on_player_joined_network(new_peer_id: int):
	print("[Level:%s] Network: Peer %s connected." % [multiplayer.get_unique_id(), new_peer_id])
	
	# Existing players (including server) tell the new player about themselves.
	# The new player should not send info about itself to itself via this RPC.
	if multiplayer.get_unique_id() != new_peer_id:
		var my_info = create_player_info(multiplayer.get_unique_id())
		print("[Level:%s] Telling new peer %s about me." % [multiplayer.get_unique_id(), new_peer_id])
		send_my_info_to_new_peer.rpc_id(new_peer_id, my_info)

	# Server is responsible for telling everyone to spawn the NEWLY connected player.
	if multiplayer.is_server():
		print("[Level:1] Server is telling everyone to spawn new peer %s." % new_peer_id)
		var new_player_info = create_player_info(new_peer_id)
		spawn_player_for_everyone.rpc(new_player_info)


# RPC called by existing players, executed on the NEW player's machine.
@rpc("authority", "call_local", "reliable")
func send_my_info_to_new_peer(info_of_existing_player: Dictionary):
	var my_id = multiplayer.get_unique_id()
	var existing_player_id = info_of_existing_player.id
	print("[Level:%s] Received info about existing player %s. Spawning locally." % [my_id, existing_player_id])
	# The new player now spawns the character for the existing player.
	_spawn_player_visuals(info_of_existing_player)


# RPC called by the server to make all clients (including itself) spawn a player.
@rpc("any_peer", "call_local", "reliable")
func spawn_player_for_everyone(player_info_to_spawn: Dictionary):
	var my_id = multiplayer.get_unique_id()
	var spawn_id = player_info_to_spawn.id
	print("[Level:%s] Received request to spawn player %s for everyone. Spawning locally." % [my_id, spawn_id])
	# All peers (clients and server) will execute this to spawn the player.
	_spawn_player_visuals(player_info_to_spawn)


# Local helper function to instantiate and set up the player character.
func _spawn_player_visuals(p_info: Dictionary):
	var player_id_to_spawn = p_info.id
	var local_peer_id = multiplayer.get_unique_id()
	
	print("[Level:%s] _spawn_player_visuals for ID %s." % [local_peer_id, player_id_to_spawn])
	
	if has_node(str(player_id_to_spawn)):
		print("[Level:%s] Player %s already exists. Skipping spawn." % [local_peer_id, player_id_to_spawn])
		return
		
	if player_scene == null:
		printerr("[Level:%s] Player scene is not set!" % local_peer_id)
		return

	print("[Level:%s] Instantiating player scene for ID %s." % [local_peer_id, player_id_to_spawn])
	var player = player_scene.instantiate()
	player.name = str(player_id_to_spawn) # Name node by ID for easy lookup & authority checks
	
	# Set position before adding to scene to avoid physics issues.
	player.position = Vector2(100 + (player_id_to_spawn * 60), 250) 
	
	print("[Level:%s] Adding player %s to scene." % [local_peer_id, player_id_to_spawn])
	add_child(player, true)
	
	# CRUCIAL: Set the multiplayer authority for the spawned player.
	# This tells the multiplayer system which peer controls this node.
	print("[Level:%s] Setting multiplayer authority of player %s to %s." % [local_peer_id, player_id_to_spawn, player_id_to_spawn])
	player.set_multiplayer_authority(player_id_to_spawn)
	
	print("[Level:%s] Successfully spawned player %s." % [local_peer_id, player_id_to_spawn])


func _on_player_left_network(peer_id: int):
	print("[Level:%s] Network: Peer %s disconnected." % [multiplayer.get_unique_id(), peer_id])
	var player_node = get_node_or_null(str(peer_id))
	if player_node:
		print("[Level:%s] Removing player node for disconnected peer %s." % [multiplayer.get_unique_id(), peer_id])
		player_node.queue_free()
	else:
		print("[Level:%s] Player node for peer %s not found for removal." % [multiplayer.get_unique_id(), peer_id])

# The old request_player_spawn and spawn_player are no longer needed with this pattern.
# Leaving them commented out for now, can be removed later.
#@rpc("any_peer")
#func request_player_spawn(id: int):
#	print("[Level] Received spawn request for player: ", id)
#	if multiplayer.is_server():
#		spawn_player.rpc(id)

#@rpc("any_peer", "call_local")
#func spawn_player(id: int):
#	print("[Level] Attempting to spawn player: ", id)
#	# ... old implementation ...
