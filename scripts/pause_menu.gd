extends Control

@onready var main = $"../../../"
@onready var music_manager = get_node("/root/Audiolvl2")
@onready var menu: MarginContainer = $MarginContainer
@onready var sound: Control = $sound

func _ready() -> void:
	sound.hide()

func _on_button_pressed() -> void:
	AudioManager.play_back_button_click()
	main.pauseMenu()


func _on_button_2_pressed() -> void:
	AudioManager.play_button_click()
	await get_tree().create_timer(0.05).timeout
	sound.show()


func _on_button_3_pressed() -> void:
	AudioManager.play_button_click()
	await get_tree().create_timer(0.05).timeout
	Global.current_level_collected_coins.clear()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	main.pauseMenu()
	music_manager.emit_signal("stop_music")


func _on_soundeexit_pressed() -> void:
	sound.hide()
	menu.show()
