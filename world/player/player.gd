class_name Player
extends Node2D

@export var tilemap : TileMapLayer
@export var sprite : AnimatedSprite2D
@export var move_time : float 
@export var tile_position : Vector2
@export var particles : GPUParticles2D
@export var glow : Sprite2D
@export var camera : Camera2D

const tile_size := Vector2(16, 16)
var can_air_walk : bool

func jump():
	can_air_walk = true
	sprite.play("jump", 3 * (1 / move_time))
	move(Vector2(0, -1), move_time)

func move_left():
	if is_touching(Vector2(-1, 0)): return
	can_air_walk = false
	sprite.flip_h = true
	sprite.play("walk", 2 * (1 / move_time))
	move(Vector2(-1, 0), move_time)

func move_right():
	if is_touching(Vector2(1, 0)): return
	can_air_walk = false
	sprite.flip_h = false
	sprite.play("walk", 2 * (1 / move_time))
	move(Vector2(1, 0), move_time)

func move(to : Vector2, duration : float):
	tile_position += to
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", tile_position * tile_size, duration)
	await tween.finished
	sprite.play("idle")

func try_fall():
	if is_player_on_ground(): return
	
	tile_position.y += 1
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", tile_position * tile_size, move_time)
	await tween.finished
	sprite.play("idle")

func is_player_on_ground() -> bool:
	return not tilemap.get_cell_source_id(tile_position + Vector2(0, 1)) == -1

func is_touching(tile : Vector2) -> bool:
	return not tilemap.get_cell_source_id(tile_position + tile) == -1

func die():
	glow.show()
	particles.show()
	sprite.hide()
	particles.emitting = true
	
	camera.camera_shake(5.0, 0.6)
	glow.scale = Vector2(0.01, 0.01)
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(glow, "scale", Vector2(0.32, 0.32), 0.7)
	var tween2 := get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween2.tween_property(glow, "self_modulate:a", 0.0, 0.8)
