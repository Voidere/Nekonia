extends Node

# Signal to be emitted by the allowed scenes
signal play_music
signal stop_music

var music_player: AudioStreamPlayer
var is_music_started = false

func _ready():
	# Initialize the music player if not already initialized
	if not music_player:
		music_player = AudioStreamPlayer.new()
		add_child(music_player)
		music_player.stream = preload("res://assets/sounds/music/4. Constantihn Lange - Timelapse.wav")

	# Correctly connect the signals to the functions
	# `self` refers to the current instance (music manager)
	connect("play_music", Callable(self, "_on_play_music"))
	connect("stop_music", Callable(self, "_on_stop_music"))

# This function is triggered when the "play_music" signal is emitted
func _on_play_music():
	if not is_music_started:
		music_player.play()
		is_music_started = true
		print("Music started.")

# This function is triggered when the "stop_music" signal is emitted
func _on_stop_music():
	if is_music_started:
		music_player.stop()
		is_music_started = false
		print("Music stopped.")
