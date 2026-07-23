class_name Player
extends Node2D

@export var sprite : AnimatedSprite2D

func jump():
	sprite.play("jump")
	await sprite.animation_finished
	move(Vector2(0, 1), Global.beat_time / 2)
	await get_tree().create_timer(Global.beat_time / 2).timeout
	sprite.play("idle")

func turn_left():
	sprite.flip_h = true

func turn_right():
	sprite.flip_h = false

func move_forward():
	sprite.play("walk")
	if sprite.flip_h:
		move(Vector2(-1, 0), Global.beat_time / 2)
	else:
		move(Vector2(1, 0), Global.beat_time / 2)
	await sprite.animation_finished
	sprite.play("idle")

func move(direction : Vector2, time : float):
	var target := direction * Global.tile_size
	var tween := get_tree().create_tween()
	tween.tween_property(self, "position", target, time)
