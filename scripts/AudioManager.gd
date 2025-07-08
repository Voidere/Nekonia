extends Node

var audio_manager_scene: PackedScene
var instance: Node

func _ready():
	audio_manager_scene = preload("res://scenes/AudioManager.tscn")
	instance = audio_manager_scene.instantiate()
	add_child(instance)

func play_button_click():
	instance.get_node("ButtonClickPlayer").play()

func play_back_button_click():
	instance.get_node("BackButtonClickPlayer").play()
