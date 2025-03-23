extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area: Area2D = $Area2D2


func _on_area_2d_body_entered(body: Node2D) -> void:
	animated_sprite_2d.play("enter")


func _on_area_2d_body_exited(body: Node2D) -> void:
	animated_sprite_2d.play("exit")

const USE_ACTION = "use"

# Called when the player interacts with the lever
func _process(delta):
	if Input.is_action_just_pressed(USE_ACTION) and is_player_in_range():
		get_tree().change_scene_to_file("res://scenes/haus_innen.tscn")


func is_player_in_range() -> bool:
	for body in interaction_area.get_overlapping_bodies():
		if body.name == "Player": # Replace "Player" with your player's node name
			return true
	return false
