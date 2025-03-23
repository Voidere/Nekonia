extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"


func _ready():
	color_rect.visible = false
	animation_player.animation_finished.connect(on_animation_finished)
	
func on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		color_rect.visible = false
		
func transition():
	color_rect.visible = true
	animation_player.play("fade_to_black")
	
	
