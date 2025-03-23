extends Node2D

const SPEED = 60
const VERTICAL_SPEED = 30
const MAX_FLY_HEIGHT = 10  # Maximum distance the enemy can fly above the spawn point
const MIN_FLY_HEIGHT = 10   # Minimum distance the enemy can fly below the spawn point
const MAX_TRAVEL_DISTANCE = 300  # Maximum horizontal travel distance before turning

var direction = 1
var vertical_direction = 1
var travel_distance = 0  # Keep track of horizontal movement distance
var spawn_y = 0  # Store the spawn Y position

@onready var raycastright: RayCast2D = $Raycastright
@onready var raycastleft: RayCast2D = $Raycastleft
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var enemy_area: Area2D = $Area2D # Reference to Area2D for collision

func _ready():
	# Store the initial Y position when the enemy spawns
	spawn_y = position.y
	travel_distance = 0

func _process(delta: float) -> void:
	# Handle horizontal collision detection with raycasts
	if raycastright.is_colliding() or raycastleft.is_colliding():
		direction = -direction
		animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h

	# Move the enemy horizontally
	position.x += direction * SPEED * delta
	travel_distance += abs(direction * SPEED * delta)

	# If the enemy has traveled beyond the allowed distance, change direction
	if travel_distance >= MAX_TRAVEL_DISTANCE:
		direction = -direction
		animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
		travel_distance = 0  # Reset the travel distance

	# Vertical movement (up and down relative to the spawn position)
	var max_y = spawn_y + MAX_FLY_HEIGHT
	var min_y = spawn_y - MIN_FLY_HEIGHT

	if position.y >= max_y:
		vertical_direction = -1
	elif position.y <= min_y:
		vertical_direction = 1

	position.y += vertical_direction * VERTICAL_SPEED * delta
