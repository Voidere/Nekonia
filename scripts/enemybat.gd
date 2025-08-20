extends Node2D

const SPEED = 60
const VERTICAL_SPEED = 30
const MAX_FLY_HEIGHT = 10   # Distance above spawn point
const MIN_FLY_HEIGHT = 10   # Distance below spawn point
const MAX_TRAVEL_DISTANCE = 300  # Max horizontal travel distance before turning
const VERTICAL_MARGIN = 1.0  # Small tolerance to prevent jitter at boundaries

var direction: int = 1
var vertical_direction: int = 1
var travel_distance: float = 0.0
var spawn_y: float = 0.0

@onready var raycastright: RayCast2D = $Raycastright
@onready var raycastleft: RayCast2D = $Raycastleft
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var enemy_area: Area2D = $Area2D

func _ready() -> void:
	# Store the initial Y position when the enemy spawns
	spawn_y = position.y
	travel_distance = 0

func _process(delta: float) -> void:
	# Handle horizontal collision detection with raycasts (only if moving towards them)
	if raycastright.is_colliding() and direction > 0:
		direction = -1
		animated_sprite_2d.flip_h = true
	elif raycastleft.is_colliding() and direction < 0:
		direction = 1
		animated_sprite_2d.flip_h = false

	# Move the enemy horizontally
	position.x += direction * SPEED * delta
	travel_distance += abs(direction * SPEED * delta)

	# If the enemy has traveled beyond the allowed distance, change direction
	if travel_distance >= MAX_TRAVEL_DISTANCE:
		direction = -direction
		animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
		travel_distance = 0  # Reset the travel distance

	# Vertical movement (up and down relative to the spawn position)
	var max_y: float = spawn_y + MAX_FLY_HEIGHT
	var min_y: float = spawn_y - MIN_FLY_HEIGHT

	if position.y >= max_y - VERTICAL_MARGIN:
		vertical_direction = -1
	elif position.y <= min_y + VERTICAL_MARGIN:
		vertical_direction = 1

	position.y += vertical_direction * VERTICAL_SPEED * delta
