extends Control

# Speed at which the credits will scroll (in pixels per second)
@export var scroll_speed : float = 100

# Reference to the label containing credits
@onready var credits_label : Label = $Label

func _process(delta: float) -> void:
	# Check if the bottom of the label is still off-screen
	if credits_label.position.y + credits_label.size.y > size.y:
		# Scroll the credits upwards by modifying the position of the label
		credits_label.position.y -= scroll_speed * delta
	else:
		# Once the bottom of the label is visible, stop scrolling
		credits_label.position.y = size.y - credits_label.size.y

	if Input.is_action_just_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/titleScreen.tscn")
