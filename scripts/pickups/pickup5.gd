### Pickup.gd ###
extends Area2D

var coin_id: String = "5"

@onready var game_manager: Node = %GameManager

func _ready():
	if Global.collected_coins.has(coin_id) and Global.collected_coins[coin_id]:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if not Global.collected_coins.has(coin_id):
		game_manager.add_point()
		Global.mark_coin_as_collected(coin_id)
		queue_free()
