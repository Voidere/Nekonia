extends Node2D

signal chest_opened(new_skin)

@onready var interaction_area = $Area2D
const OPEN_ACTION = "use"
var new_skin = "OrangeCat"
var is_opened = false

func _process(delta):
	if Input.is_action_just_pressed(OPEN_ACTION) and is_player_in_range() and not is_opened:
		open_chest()

func is_player_in_range() -> bool:
	for body in interaction_area.get_overlapping_bodies():
		if body.name == "Player": # Replace "Player" with your player's node name
			return true
	return false
	
func open_chest():
	# Unlock the skin and immediately save
	Global.skins_unlocked["special_skin"] = true
	Global.save_game_data()  # Save the updated unlocked skin
	is_opened = true
	emit_signal("chest_opened", new_skin)  # Ensure this is called
	$Sprite.texture = preload("res://assets/chestopen.png")
