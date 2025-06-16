extends Node

@export var player_scene: PackedScene

func _ready():
	print("[Level] Ready - My ID: ", multiplayer.get_unique_id())
	print("[Level] Is Server: ", multiplayer.is_server())
	
	# Wait a frame to ensure multiplayer is properly initialized
	await get_tree().process_frame # This await might need reconsideration depending on MultiplayerSpawner behavior
	
	if multiplayer.is_server():
		print("[Level] Server spawning its own player")
		spawn_player(multiplayer.get_unique_id()) # Call local function for server's own player
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected(id: int):
	print("[Level] Peer connected: ", id)
	if multiplayer.is_server():
		print("[Level] Server spawning player for peer: ", id)
		spawn_player(id) # Call local function for new peer
	else:
		print("[Level] Client received peer connection: ", id) # Client does nothing here regarding spawning

func _on_peer_disconnected(id: int):
	print("[Level] Peer disconnected: ", id)
	# Player removal is often handled by MultiplayerSpawner or by RPC from server
	# For now, keep existing logic, but this might need adjustment if MultiplayerSpawner handles it.
	if multiplayer.is_server(): # Only server should decide to remove nodes
		var player_node = get_node_or_null(str(id))
		if player_node:
			player_node.queue_free()
			print("[Level] Server removed player: ", id)

# This is now a local function, only called by the server.
func spawn_player(id: int):
	print("[Level] Attempting to spawn player: ", id)
	# It's possible the MultiplayerSpawner might have already created this node on the server
	# if the client somehow initiated a spawn request that the spawner is configured to respect.
	# However, with our current logic, server is authoritative for spawning.
	if has_node(str(id)):
		print("[Level] Player already exists: ", id)
		# If it already exists, ensure its authority is correctly set.
		# This could happen if the spawner created it based on a client request before this code runs.
		# However, for now, we assume this function is the sole spawner on the server.
		var existing_player = get_node(str(id))
		if existing_player.get_multiplayer_authority() != id:
			print("[Level] Correcting authority for existing player ", id)
			existing_player.set_multiplayer_authority(id)
		return
		
	var player = player_scene.instantiate()
	player.name = str(id) # Crucial for MultiplayerSpawner and general node reference
	
	# Set multiplayer authority BEFORE adding to scene if MultiplayerSpawner might react instantly
	player.set_multiplayer_authority(id)
	
	add_child(player, true) # Add to scene, MultiplayerSpawner should pick it up
	
	# Set the player's position based on their ID
	# This initial position can also be synchronized via properties if needed
	player.position = Vector2(100 + (id % 10 * 50), 100 + (id / 10 * 50)) # Avoid simple linear placement
	
	print("[Level] Successfully spawned player: ", id, " with authority: ", player.get_multiplayer_authority())
	print("[Level] New children: ", get_children().map(func(n): return n.name))

# Removed the request_player_spawn RPC function entirely.
