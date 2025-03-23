extends Control

@onready var main = $"../../"


func _on_button_pressed() -> void:
	pass
	#get_tree().change_scene_to_file("res://scenes/ruinen_level_3.tscn")
	#Engine.time_scale = 1


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	main.pauseMenu()
	Engine.time_scale = 1
