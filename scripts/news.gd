extends PopupPanel

#Dictionary mit Updates
var updates = {
	"Update 1": "Inhalt für Update 1: \n- Neue Levels\n- Neue Skins\n- Bugfixes",
	"Update 2": "Inhalt für Update 2: \n- Neuer Boss\n- Verbesserte Grafik\n- Soundeffekte",
	"Update 3": "Inhalt für Update 3: \n- Mehr Herausforderungen\n- Leistungsverbesserungen",
	"Update 4": "Inhalt für Update 4: \n- Mehr Herausforderungen\n- Leistungsverbesserungen"
}

#Referenzen für die UI-Elemente
@onready var title_label = $HBoxContainer/VBoxContainer2/Label
@onready var description_text = $HBoxContainer/VBoxContainer2/Label2

func _ready():
	# Verbinde die Buttons automatisch
	for i in range(1, 5): # Für Button_Update1 bis Button_Update3
		var button = $".".get_node("Button_Update" + str(i))
		# Erzeuge einen Callable für die Funktion mit einem Argument
		button.connect("pressed", Callable(self, "_on_button_pressed").bind("Update " + str(i)))

#Standardmäßige Anzeige des ersten Updates
	show_update("Update 1")

func _on_button_pressed(update_name: String):
	# Zeige den entsprechenden Text basierend auf dem Button
	show_update(update_name)

func show_update(update_name: String):
	title_label.text = update_name
	description_text.text = updates.get(update_name, "Keine Informationen verfügbar.")
