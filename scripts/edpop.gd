extends Control

@onready var main = $"../../../"

func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/titleScreen.tscn")
	main.pauseMenu()


func _on_button_4_pressed() -> void:
		get_tree().change_scene_to_file("res://scenes/credits.tscn")
		main.pauseMenu()
