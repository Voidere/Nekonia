extends Area2D

@export var speed: float = 400.0
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float):
	position += direction * speed * delta

func _on_body_entered(body: Node):
	if body.name == "Player":
		print("Bullet hit the player!")
		queue_free()  # Destroy the bullet after a hita
