extends Node

# Signal to be emitted by the allowed scenes
signal play_music
signal stop_music
signal pause_music

var music_player: AudioStreamPlayer
var is_music_started = false

func _ready():
	# Initialize the music player if not already initialized
	if not music_player:
		music_player = AudioStreamPlayer.new()
		music_player.bus = "Music"
		add_child(music_player)
		music_player.stream = preload("res://assets/sounds/music/04 - Zazou ft. Trippin Jaguar - Octagon 16_44100 Mastered v3.wav")

	# Correctly connect the signals to the functions
	connect("play_music", Callable(self, "_on_play_music"))
	connect("stop_music", Callable(self, "_on_stop_music"))
	connect("pause_music", Callable(self, "_on_pause_music"))


# This function is triggered when the "play_music" signal is emitted
func _on_play_music():
	if not is_music_started:
		music_player.play()  # Start playing from the beginning
		is_music_started = true
		print("Music started.")
	elif music_player.stream_paused:
		music_player.stream_paused = false  # Resume playback
		print("Music resumed.")

# This function is triggered when the "stop_music" signal is emitted
func _on_stop_music():
	is_music_started = false
	music_player.stop()

func _on_pause_music():
	if is_music_started:
		music_player.stream_paused = true
