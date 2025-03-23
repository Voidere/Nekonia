extends Area2D

@onready var end_pop: Control = $"../Player/CanvasLayer/end_pop"
@onready var timer: Timer = $Timer
#@onready var score_label: Label = $"../Player/CanvasLayer2/Score_label"


func _ready() -> void:
	end_pop.hide()
	
func _on_body_entered(body: Node2D) -> void:
	Engine.time_scale = 0.5
	timer.start()
	

func _on_timer_timeout() -> void:
#	score_label.hide()
	end_pop.show()
	Engine.time_scale = 0
		
#func endpop():
#	if stopped:
#		end_pop.hide()
#		Engine.time_scale = 1
#	else:
#		end_pop.show()
#		
#	stopped = !stopped
