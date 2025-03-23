extends Node2D

# The door starts closed
var is_open = false

# Method to open or close the door
func set_door_state(open: bool):
	if open != is_open:
		is_open = open
		update_visual_state()

# Update the door's appearance based on its state
func update_visual_state():
	if is_open:
		$Sprite.texture = preload("res://assets/dooroff.png")
		$StaticBody2D/CollisionShape2D.disabled = true # Disable collision when the door is open
	else:
		$Sprite.texture = preload("res://assets/dooron.png")
		$StaticBody2D/CollisionShape2D.disabled = false # Enable collision when the door is closed


func _on_lever_lever_activated(state: Variant) -> void:
	set_door_state(state)
