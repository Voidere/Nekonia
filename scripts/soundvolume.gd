extends Control

@onready var music_slider = $MusicSlider
@onready var sfx_slider = $SFXSlider

func _ready():
	# Lade gespeicherte Lautstärken (falls vorhanden)
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))

	# Verbinde die Slider mit der Funktion
	music_slider.value_changed.connect(_on_music_slider_value_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)

func _on_music_slider_value_changed(value):
	var db_value = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db_value)
	print(db_value)
	Global.save_game_data()

func _on_sfx_slider_value_changed(value):
	var db_value = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db_value)
	Global.save_game_data()
