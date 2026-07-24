extends Level

@export var sprite1 : AnimatedSprite2D
@export var jump_mini : Sprite2D
@export var jump_particles : GPUParticles2D
@export var right_mini : Sprite2D
@export var right_particles : GPUParticles2D

var frame : int = 1

func clock():
	if frame == 0:
		sprite1.position += Vector2(-16, 16)
		fade_sprite1(0.4, 0.4)
		fade_jump(1.0, 0.5)
	if frame == 1:
		sprite1.play("jump", 3 * (1 / (clock_interval / 4)))
		move_sprite1(Vector2(0, -16), (clock_interval / 4))
		fade_jump(0.0, 0.0)
		jump_particles.emitting = true
		fade_right(1.0, 0.5)
	if frame == 2:
		sprite1.play("walk", 3 * (1 / (clock_interval / 4)))
		move_sprite1(Vector2(16, 0), (clock_interval / 4))
		fade_right(0.0, 0.0)
		right_particles.emitting = true
	if frame == 3:
		fade_sprite1(0.0, 0.4)
		frame = -1
	frame += 1

func move_sprite1(to : Vector2, duration : float):
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite1, "position", sprite1.position + to, duration)
	await tween.finished
	sprite1.play("idle", 0)

func fade_sprite1(to : float, duration : float):
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite1, "self_modulate:a", to, duration)

func fade_jump(to : float, duration : float):
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(jump_mini, "self_modulate:a", to, duration)

func fade_right(to : float, duration : float):
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(right_mini, "self_modulate:a", to, duration)
