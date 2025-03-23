extends Area2D

@onready var timer = $Timer


var is_player_inside: bool = false

func _ready() -> void:
	timer.stop()

# Called when a body enters the collision shape
func _on_body_entered(body: Node) -> void:
		print("Player entered collision shape")  # Debugging output
		is_player_inside = true
		timer.stop()
		timer.wait_time = 5.0
		timer.start()

# Called when a body exits the collision shape
func _on_body_exited(body: Node) -> void:
		print("Player exited collision shape")  # Debugging output
		is_player_inside = false
		timer.stop()

# Called when the timer times out
func _on_timer_timeout() -> void:
	Global.teleportmid = true
	print("Timer finished")
	if is_player_inside:
		print("Player is still inside, changing scene")
		get_tree().change_scene_to_file("res://scenes/Level2.tscn")
	else:
		print("Player is not inside, not changing scene")
