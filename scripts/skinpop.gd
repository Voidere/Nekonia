extends PopupPanel

# To store the skin currently offered
var offered_skin = ""
var player

# Connect buttons to their respective actions
@onready var label = $MarginContainer/VBoxContainer/Label
@onready var equip_button = $MarginContainer/VBoxContainer/equip
@onready var cancel_button = $MarginContainer/VBoxContainer/cancel

# Signal for when the player decides to equip the skin
signal skin_equip_requested(skin)


func _ready():
	equip_button.connect("pressed", Callable(self, "_on_equip_button_pressed"))
	cancel_button.connect("pressed", Callable(self, "_on_cancel_button_pressed"))
	Engine.time_scale = 0

# Function to show the popup with the skin message
func show_skin_popup(skin: String):
	offered_skin = skin
	label.text = "You found a new skin: %s!\nDo you want to equip it?" % skin
	self.popup_centered()
	Engine.time_scale = 0 # Show the popup at the center of the screen

# Function to handle the signal from the ches

# Function called when the "Equip" button is pressed
func _on_equip_button_pressed():
	print("Equip button pressed, emitting signal for skin: ", offered_skin)
	emit_signal("skin_equip_requested", offered_skin)
	Global.save_game_data()
	hide()
	Engine.time_scale = 1 # Hide the popup after equipping

# Function called when the "Cancel" button is pressed
func _on_cancel_button_pressed():
	hide()
	Engine.time_scale = 1 # Simply hide the popup without doing anything


func _on_chest_chest_opened(skin: String):
	print("Popup should show for skin: ", skin)  # Debug line
	show_skin_popup(skin)
	
