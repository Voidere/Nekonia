extends Control
@onready var h_scroll_bar: HScrollBar = $"."
@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var button_right: Button = $button_right
@onready var button_left: Button = $button_left


var level_width := 1152
var current_index := 0
var max_index := 3  # z. B. 4 Levels → max_index = 3

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
