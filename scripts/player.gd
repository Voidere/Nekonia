extends CharacterBody2D

const SPEED = 175.0
const JUMP_VELOCITY = -320.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var hearts_parent = get_node_or_null("$healtyhbarplayer/HBoxContainer")

var onLadder = false
var current_skin = "default"
var popup: PopupPanel

var hearts_list: Array[TextureRect] = []
var health = 3

# Rope variables
var grab_joint: PinJoint2D = null
var grabbed_rope: RigidBody2D = null

func _ready():
	Global.connect("skin_equip_requested", Callable(self, "_on_skin_equip_requested"))
	change_skin(Global.current_skin)
	
	if hearts_parent:
		for child in hearts_parent.get_children():
			hearts_list.append(child)

func _on_skin_equip_requested(skin: String):
	Global.current_skin = skin
	change_skin(skin)

func change_skin(skin: String):
	current_skin = skin
	match skin:
		"whitecat":
			animated_sprite.frames = preload("res://assets/game/player1.tres")
		"OrangeCat":
			animated_sprite.frames = preload("res://assets/game/player2.tres")
		"blackcat":
			animated_sprite.frames = preload("res://assets/game/player3.tres")
		"wintercat":
			animated_sprite.frames = preload("res://assets/game/player7.tres")
		"sylvester":
			animated_sprite.frames = preload("res://assets/game/player5.tres")
	animated_sprite.play("idle")

func _on_player_died():
	Global.is_alive = false
	animated_sprite.play("die")

# Rope helper functions
func grab_rope(rope_segment: RigidBody2D):
	if grab_joint: 
		return
	grabbed_rope = rope_segment
	grab_joint = PinJoint2D.new()
	grab_joint.node_a = get_path()
	grab_joint.node_b = rope_segment.get_path()
	get_parent().add_child(grab_joint)
	velocity = Vector2.ZERO

func release_rope():
	if grab_joint:
		grab_joint.queue_free()
	grab_joint = null
	grabbed_rope = null

func _physics_process(delta: float) -> void:
	# ---------------------
	# Ladder / normal movement
	# ---------------------
	if onLadder:
		if Input.is_action_pressed("jump"):
			velocity.y = -SPEED
		elif Input.is_action_pressed("move_down"):
			velocity.y = SPEED
		else:
			velocity.y = 0
	elif not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump from floor
	if Input.is_action_just_pressed("jump") and is_on_floor() and not grabbed_rope:
		velocity.y = JUMP_VELOCITY

	# Get input direction
	var direction := Input.get_axis("move_left", "move_right")

	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# ---------------------
	# Rope-hanging logic
	# ---------------------
	if grab_joint and grabbed_rope:
		# Spieler beeinflusst das Rope physikalisch
		if direction != 0:
			grabbed_rope.apply_central_impulse(Vector2(direction * 50, 0))
		# Spieler kann abspringen
		if Input.is_action_just_pressed("jump"):
			release_rope()
		# Leichte seitliche Bewegung auf Rope
		velocity.x = direction * SPEED * 0.5
		velocity += get_gravity() * delta
		move_and_slide()
		return  # Skip normal movement while on rope

	if onLadder:
		if velocity.y != 0:  
			animated_sprite.play("climb")
		else:
			animated_sprite.play("climb_idle")
	elif is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")


	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# ---------------------
	# Physics interaction with RigidBody2D
	# ---------------------
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			var impulse = velocity * collider.mass * 0.1
			collider.apply_central_impulse(impulse)

func take_damage():
	if health > 0:
		health -= 1
		animated_sprite.play("take_damage")
		update_heart_display()

func update_heart_display():
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < health
