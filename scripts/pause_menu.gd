extends Control

@onready var main = $"../../../"
@onready var music_manager = get_node("/root/Audiolvl2")



func _on_button_pressed() -> void:
	main.pauseMenu()


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")
	main.pauseMenu()


func _on_button_3_pressed() -> void:
	Global.current_level_collected_coins.clear()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	main.pauseMenu()
	music_manager.emit_signal("stop_music")
