extends RigidBody2D

var swing_force = 400.0
var swing_interval = 1.3 # Sekunden bis Richtungswechsel
var time_passed = 0.0
var direction = 1

func _physics_process(delta):
	time_passed += delta
	if time_passed >= swing_interval:
		direction *= -1 # Richtung wechseln
		time_passed = 0.0
	
	apply_central_force(Vector2(swing_force * direction, 0))
