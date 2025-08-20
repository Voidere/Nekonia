# rope_segment.gd
extends RigidBody2D

@export var swing_force = 300.0
@export var swing_interval = 1.3

var time_passed = 0.0
var direction = 1

func _ready():
	add_to_group("vine_segment") # wichtig für den Player

func _physics_process(delta):
	time_passed += delta
	if time_passed >= swing_interval:
		direction *= -1
		time_passed = 0.0
		apply_central_impulse(Vector2(swing_force * direction, 0))
