extends Node2D

@onready var interaction_area: Area2D = $"."

const USE_ACTION = "use"

# Called when the player interacts with the lever
func _process(delta):
	Global.teleportmid2 = true
	if Input.is_action_just_pressed(USE_ACTION) and is_player_in_range():
		get_tree().change_scene_to_file("res://scenes/Level4.tscn")


func is_player_in_range() -> bool:
	for body in interaction_area.get_overlapping_bodies():
		if body.name == "Player": # Replace "Player" with your player's node name
			return true
	return false
