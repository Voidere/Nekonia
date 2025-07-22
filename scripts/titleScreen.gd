extends Control

func _on_start_button_pressed() -> void:
	AudioManager.play_button_click()
	await get_tree().create_timer(0.15).timeout
	get_tree().change_scene_to_file("res://scenes/levels2.0.tscn")
	
func _on_quit_pressed() -> void:
	AudioManager.play_back_button_click()
	await get_tree().create_timer(0.15).timeout
	get_tree().quit()

func _on_credits_pressed() -> void:
	AudioManager.play_button_click()
	await get_tree().create_timer(0.15).timeout
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func _on_youtube_pressed() -> void:
	AudioManager.play_button_click()
	await get_tree().create_timer(0.15).timeout
	OS.shell_open("https://www.youtube.com/@LunarDriftStudios")

func _on_tiktiok_pressed() -> void:
	AudioManager.play_button_click()
	await get_tree().create_timer(0.15).timeout
	OS.shell_open("https://www.tiktok.com/@lunardrift.studio")

func _on_discord_pressed() -> void:
	AudioManager.play_button_click()
	await get_tree().create_timer(0.15).timeout
	OS.shell_open("https://discord.gg/pw2dvBJFnn")

func _on_settings_pressed() -> void:
	AudioManager.play_button_click()
	await get_tree().create_timer(0.15).timeout
	get_tree().change_scene_to_file("res://scenes/options.tscn")

func _on_skins_pressed() -> void:
	AudioManager.play_button_click()
	await get_tree().create_timer(0.15).timeout
	get_tree().change_scene_to_file("res://scenes/skin_carousel.tscn")
