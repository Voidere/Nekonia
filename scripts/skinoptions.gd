extends Control

@onready var button_whitecat = $whitecat  # Adjust paths to your button nodes
@onready var special_skin_button = $orangecat
@onready var button_blackcat = $blackcat
@onready var wintercat: Button = $wintercat
@onready var sylvester: Button = $sylvester

func _ready():
	# Ensure skins_unlocked is properly initialized
	if not Global.skins_unlocked.has("special_skin"):
		Global.skins_unlocked["special_skin"] = false  # Set default if not present

	# Update the UI based on whether the skin is unlocked
	if Global.skins_unlocked["special_skin"]:
		special_skin_button.disabled = false
	else:
		special_skin_button.disabled = true

	# Connect the skin buttons
	button_whitecat.connect("pressed", Callable(self, "_on_skin_button_pressed").bind("whitecat"))
	special_skin_button.connect("pressed", Callable(self, "_on_skin_button_pressed").bind("OrangeCat"))
	button_blackcat.connect("pressed", Callable(self, "_on_skin_button_pressed").bind("blackcat"))
	sylvester.connect("pressed", Callable(self, "_on_skin_button_pressed").bind("sylvester"))
	wintercat.connect("pressed", Callable(self, "_on_skin_button_pressed").bind("wintercat"))
	
func _on_skin_button_pressed(skin_name: String):
	Global.emit_skin_selection(skin_name)
	Global.save_game_data()
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/titleScreen.tscn")
	Global.save_game_data()
