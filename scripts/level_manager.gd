### LevelManager.gd ###
extends Node

var unlocked_levels = [true, false, false, false, false, false ]
var total_score = 0

func unlock_level(level_number):
	if level_number < unlocked_levels.size():
		unlocked_levels[level_number] = true
		save_progress()

func is_level_unlocked(level_number):
	return level_number < unlocked_levels.size() and unlocked_levels[level_number]

func save_progress():
	var file = FileAccess.open("user://progress.save", FileAccess.WRITE)
	if file:
		var save_data = {
			"total_score": Global.total_score,
			"unlocked_levels": unlocked_levels,
			"collected_coins": Global.collected_coins
		}
		file.store_line(JSON.stringify(save_data))
		file.close()

func load_progress():
	var file = FileAccess.open("user://progress.save", FileAccess.READ)
	if file:
		if not file.eof_reached():
			var line = file.get_line()
			var json = JSON.new()
			var result = json.parse(line)
			if result == OK:
				var save_data = json.get_data()
				unlocked_levels = save_data.get("unlocked_levels", unlocked_levels)
				Global.total_score = save_data.get("total_score", 0)
				Global.collected_coins = save_data.get("collected_coins", {})
			else:
				_generate_default_save()
		else:
			_generate_default_save()
		file.close()
	else:
		_generate_default_save()

func _generate_default_save():
	unlocked_levels = [true, false, false, false, false, false ]
	Global.total_score = 0
	Global.collected_coins = {}
	save_progress()

# Function to check if Winter Level should be unlocked
#func check_winter_level_unlock():
#	if unlocked_levels[0] and unlocked_levels[1] and unlocked_levels[2]:
#		unlocked_levels[3] = true  # Unlock Winter Level (lv4)
#		save_progress()  # Save the progress after unlocking Winter Level
#		print("Winter Level unlocked!")
#	else:
#		print("Winter Level still locked.")


func _ready():
	load_progress()
