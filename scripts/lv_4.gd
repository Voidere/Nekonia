extends Button

@export var level_number: int 

func _ready():
	if not LevelManager.is_level_unlocked(level_number + 3):
		disabled = true

func _on_pressed():
#	get_tree().change_scene_to_file("res://scenes/Level4.tscn")
	if not disabled:
		print("Loading Level ", level_number)
		get_tree().change_scene("res://Levels/Level" + str(level_number) + ".tscn")
