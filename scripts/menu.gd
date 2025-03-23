extends Control
@onready var music_manager = get_node("/root/Audiolvl2")

func _ready() -> void:
	music_manager.emit_signal("stop_music")

func _on_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/titleScreen.tscn")


func _on_skins_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/skinoptions.tscn")
