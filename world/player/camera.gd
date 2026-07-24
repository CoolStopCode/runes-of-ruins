extends Camera2D

var shake_strength: float = 0.0
var shake_duration: float = 0.0
var shake_timer: float = 0.0

func _process(delta: float) -> void:
	if shake_timer > 0.0:
		shake_timer -= delta
		var t: float = clamp(shake_timer / shake_duration, 0.0, 1.0)
		var current_strength: float = shake_strength * t
		offset = Vector2(
			randf_range(-current_strength, current_strength),
			randf_range(-current_strength, current_strength)
		)
		if shake_timer <= 0.0:
			offset = Vector2.ZERO
	else:
		offset = Vector2.ZERO

func camera_shake(strength: float, duration: float) -> void:
	shake_strength = strength
	shake_duration = duration
	shake_timer = duration
