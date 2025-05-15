extends Control

@onready var score_label = $Label  # Adjust the path to your Label node
@onready var lv_4: Button = $lv4
@onready var lv_3: Button = $lv3
@onready var lv_6: Button = $lv6

func _ready():
	update_score_display()
	lv_6.disabled = true

func update_score_display():
	score_label.add_theme_color_override("font_color", Color(0, 0, 0, 1))
	score_label.text = "Total Score: %d" % Global.total_score

# In your level select scene script
func setup_level_buttons():
	for level_number in range(LevelManager.unlocked_levels.size()):
		var button = get_node("lv" + str(level_number + 1))
		if level_number == 2:  # Winter Level is lv4 (index 3)
			button.disabled = not (LevelManager.unlocked_levels[0] and LevelManager.unlocked_levels[1] and LevelManager.unlocked_levels[2])
		else:
			button.disabled = not LevelManager.is_level_unlocked(level_number)
		print("Level", level_number + 1, "button setup.")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_lv_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Level1.tscn")


func _on_lv_2_pressed() -> void:
		get_tree().change_scene_to_file("res://scenes/Level2.tscn")



func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/titleScreen.tscn")


func _on_lv_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Level3.tscn")


func _on_lv_4_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Level4.tscn")


func _on_multi_pressed() -> void:
	get_tree().change_scene_to_file("res://multiplayermqtt/mainmenu.tscn")


func _on_local_pressed() -> void:
	get_tree().change_scene_to_file("res://localmultiplayer/scenes/multiplayerScene.tscn")
