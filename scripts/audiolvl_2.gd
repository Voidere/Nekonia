extends Node

signal play_music
signal stop_music
signal pause_music

var music_player: AudioStreamPlayer
var is_music_started = false
@export var fade_in_time := 3.0  # seconds

func _ready():
	if not music_player:
		music_player = AudioStreamPlayer.new()
		music_player.bus = "Music"
		add_child(music_player)
		music_player.stream = preload("res://assets/sounds/music/04-Zazou-ft.-Trippin-Jaguar-Octagon-16_44100-Mastered-v3.mp3")
		music_player.volume_db = -80  # start silent

	connect("play_music", Callable(self, "_on_play_music"))
	connect("stop_music", Callable(self, "_on_stop_music"))
	connect("pause_music", Callable(self, "_on_pause_music"))

func _on_play_music():
	if not is_music_started:
		music_player.play()
		is_music_started = true
		_start_fade_in()
		print("Music started.")
	elif music_player.stream_paused:
		music_player.stream_paused = false
		print("Music resumed.")

func _on_stop_music():
	is_music_started = false
	music_player.stop()
	music_player.volume_db = -80  # reset volume for next play

func _on_pause_music():
	if is_music_started:
		music_player.stream_paused = true

# --- Fade-in function ---
func _start_fade_in():
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", 0.0, fade_in_time)
