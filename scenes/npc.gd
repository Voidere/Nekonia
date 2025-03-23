extends Node2D


const SPEED = 60

var direction = 1

@onready var ray_castright: RayCast2D = $RayCastright
@onready var ray_cast_2_left: RayCast2D = $RayCast2left
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_castright.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
	if ray_cast_2_left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
	position.x += direction * SPEED * delta
