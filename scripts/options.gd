extends Control
@onready var music_manager = get_node("/root/Audiolvl2")

func _ready() -> void:
	music_manager.emit_signal("stop_music")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/titleScreen.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/titleScreen.tscn")
