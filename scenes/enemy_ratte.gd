extends Node2D

const SPEED = 160

var direction = 1

@onready var raycastright: RayCast2D = $raycastright
@onready var raycastleft: RayCast2D = $raycastleft
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if raycastright.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = false
	if raycastleft.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = true
	position.x += direction * SPEED * delta
