extends Panel

# Dein Theme laden
@onready var custom_theme = preload("res://assets/game/new_theme.tres")

# Dictionary mit Versionsinformationen
var updates = {
	"0.2.1": {"title": "Bugfixes", "description": "Content:\n\n- Bugfixes:\n- Music stopped\n  when you opened\n  the pause menu\n\n  FIXED"},
	"0.2.0": {"title": "Big Update", "description": "Content:\n\n- Levels\n\n- Skins\n\n- Music\n\n- Main menu\n\n- Bugfixes "},
	"0.1.1": {"title": "Bugfixes", "description": "Content:\n\n- Bugfixes\n\n- Small \n  Adjustments"},
	"0.1.0": {"title": "Release", "description": "Content:\n\n- First Level\n\n"}
}

# Referenzen für die UI-Elemente
@onready var title_label = $Label_Title
@onready var description_label = $Label_Description

func _ready():
	# Panel Hintergrund und Randfarbe ändern
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.2, 0.2, 0.2)  # Dunkelgrauer Hintergrund
	panel_style.border_color = Color(0.8, 0.2, 0.2)  # Roter Rand
	
	# Randbreite für jede Seite einstellen
	panel_style.border_width_top = 4
	panel_style.border_width_bottom = 4
	panel_style.border_width_left = 4
	panel_style.border_width_right = 4

	# Panel-Stil anwenden
	self.add_theme_stylebox_override("panel", panel_style)
	
	# Zeige das neueste Update gleich an
	show_update("0.2.1")

func  _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		$".".hide()

func _on_button1_pressed() -> void:
	show_update("0.2.1")

func _on_button_2_pressed() -> void:
	show_update("0.2.0")

func _on_button_3_pressed() -> void:
	show_update("0.1.1")

func _on_button_4_pressed() -> void:
	show_update("0.1.0")

# Zeige das Update an
func show_update(version):
	if updates.has(version):
		title_label.text = updates[version].title  # Titel aus dem Dictionary
		description_label.text = updates[version].description  # Beschreibung aus dem Dictionary
	else:
		title_label.text = "Unbekannte Version"
		description_label.text = "Keine Informationen verfügbar."


func _on_button_5_pressed() -> void:
	$".".hide()
