extends Control

@onready var music_slider = $MusicSlider
@onready var sfx_slider = $SFXSlider

# db range
const MIN_DB = -60.0
const MAX_DB = 0.0

func _ready():
	var music_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	var sfx_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))

	# Map current bus dB to slider value (0..1)
	music_slider.value = inverse_lerp(MIN_DB, MAX_DB, music_db)
	sfx_slider.value = inverse_lerp(MIN_DB, MAX_DB, sfx_db)

	music_slider.value_changed.connect(_on_music_slider_value_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)

func _slider_value_to_db(slider_value: float) -> float:
	return lerp(MIN_DB, MAX_DB, slider_value)

func _on_music_slider_value_changed(value):
	var db_value = _slider_value_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db_value)
	print("Music dB:", db_value)
	Global.save_game_data()

func _on_sfx_slider_value_changed(value):
	var db_value = _slider_value_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db_value)
	print("SFX dB:", db_value)
	Global.save_game_data()
