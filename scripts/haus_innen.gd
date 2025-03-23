extends Node2D
@onready var pause_menu = $Player/CanvasLayer/PauseMenu
@onready var music_manager = get_node("/root/Wintermus")

var paused = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.teleportmid2 = true
	music_manager.emit_signal("play_music")
	pause_menu.hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()
		music_manager.emit_signal("play_music")
		Engine.time_scale = 1
	else:
		pause_menu.show()
		music_manager.emit_signal("stop_music")
		Engine.time_scale = 0
	paused = !paused
	
