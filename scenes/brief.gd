extends Node2D

@onready var opened_letter: Node2D = $"../Player/CanvasLayer2/openedletter"
@onready var area2d = $Area2D

func _ready():
	# Ensure the opened letter is hidden initially
	opened_letter.visible = false
	# Connect the Area2D's signals
	area2d.connect("body_entered", Callable( self, "_on_body_entered"))
	area2d.connect("body_exited", Callable( self, "_on_body_exited"))

func _on_body_entered(body):
	if body.name == "Player":  # Replace with your player node's name
		opened_letter.visible = true  # Show the opened letter
		print("Player opened the letter.")

func _on_body_exited(body):
	if body.name == "Player":
		opened_letter.visible = false  # Hide the opened letter
		print("Player closed the letter.")
