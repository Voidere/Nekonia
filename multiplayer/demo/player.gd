extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -200.0

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	print("[Player] Ready - Name: ", name)
	print("[Player] My ID: ", multiplayer.get_unique_id())
	print("[Player] Is Authority: ", is_multiplayer_authority())
	
	# Authority will be set by the level spawner
	# If we're the local player and not the server (i.e., a client), request spawn from server
	# Note: This spawn request might be redundant if the server already spawns clients on peer_connected.
	# However, it can serve as a fallback or for specific scenarios.
	# We need to ensure the parent node (expected to be the level) has 'request_player_spawn'.
	if not multiplayer.is_server() and multiplayer.get_unique_id() == int(name) and get_parent().has_method("request_player_spawn"):
		print("[Player] Client ", name, " requesting spawn.")
		get_parent().request_player_spawn.rpc_id(1, multiplayer.get_unique_id())
	
	if str(name) == str(multiplayer.get_unique_id()):
		print("[Player] This player instance (", name, ") corresponds to my multiplayer ID.")
	else:
		print("[Player] This player instance (", name, ") does NOT correspond to my multiplayer ID (", multiplayer.get_unique_id(), ").")

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
