extends Node2D

@onready var pause_menu = $Player/CanvasLayer/PauseMenu
@onready var skinpopup: PopupPanel = $CanvasLayer/skinpopup
@onready var player = $Player
@onready var music_manager = get_node("/root/Audiolvl2")
var paused = false
var skin = false


func _ready() -> void:
	music_manager.emit_signal("play_music")
	if skinpopup and player:
		skinpopup.connect("skin_equip_requested", Callable(player, "_on_skin_equip_requested"))
	else:
		print("PopupPanel or Player not found in the scene.")

	Engine.time_scale = 1
	pause_menu.hide()
	skinpopup.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
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
		music_manager.emit_signal("pause_music")
		Engine.time_scale = 0
		
	paused = !paused


func skMenu():
	if skin:
		skinpopup.hide()
		Engine.time_scale = 1
	else:
		skinpopup.show()
		Engine.time_scale = 0
		
	skin = !skin
	
	
