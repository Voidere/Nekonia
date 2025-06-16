extends Node2D

func _enter_tree():
	print("[DummyPlayer] '", name, "' _enter_tree. My Multiplayer ID: ", multiplayer.get_unique_id(), ". Is Authority: ", is_multiplayer_authority())

func _ready():
	print("[DummyPlayer] '", name, "' _ready. My Multiplayer ID: ", multiplayer.get_unique_id(), ". Is Authority: ", is_multiplayer_authority())
	if is_multiplayer_authority():
		print("[DummyPlayer] '", name, "' HAS AUTHORITY!")
	else:
		print("[DummyPlayer] '", name, "' DOES NOT HAVE AUTHORITY.")
