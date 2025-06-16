extends Node

@export var player_scene: PackedScene

func _ready():
	# Only connect peer_disconnected for now. peer_connected logic is being replaced.
	var peer_disconnected_error = multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	if peer_disconnected_error != OK:
		print("[Level] CRITICAL ERROR: Failed to connect peer_disconnected signal. Error code: ", peer_disconnected_error)
	else:
		print("[Level] Successfully connected peer_disconnected signal.")

	print("[Level] Ready - My ID: ", multiplayer.get_unique_id())
	print("[Level] Is Server: ", multiplayer.is_server())
		
	if multiplayer.is_server():
		print("[Level] _ready: Server path entered.")
		# Server's own player is no longer spawned directly here.
		# server_spawn_all_players will handle it.

		print("[Level] _ready: Server will call server_spawn_all_players after a short delay.")
		await get_tree().create_timer(0.2).timeout 

		if not is_instance_valid(self):
			print("[Level] _ready: Instance became invalid before calling server_spawn_all_players. Aborting.")
			return

		if multiplayer.is_server(): 
			print("[Level] _ready: Delay complete, server now calling server_spawn_all_players.")
			server_spawn_all_players()
		else:
			print("[Level] _ready: No longer server after delay. Not calling server_spawn_all_players.")

func _on_peer_disconnected(id: int):
	print("[Level] Peer disconnected: ", id)
	if multiplayer.is_server(): 
		var player_node = get_node_or_null(str(id))
		if player_node:
			# Important: Ensure this is not fighting with MultiplayerSpawner's auto-cleanup if any.
			# For now, explicit removal by server is fine.
			player_node.queue_free()
			print("[Level] Server removed player node: ", id)

func spawn_player(id: int):
	print("[Level] spawn_player: Attempting to spawn player for ID: ", id)
	
	if has_node(str(id)):
		print("[Level] spawn_player: Player node ", str(id), " already exists. Ensuring authority.")
		var existing_player = get_node(str(id))
		if existing_player.get_multiplayer_authority() != id:
			print("[Level] spawn_player: Correcting authority for existing player ", id, " to ", id)
			existing_player.set_multiplayer_authority(id)
		return
		
	var player = player_scene.instantiate()
	player.name = str(id) 
	player.set_multiplayer_authority(id) 
	add_child(player, true) 
	player.position = Vector2(100 + (id % 10 * 50), 100 + (id / 10 * 50))
	print("[Level] spawn_player: Successfully spawned player: ", id, " with authority: ", player.get_multiplayer_authority())

func server_spawn_all_players():
	if not multiplayer.is_server():
		print("[Level] server_spawn_all_players: Called on a client instance. Doing nothing. My ID: ", multiplayer.get_unique_id())
		return

	var own_id = multiplayer.get_unique_id()
	print("[Level] server_spawn_all_players: Executing as server. My ID: ", own_id)

	# Spawn server's own player first
	print("[Level] server_spawn_all_players: Server attempting to spawn its own player (ID: ", own_id, ").")
	if not has_node(str(own_id)):
		spawn_player(own_id)
	else:
		print("[Level] server_spawn_all_players: Server's own player node (ID: ", own_id, ") already exists. Ensuring authority.")
		# This is a good place to ensure authority is correct even if it somehow pre-existed
		var existing_server_player = get_node(str(own_id))
		if existing_server_player.get_multiplayer_authority() != own_id:
			existing_server_player.set_multiplayer_authority(own_id)
	
	# Spawn players for remote peers
	var remote_peers = multiplayer.get_peers() 
	print("[Level] server_spawn_all_players: Current remote peers: ", remote_peers)

	if remote_peers.is_empty():
		print("[Level] server_spawn_all_players: No remote peers connected to spawn players for.")
	else:
		for peer_id in remote_peers:
			print("[Level] server_spawn_all_players: Server attempting to spawn player for remote peer_id: ", peer_id)
			if not has_node(str(peer_id)):
				spawn_player(peer_id)
			else:
				print("[Level] server_spawn_all_players: Player node for remote peer_id ", peer_id, " already exists. Skipping spawn, ensuring authority.")
				var existing_remote_player = get_node(str(peer_id))
				if existing_remote_player.get_multiplayer_authority() != peer_id:
					existing_remote_player.set_multiplayer_authority(peer_id)
	
	print("[Level] server_spawn_all_players: Finished processing all players.")
