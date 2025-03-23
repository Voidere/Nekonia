extends Node2D


# Signal to notify when the lever is activated
signal lever_activated(state)

# Lever states: true = activated, false = deactivated
var is_activated = false

# Reference to the Area2D for detecting the player
@onready var interaction_area = $Area2D

# Input action for using the lever
const USE_ACTION = "use"

# Called when the player interacts with the lever
func _process(delta):
	if Input.is_action_just_pressed(USE_ACTION) and is_player_in_range():
		toggle_lever()

# Toggle the lever state
func toggle_lever():
	is_activated = !is_activated
	update_visual_state()
	emit_signal("lever_activated", is_activated)

# Function to check if the player is in range
func is_player_in_range() -> bool:
	for body in interaction_area.get_overlapping_bodies():
		if body.name == "Player": # Replace "Player" with your player's node name
			return true
	return false

# Update the lever's appearance based on its state
func update_visual_state():
	if is_activated:
		$Sprite.texture = preload("res://assets/own/leveron.png")
	else:
		$Sprite.texture = preload("res://assets/own/leveroff.png")
