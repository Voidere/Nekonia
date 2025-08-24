extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/titleScreen.tscn")



func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/titleScreen.tscn")
