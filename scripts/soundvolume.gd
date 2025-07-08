extends Control

@onready var music_slider = $MusicSlider
@onready var sfx_slider = $SFXSlider

func _ready():
	var music_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	var sfx_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))

	music_slider.value = inverse_lerp(-60.0, -6.0, music_db)
	sfx_slider.value = inverse_lerp(-60.0, -6.0, sfx_db)

	music_slider.value_changed.connect(_on_music_slider_value_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)

# Custom linear_to_db with capped max volume
func _slider_value_to_db(slider_value: float, min_db: float = -60.0, max_db: float = -6.0) -> float:
	return lerp(min_db, max_db, slider_value)

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
