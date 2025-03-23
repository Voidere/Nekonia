extends Button

@export var level_number: int

func _ready():
	if not LevelManager.is_level_unlocked(level_number + 1):
		disabled = true
		print("cock")

func _on_pressed():
	if not disabled:
		print("Loading Level ", level_number)
		get_tree().change_scene("res://scenes/Level" + str(level_number) + ".tscn")
