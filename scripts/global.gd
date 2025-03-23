extends Node

###
var teleportmid = false
var teleportmid2 = false


# Skin Management
var current_skin: String = "default_skin"
var skins_unlocked = {
	"default": true,
	"OrangeCat": false,
	"special_skin": false  # Initially set to false until unlocked
}

signal skin_equip_requested(skin: String)

func _ready():
	# Load game data when the global script is ready
	load_game_data()

func emit_skin_selection(skin: String) -> void:
	emit_signal("skin_equip_requested", skin)
	current_skin = skin

# Score Management
var total_score: int = 0
var is_alive: bool = true

func add_to_total_score(points: int) -> void:
	if is_alive:
		total_score += points
		LevelManager.total_score = total_score
		LevelManager.save_progress()

# Coin Management
var collected_coins = {}  # Persisted coin data across levels
var current_level_collected_coins = {}  # Temporary coins for the current level

func mark_coin_as_collected(coin_id: String) -> void:
	current_level_collected_coins[coin_id] = true

func save_level_coins_to_global() -> void:
	for coin_id in current_level_collected_coins.keys():
		collected_coins[coin_id] = true

# Save game data
func save_game_data() -> void:
	var data = {
		"total_score": total_score,
		"collected_coins": collected_coins,
		"skins_unlocked": skins_unlocked,
		"current_skin": current_skin,
		"unlocked_levels": LevelManager.unlocked_levels,
		"music_volume": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")),
		"sfx_volume": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	}
	
	var file = FileAccess.open("user://progress.save", FileAccess.WRITE)
	if file:
		file.store_line(JSON.stringify(data))
		file.close()
	else:
		print("Failed to save game data.")

# Load game data
func load_game_data() -> void:
	var file = FileAccess.open("user://progress.save", FileAccess.READ)
	if file:
		if not file.eof_reached():
			var line = file.get_line()
			var json = JSON.new()
			var result = json.parse(line)
			if result == OK:
				var save_data = json.get_data()
				total_score = save_data.get("total_score", 0)
				collected_coins = save_data.get("collected_coins", {})
				#Load skins_unlocked and check if the special_skin is there, else default to false
				skins_unlocked = save_data.get("skins_unlocked", {"default": true, "OrangeCat": false, "special_skin": false})
				current_skin = save_data.get("current_skin", "default_skin")
				LevelManager.unlocked_levels = save_data.get("unlocked_levels", [true, false, false, false, false])
				var music_vol = save_data.get("music_volume", 0)
				var sfx_vol = save_data.get("sfx_volume", 0)
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_vol)
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx_vol)
			else:
				_generate_default_save()
		else:
			_generate_default_save()
		file.close()
	else:
		_generate_default_save()

func _generate_default_save():
	# Set the default unlocked skins and levels
	skins_unlocked = {"default": true, "OrangeCat": false, "special_skin": false}
	total_score = 0
	collected_coins = {}
	LevelManager.unlocked_levels = [true, false, false, false, false]
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), 0)
	save_game_data()

func _exit_tree():
	save_game_data()  
