extends Control

@export var radius_x:     float = 500.0
@export var radius_y:     float = 220.0
@export var depth_scale:  float = 0.7      # Wie stark die Skins hinten kleiner werden (0.5 = halb so groß)
@export var depth_alpha:  float = 0.6       # Wie transparent die Skins hinten werden (0.6 = 60% Sichtbarkeit)
@export var focus_zoom:   float = 1.15
@export var focus_time:   float = 0.25
@export var turn_time:    float = 0.5

var angle_offset: float = 0.0
var selected_id:  int   = 0
var rot_tween: Tween
var focus_tween: Tween

@onready var skins      := $Center/Skins
@onready var btn_left   := $BtnLeft
@onready var btn_right  := $BtnRight

func _ready() -> void:
	btn_left.pressed.connect(func(): _spin_to(-1))
	btn_right.pressed.connect(func(): _spin_to(1))
	_focus(selected_id)

func _process(_delta: float) -> void:
	_update_items()

func _update_items() -> void:
	var total := skins.get_child_count()
	for i in total:
		var skin := skins.get_child(i)
		var ang := angle_offset + i * TAU / total
		var pos := Vector2(cos(ang) * radius_x, sin(ang) * radius_y)

		skin.position = pos
		skin.z_index = int(-pos.y)

		var norm := (pos.y + radius_y) / (2.0 * radius_y)  # 0 vorne, 1 hinten
		var scale_f := 1.0 - norm * depth_scale
		skin.scale = Vector2.ONE * scale_f

		var alpha = lerp(1.0, depth_alpha, norm)
		var dark_factor = lerp(1.0, 0.6, norm)  # leicht abdunkeln
		skin.modulate = Color(dark_factor, dark_factor, dark_factor, alpha)

func _focus(new_idx: int) -> void:
	var total := skins.get_child_count()
	if total == 0:
		return

	selected_id = wrapi(new_idx, 0, total)
	var sel := skins.get_child(selected_id) as Node2D
	if sel == null:
		print("Fehler: Ausgewähltes Skin-Element ist null!")
		return

	if focus_tween and focus_tween.is_running():
		focus_tween.kill()
	focus_tween = create_tween()

	for skin in skins.get_children():
		focus_tween.tween_property(skin, "scale", skin.scale, focus_time)
		focus_tween.tween_property(skin, "modulate:a", skin.modulate.a, focus_time)

	focus_tween.tween_property(sel, "scale", sel.scale * focus_zoom, focus_time) \
		.from(sel.scale) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	focus_tween.tween_property(sel, "modulate:a", 1.0, focus_time) \
		.from(sel.modulate.a)

func _spin_to(step: int) -> void:
	var total := skins.get_child_count()
	if total == 0:
		return

	selected_id = wrapi(selected_id + step, 0, total)

	# Drehe zum Zielwinkel, berechnet aus dem Index
	var target_angle = -selected_id * TAU / total

	if rot_tween and rot_tween.is_running():
		rot_tween.kill()
	rot_tween = create_tween()
	rot_tween.tween_property(self, "angle_offset", target_angle, turn_time) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	rot_tween.finished.connect(func(): _focus(selected_id))

# Hilfsfunktion: Wrapt einen Integer-Wert innerhalb [min_val, max_val)
func wrapi(value: int, min_val: int, max_val: int) -> int:
	var range := max_val - min_val
	if range == 0:
		return min_val
	var wrapped := (value - min_val) % range
	if wrapped < 0:
		wrapped += range
	return min_val + wrapped

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/titleScreen.tscn")

func _on_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels2.0.tscn")
