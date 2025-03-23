extends CharacterBody2D

const SPEED = 50.0
const GRAVITY = 800.0  

enum State { IDLE, CHASING, ATTACKING_MELEE, ATTACKING_RANGE, FLEEING }
var state = State.IDLE

@export var max_lives: int = 4
var current_lives: int

@export var melee_cooldown: float = 3.0
@export var shoot_cooldown: float = 3.0

@export var max_player_hits: int = 3  # Maximal erlaubte Treffer für den Spieler
var player_hit_count: int = 0
var flee_speed = 250.0
var flee_target_x = 2500.0
var boost_strength = 300.0
var gravity_enabled = true

@onready var damage: Area2D = $damage
@onready var health_bar: ProgressBar = $"../Player/CanvasLayer2/Healthbar"
@onready var melee_timer = $MeleeTimer
@onready var shoot_timer = $ShootTimer
@onready var animated_sprite = $AnimatedSprite2D
@onready var melee_area = $MeleeArea
@onready var range_area = $RangeArea
@onready var sigma_area = $sigma
@onready var main = $"../"
@onready var player: CharacterBody2D = $"../Player"
@onready var label: Label = $"../Player/CanvasLayer2/Label"
@onready var npc: CharacterBody2D = $"../CharacterBody2D"

#var player: Node = null
var player_in_melee_area = false
var player_in_range_area = false
var player_in_sigma_area = false
var is_attacking = false
var once = false

@onready var bullet_scene = preload("res://scenes/bulett.tscn")  # Bullet scene path

func _ready(): 
	label.visible = false
	current_lives = max_lives
	if health_bar:
		health_bar.init_health(max_lives)  # Initialize the health bar
		print("Health bar initialized with:", max_lives)
	melee_timer.wait_time = melee_cooldown
	shoot_timer.wait_time = shoot_cooldown
	play_animation("idle")

func _physics_process(delta: float) -> void:
	apply_gravity(delta)

	if state == State.FLEEING:
		return

	if player_in_melee_area:
		state = State.ATTACKING_MELEE
	elif player_in_range_area:
		state = State.ATTACKING_RANGE
	elif player:
		state = State.CHASING
	else:
		state = State.IDLE  # Reset to idle if no player interaction

	match state:
		State.IDLE:
			play_animation("idle")
		State.CHASING:
			if state != State.FLEEING:
				move_towards_player(delta)
		State.ATTACKING_MELEE:
			if state != State.FLEEING:
				perform_melee_attack()
		State.ATTACKING_RANGE:
			if state != State.FLEEING:
				perform_ranged_attack()

	update_sprite_direction()

func update_sprite_direction():
	if player:
		animated_sprite.flip_h = player.position.x > position.x

func apply_gravity(delta: float):
	if gravity_enabled and not is_on_floor():
		velocity.y += GRAVITY * delta
	move_and_slide()

func move_towards_player(delta):
	if once:
		if state != State.FLEEING:
			if player and not player_in_melee_area:
				var direction_to_player = (player.position - position).normalized()
				velocity.x = direction_to_player.x * SPEED
				move_and_slide()
				play_animation("run")

func perform_melee_attack():
	if melee_timer.is_stopped():
		register_player_hit()
		play_animation("melee")
		melee_timer.start()
		play_animation("idle")

func perform_ranged_attack():
	if state != State.FLEEING:
		if sigma_area and shoot_timer.is_stopped():
			play_animation("idle")
			play_animation("range")
			spawn_bullet()
			shoot_timer.start()
			play_animation("idle")
		state = State.IDLE

func spawn_bullet():
	if state != State.FLEEING:
		if player:
			var bullet = bullet_scene.instantiate()
			bullet.position = position
			bullet.direction = (player.position - position).normalized()
			bullet.connect("body_entered", Callable(self, "_on_bullet_body_entered"))
			get_parent().add_child(bullet)

# Spieler betritt Nahkampfbereich
func _on_melee_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		play_animation("melee")
		player_in_melee_area = true

func _on_melee_area_body_exited(body: Node) -> void:
	if body.name == "Player":
		player_in_melee_area = false
		once = true

# Spieler betritt Fernkampfbereich
func _on_range_area_body_entered(body: Node) -> void:
	if state != State.FLEEING:
		if body.name == "Player":
			play_animation("idle")
			velocity.x = 0
			move_and_slide()
			player = body
			player_in_range_area = true
			once = true

func _on_range_area_body_exited(body: Node) -> void:
	if state != State.FLEEING:
		if body.name == "Player":
			player_in_range_area = false
			state = State.CHASING

func lose_life():
	current_lives -= 1
	play_animation("schaden")
	
	if health_bar:
		health_bar.health = current_lives
	if current_lives == int(max_lives / 2) and state != State.FLEEING:
		start_cutscene()
	elif current_lives <= 0:
		die()


func start_cutscene():
	animated_sprite.flip_h = true
	disable_interaction()
	state = State.FLEEING
	play_animation("run")
	gravity_enabled = false
	velocity.x = flee_speed * sign(flee_target_x - position.x)
	animated_sprite.flip_h = true  
	label.visible = true
	await get_tree().create_timer(2.0).timeout
	label.visible = false

	# Make the boss move towards the flee target
	while abs(position.x - flee_target_x) > 10.0:
		position.x += velocity.x * get_process_delta_time()
		await get_tree().create_timer(0.02).timeout
	finish_fleeing()

func finish_fleeing():
	enable_interaction()
	shoot_timer.stop()
	gravity_enabled = true
	set_physics_process(true)  # Reactivate physics after fleeing
	play_animation("idle")
	velocity.x = 0
	state = State.IDLE  

func die():
	damage.queue_free()
	play_animation("die")
	await get_tree().create_timer(1.0).timeout
	queue_free()
	main.win()
	npc.win()

func play_animation(animation_name: String):
	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)
	update_sprite_direction()

func _on_shoot_timer_timeout():
	if state != State.FLEEING and sigma_area:
		shoot_timer.start()
		play_animation("range")
		await get_tree().create_timer(1.0).timeout
		spawn_bullet()
		play_animation("idle")

# Spieler Treffer registrieren
func register_player_hit():
	player.take_damage()
	player_hit_count += 1

	if player_hit_count >= max_player_hits:
		await get_tree().create_timer(0.4).timeout
		reload_scene()

func reload_scene():
	var _current_scene = get_tree().current_scene
	get_tree().reload_current_scene()

# Treffer durch das Projektil
func _on_bullet_body_entered(body: Node):
	if body.name == "Player":
		register_player_hit()

func _on_damage_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		lose_life()
		apply_boost(player)

func apply_boost(player: Node):
	if player is CharacterBody2D:
		player.velocity.y = -boost_strength
		player.velocity.x = -boost_strength  # Apply a negative value to go up


func _on_melee_timer_timeout() -> void:
	if state != State.FLEEING and player_in_melee_area:
		play_animation("melee")
		register_player_hit()
		melee_timer.start()
		await get_tree().create_timer(1.0).timeout
		play_animation("idle")


func _on_sigma_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		sigma_area = false

func disable_interaction():
	collision_layer = 4
	collision_mask = 4

func enable_interaction():
	collision_layer = 1
	collision_mask = 1


func _on_sigma_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		sigma_area = true
