extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -200.0

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	print("[Player] Ready - Name: ", name)
	print("[Player] My ID: ", multiplayer.get_unique_id())
	print("[Player] Is Authority: ", is_multiplayer_authority())
	
	# Set the player's input authority based on their ID
	if str(name) == str(multiplayer.get_unique_id()):
		print("[Player] Setting authority to: ", multiplayer.get_unique_id())
		set_multiplayer_authority(multiplayer.get_unique_id())
		# If we're the local player, request spawn from server
		if not multiplayer.is_server():
			get_parent().request_player_spawn.rpc_id(1, multiplayer.get_unique_id())
	else:
		print("[Player] Authority not set - Name doesn't match ID")

func _physics_process(delta):
	# Only process input for the local player
	if not is_multiplayer_authority():
		return
		
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# Synchronize position with other clients
	position_sync.rpc(position)

@rpc("any_peer", "reliable")
func position_sync(new_position: Vector2):
	if not is_multiplayer_authority():
		position = new_position
