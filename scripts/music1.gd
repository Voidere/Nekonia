extends AudioStreamPlayer

@export var fade_in_time := 3.0  # seconds
var initial_volume_db := -80.0  # start very quiet

func _ready():
	volume_db = initial_volume_db  # start quiet
	play()
	fade_in_music(fade_in_time)

func fade_in_music(time: float):
	var tween = create_tween()
	tween.tween_property(self, "volume_db", 0.0, time)  # 0 dB = full volume
