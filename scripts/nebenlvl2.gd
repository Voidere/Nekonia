extends Area2D

var is_player_inside: bool = false  # To track if the player is inside the collision shape

# Called when a body enters the collision shape
func _on_body_entered(body: Node) -> void:
	if body.name == "Player":  # Make sure it's the player
		print("Player entered collision shape")  # Debugging output
		is_player_inside = true

# Called when a body exits the collision shape
func _on_body_exited(body: Node) -> void:
	if body.name == "Player":  # Make sure it's the player
		print("Player exited collision shape")  # Debugging output
		is_player_inside = false

func _process(delta: float) -> void:
	# Check for input only when player is inside
	if is_player_inside and Input.is_action_just_pressed("use"):  # "ui_accept" is usually E or Enter
		print("E pressed, changing scene")
		get_tree().change_scene_to_file("res://scenes/Level2.1.tscn")
