extends Control

@onready var main = $"../../"



func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Level3.tscn")
	Engine.time_scale = 1


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	main.pauseMenu()
