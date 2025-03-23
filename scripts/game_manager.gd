extends Node

var score = 0

@onready var score_label: Label = $"../Player/CanvasLayer2/Score_label"

func add_point():
	score += 1
	score_label.text = "Score " + str(score)

func reset_score():
	score = 0
	score_label.text = "Score " + str(score)
