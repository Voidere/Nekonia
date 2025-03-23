extends Node2D

@export var PlayerScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for i in GameServerManager.Players:
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(GameServerManager.Players[i].id)
		add_child(currentPlayer)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		index += 1

func add_new_player(id):
	if GameServerManager.Players.has(id):
		var new_player = PlayerScene.instantiate()
		new_player.name = str(id)
		add_child(new_player)

		# Spawne an einem zufälligen Spawnpunkt
		var spawn_points = get_tree().get_nodes_in_group("PlayerSpawnPoint")
		if spawn_points.size() > 0:
			new_player.global_position = spawn_points.pick_random().global_position
