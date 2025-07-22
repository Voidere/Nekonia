extends Control
@onready var h_scroll_bar: HScrollBar = $"."
@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var button_right: Button = $button_right
@onready var button_left: Button = $button_left
# @onready var button_play: Button = $button_play  # Falls noch nicht deklariert

var level_width := 1156
var current_index := 2
var max_index := 6  # z. B. 4 Levels → max_index = 3
var level_paths := [
	"res://scenes/Level1.tscn",
	"res://scenes/Level2.tscn",
	"res://scenes/Level3.tscn",
	"res://scenes/level_4.tscn",
	"res://scenes/Level4.tscn"
]
func _ready():
	if not h_scroll_bar or not h_box_container:
		push_error("Scrollbar oder HBoxContainer nicht gefunden!")
		return

	h_scroll_bar.page = level_width
	h_scroll_bar.max_value = level_width * max_index

	button_left.pressed.connect(_on_left_pressed)
	button_right.pressed.connect(_on_right_pressed)

func _process(delta):
	h_box_container.position.x = -h_scroll_bar.value

func _on_left_pressed():
	if current_index > 0:
		current_index -= 1
		h_scroll_bar.value = current_index * level_width

func _on_right_pressed():
	if current_index < max_index:
		current_index += 1
		h_scroll_bar.value = current_index * level_width
		
		
func _on_button_play_pressed() -> void:
	if current_index >= 0 and current_index < level_paths.size():
		var path = level_paths[current_index]
		get_tree().change_scene_to_file(path)
	else:
		push_error("Ungültiger Level-Index: " + str(current_index))
