extends CharacterBody2D


const SPEED = 175.0
const JUMP_VELOCITY = -320.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var hearts_parent = get_node_or_null("$healtyhbarplayer/HBoxContainer")

var onLadder = false
var current_skin = "default"
var popup: PopupPanel

var hearts_list : Array[TextureRect]
var health = 3

func _ready():
	Global.connect("skin_equip_requested", Callable(self, "_on_skin_equip_requested"))
	change_skin(Global.current_skin) 
	if hearts_parent:
		for child in hearts_parent.get_children():
			hearts_list.append(child)
		print(hearts_list)
	else:
		return

func _on_skin_equip_requested(skin: String):
	Global.current_skin = skin
	change_skin(skin)

func change_skin(skin: String):
	current_skin = skin
	match skin:
		"whitecat":
			animated_sprite.frames = preload("res://assets/game/player1.tres")
			animated_sprite.play("idle")
		"OrangeCat":
			animated_sprite.frames = preload("res://assets/game/player2.tres")
			animated_sprite.play("idle")
		"blackcat":
			animated_sprite.frames = preload("res://assets/game/player3.tres")
			animated_sprite.play("idle")
		"wintercat":
			animated_sprite.frames = preload("res://assets/game/player7.tres")
			animated_sprite.play("idle")
		"sylvester":
			animated_sprite.frames = preload("res://assets/game/player5.tres")
			animated_sprite.play("idle")


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

	var direction := Input.get_axis("move_left", "move_right")

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
