extends Control

@onready var NetworkGateway = $"NetworkGateway"

func _on_connect_toggled(toggled_on):
	NetworkGateway.simple_webrtc_connect($Roomname.text)
