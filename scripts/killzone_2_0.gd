extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":  # Ensure the body is the player
		Engine.time_scale = 0.9
		body.get_node("hitbox").queue_free()
		timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
