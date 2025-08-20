extends CharacterBody2D

@export var SPEED = 175.0
@export var JUMP_VELOCITY = -320.0
@export var swing_force = 400.0
@export var swing_interval = 1.3

@onready var animated_sprite = $AnimatedSprite2D
@onready var hearts_parent = $healtyhbarplayer/HBoxContainer
@onready var rope_detector = $RopeDetector

var onLadder = false
var current_skin = "default"
var hearts_list: Array[TextureRect] = []
var health = 3

# Grab Variables
var grabbed_joint: PinJoint2D = null
var grabbed_segment: RigidBody2D = null

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

func _physics_process(delta: float) -> void:
	# ---------------------
	# Grab / Release Logic
	# ---------------------
	if Input.is_action_just_pressed("use"):
		if grabbed_joint:
			# Release
			grabbed_joint.queue_free()
			grabbed_joint = null
			grabbed_segment = null
			onLadder = false
		else:
			# Check for overlapping vine segments
			var bodies = rope_detector.get_overlapping_bodies()
			for body in bodies:
				if body.is_in_group("vine_segment"):
					grabbed_segment = body
					# Create PinJoint2D
					grabbed_joint = PinJoint2D.new()
					grabbed_joint.node_a = self.get_path()
					grabbed_joint.node_b = grabbed_segment.get_path()
					grabbed_joint.position = global_position
					grabbed_joint.softness = 1.0 # Sanfte Verbindung
					get_parent().add_child(grabbed_joint)
					onLadder = true
					break

	# ---------------------
	# Hanging / Swinging
	# ---------------------
	if grabbed_joint and grabbed_segment:
		# Stop rotation
		rotation = 0

		# Soft follow
		global_position = global_position.move_toward(grabbed_segment.global_position, 15 * delta)
		velocity = Vector2.ZERO

		# Swing with left/right input (sanfter Anschub)
		if Input.is_action_pressed("move_left"):
			grabbed_segment.apply_central_impulse(Vector2(-swing_force * delta * 0.2, 0))
		if Input.is_action_pressed("move_right"):
			grabbed_segment.apply_central_impulse(Vector2(swing_force * delta * 0.2, 0))

		# Animation
		animated_sprite.play("climb")
		return  # Skip normal movement while hanging

	# ---------------------
	# Normal movement / Ladder
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

	# Jump from floor
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get input direction
	var direction := Input.get_axis("move_left", "move_right")

	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# ---------------------
	# Animations
	# ---------------------
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

	# Movement
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Physics interaction with RigidBody2D
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			var impulse = velocity * collider.mass * 0.05 # nur sanfter Anschub
			collider.apply_central_impulse(impulse)

func take_damage():
	if health > 0:
		health -= 1
		animated_sprite.play("take_damage")
		update_heart_display()

func update_heart_display():
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < health
