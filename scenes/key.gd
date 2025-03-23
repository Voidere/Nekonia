extends Node

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $"."
@onready var player: CharacterBody2D = $"../Player"
@onready var doorsp: Sprite2D = $"../doorsp"
@onready var keyarea: CollisionShape2D = $Area2D/keyarea



var keys = 0  # Die Anzahl der Schlüssel
var player_in_door_area = false  # Überprüft, ob der Spieler im Türbereich ist

# Wird ausgelöst, wenn der Spieler in den Schlüsselbereich eintritt
func _on_area_2d_body_entered(body: Node2D) -> void:
		keys += 1  # Schlüssel hinzufügen
		area_2d.queue_free()  # Schlüssel entfernen, nachdem der Spieler ihn aufgenommen hat
		sprite_2d.visible = false
		doorsp.visible = true
		doorsp.z_index = 1
		print("Schlüssel aufgenommen! Du hast jetzt ", keys, " Schlüssel.")
		
# Wird ausgelöst, wenn der Spieler in den Bereich der Tür eintritt
func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body == player:
		player_in_door_area = true
		print("Du bist im Türbereich.")

# Wird ausgelöst, wenn der Spieler den Bereich der Tür verlässt
func _on_area_2d_2_body_exited(body: Node2D) -> void:
		player_in_door_area = false
		print("Du hast den Türbereich verlassen.")

# Wird in jedem Frame aufgerufen, um die Interaktion zu überprüfen
func _process(delta: float) -> void:
	if player_in_door_area: # ui_accept ist standardmäßig auf "E" eingestellt
		if keys > 0:  # Wenn der Spieler einen Schlüssel hat
			keys = 0  # Einen Schlüssel verbrauchen
			sprite_2d.visible = true
			doorsp.visible = false
			doorsp.z_index = 15
			open_door()  # Funktion, um die Tür zu öffnen
			print("Viel spaß im nächsten level")
		else:
			print("Du hast keinen Schlüssel, um die Tür zu öffnen!")

	
# Funktion, um die Tür zu öffnen (hier als Beispiel, du kannst es anpassen)
func open_door():
	print("Tür geöffnet!")
	get_tree().change_scene_to_file("res://scenes/dungeon.tscn")
	# Hier kannst du Animationen oder Änderungen des Zustands der Tür hinzufügen.
	
