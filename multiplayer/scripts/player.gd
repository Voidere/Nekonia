extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var syncPos = Vector2(0, 0)
var syncRot = 0.0  # Ensure this is a float

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		# Apply gravity
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle Jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		syncPos = global_position
		syncRot = float(rotation_degrees)  # Ensure it's a float

		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
	else:
		# Ensure proper interpolation for smooth movement
		global_position = global_position.lerp(syncPos, 0.1)
		rotation_degrees = lerp(float(rotation_degrees), syncRot, 0.1)  # Convert to float
