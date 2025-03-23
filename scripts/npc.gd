extends CharacterBody2D


const SPEED = 600.0
const GRAVITY = 800
const JUMP_VELOCITY = -400.0
var gravity_enabled = false


func _ready() -> void:
	gravity_enabled = false

func _physics_process(delta: float) -> void:
	apply_gravity(delta)

func apply_gravity(delta: float):
	if gravity_enabled and not is_on_floor():
		velocity.y += GRAVITY * delta
	move_and_slide()

#func _physics_process(delta: float) -> void:
#	# Add the gravity.
#	if not is_on_floor():
#		velocity += get_gravity() * delta
#
#	# Handle jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction := Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func win():
	gravity_enabled = true
	await get_tree().create_timer(3.0).timeout
	move_to_x_only(2700)

func move_to_x_only(new_x: float):
	var target_position = Vector2(new_x, position.y)
	while abs(position.x - target_position.x) > 1.0:  # Solange der NPC noch nicht an der Zielposition ist
		position.x += sign(target_position.x - position.x) * SPEED * get_process_delta_time()
		await get_tree().create_timer(0.02).timeout
	position = target_position
