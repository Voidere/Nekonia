extends Node

const PLAYER = preload("res://localmultiplayer/player/player.tscn")

func _ready():
	if multiplayer.is_server():
		# Only the host manually adds players on scene load
		for id in GameServerManager.Players:
			add_new_player(id)

# Called via RPC from menu.gd
func add_new_player(id):
	if has_node(str(id)):
		print("Player already exists: ", id)
		return
	var player = PLAYER.instantiate()
	player.name = str(id)
	add_child(player)
