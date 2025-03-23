extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var GameManager: Node = %GameManager
@onready var pause_menu = $Player/CanvasLayer/pause_menu
@onready var coin_area_nodes: Array = $coins.get_children()
@onready var mid: Node2D = $Node2D
@onready var music_manager = get_node("/root/Audiolvl2")

var paused = false

func _ready() -> void:
	music_manager.emit_signal("play_music")
	if Global.teleportmid:
		player.global_position = mid.position
	
	Global.load_game_data()
	Global.is_alive = true
	Engine.time_scale = 1
	pause_menu.hide()

	# Update coin visibility based on global state and session state
	coin_area_nodes = coin_area_nodes.filter(func(coin):
		if coin and is_instance_valid(coin) and coin.has_method("coin_id"):
			# If the coin was globally collected, remove it
			if Global.collected_coins.has(coin.coin_id) and Global.collected_coins[coin.coin_id]:
				coin.queue_free()
				return false
			# If the coin was collected in this session, remove it
			elif coin.coin_id in Global.current_level_collected_coins:
				coin.queue_free()
				return false
			# Otherwise, make it visible
			else:
				coin.visible = true
				return true
		return false  # Exclude invalid nodes
	)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()
		music_manager.emit_signal("play_music")
		Engine.time_scale = 1
	else:
		pause_menu.show()
		music_manager.emit_signal("pause_music")
		Engine.time_scale = 0
	paused = !paused

@export var level_number: int

func _on_coin_collected(coin: Node2D) -> void:
	# Add the coin to session tracker only
	if coin and coin.has_method("coin_id"):
		Global.current_level_collected_coins.append(coin.coin_id)  # Track in session
		coin.queue_free()  # Remove coin visually
		GameManager.score += 1  # Increment score

func complete_level():
	LevelManager.unlock_level(level_number)  # Unlock this level
	if level_number < LevelManager.unlocked_levels.size() - 1:  # Check if it's not the last level
		LevelManager.unlock_level(level_number + 2)  # Unlock the next level
	print("Level ", level_number, " completed. Unlocking Level ", level_number + 2)
	# Commit session-collected coins to global state
	for coin_id in Global.current_level_collected_coins:
		Global.collected_coins[coin_id] = true
	Global.current_level_collected_coins.clear()  # Clear session tracker

	# Save global state
	Global.save_level_coins_to_global()
	LevelManager.unlock_level(level_number)
	if level_number < LevelManager.unlocked_levels.size() - 1:
		LevelManager.unlock_level(level_number + 1)
	Global.total_score += GameManager.score
	GameManager.reset_score()
	LevelManager.total_score = Global.total_score
	LevelManager.save_progress()
	print("Level", level_number, "completed. Total Score:", Global.total_score)

func _on_end_door_body_entered(body: Node2D) -> void:
	complete_level()

# Function to clear session data when leaving or pausing the level
func _on_level_exit():
	# When leaving the level, clear all session coin collection data
	Global.current_level_collected_coins.clear()  # This will prevent coins from being removed when you re-enter
	# You can also clear or reset other session-related states here as needed
	print("Session data cleared when exiting the level.")
