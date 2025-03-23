extends Button

@export var level_number: int  

func _ready():
	if not LevelManager.is_level_unlocked(level_number + 2):
		disabled = true

func _on_pressed():
	if not disabled:
		print("Loading Level ", level_number)
		get_tree().change_scene("res://Levels/Level" + str(level_number) + ".tscn")
