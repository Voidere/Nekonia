# File: World.gd   (attached to the root of World.tscn)
extends Node

@export var player_scene: PackedScene

func _ready():
	print("World ready on peer", multiplayer.get_unique_id())
	await get_tree().process_frame  # let networking settle

	# Spawn every peer already in the lobby
	for id in Lobby.players.keys():
		_spawn_player(id)

	# Announce that I finished loading
	Lobby.player_loaded.rpc()

	# React to peers joining/leaving while the level is running
	Lobby.player_connected.connect(_on_lobby_player_connected)
	Lobby.player_disconnected.connect(_on_lobby_player_disconnected)

func start_game():
	print(" Game started! Everyone loaded.")

func _spawn_player(id: int) -> void:
	print("asd")
	if has_node(str(id)):
		return  # already exists
	if player_scene == null:
		printerr("player_scene not assigned")
		return
	var p := player_scene.instantiate()
	p.name = str(id)
	p.position = Vector2(100 + id % 10 * 60, 200)
	add_child(p, true)
	p.set_multiplayer_authority(id)

func _on_lobby_player_connected(id: int, _info: Dictionary) -> void:
	_spawn_player(id)

func _on_lobby_player_disconnected(id: int) -> void:
	get_node_or_null(str(id)).queue_free()
