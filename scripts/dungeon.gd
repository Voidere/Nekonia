extends Node2D

#@onready var GameManager: Node = %GameManager
@onready var pause_menu = $Player/CanvasLayer4/PauseMenu
#@onready var coin_area_nodes: Array = $Pickups.get_children()
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var backround: TileMapLayer = $backround
@onready var end_pop: Control = $Player/CanvasLayer/end_pop
@onready var tile2: TileMapLayer = $TileMapLayer2


var paused = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func _ready() -> void:
	end_pop.hide()
#	Global.load_game_data()
#	Global.is_alive = true
	Engine.time_scale = 1
	pause_menu.hide()

func pauseMenu():
	if paused:
		pause_menu.hide()
		audio_stream_player.stream_paused = false
		Engine.time_scale = 1
	else:
		pause_menu.show()
		audio_stream_player.stream_paused = true
		Engine.time_scale = 0
	paused = !paused

func win():
	tile2.visible = false
