extends CharacterBody2D

const SPEED = 175.0
const JUMP_VELOCITY = -320.0
var onLadder = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	
	if str(name) == str(multiplayer.get_unique_id()):
		set_multiplayer_authority(multiplayer.get_unique_id())
	else:
		return



func _physics_process(delta: float) -> void:
	if onLadder:
		if Input.is_action_pressed("jump"):
			velocity.y = -SPEED * 1
		elif Input.is_action_pressed("move_down"):
			velocity.y = SPEED * 1
		else:
			velocity.y = 0
	elif not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	#flip idiot
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	if onLadder:
		animated_sprite.play("climb") 
	elif is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	#move
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	position_sync.rpc(position)

@rpc("any_peer", "reliable")
func position_sync(new_position: Vector2):
	if not is_multiplayer_authority():
		position = new_position
