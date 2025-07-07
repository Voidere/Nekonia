extends Control
@onready var start: AudioStreamPlayer = $StartButton/AudioStreamPlayer

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels.tscn")
func _on_quir_pressed() -> void:
	get_tree().quit()
func _on_crdtsbuton_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
func _on_youtube_pressed() -> void:
	OS.shell_open("https://www.youtube.com/@LunarDriftStudios")
func _on_tiktiok_pressed() -> void:
	OS.shell_open("https://www.tiktok.com/@lunardrift.studio")
func _on_discord_pressed() -> void:
	OS.shell_open("https://discord.gg/pw2dvBJFnn")
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")
func _on_skins_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/skinoptions.tscn")
