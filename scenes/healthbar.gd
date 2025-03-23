extends ProgressBar

@onready var timer: Timer = $Timer
@onready var damagebar: ProgressBar = $damagebar



var health = 0 : set = _set_health


func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		queue_free()
		
	if health < prev_health:
		timer.start()
	else:
		damagebar.value = health


func init_health(_health):
	health = _health
	max_value = health
	value = health
	damagebar.max_value = health
	damagebar.value = health
	

func _on_timer_timeout() -> void:
	damagebar.value = health
