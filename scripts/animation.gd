extends CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"



func _on_area_2d_body_entered(_body: Node2D) -> void:
		animated_sprite_2d.play("enter") 

func _on_area_2d_body_exited(_body):
	animated_sprite_2d.play("exit")  # Spielt die Rückwärtsanimation ab, wenn ein Objekt die Area2D verlässt
