class_name Player
extends Node2D

signal dead
signal winned

const TILE_SIZE := Vector2(16, 16)

@export var tilemap: TileMapLayer
@export var sprite: AnimatedSprite2D
@export var move_time: float
@export var clock_interval: float
@export var tile_position: Vector2
@export var particles: GPUParticles2D
@export var glow: Sprite2D
@export var camera: Camera2D
@export var speech: Label
@export var thanks : Label
@export var direction_indicator: Sprite2D

@export var explode_sfx : AudioStreamPlayer
@export var win_sfx : AudioStreamPlayer

var active_going: Vector2 = Vector2.ZERO
var has_spoken: bool = false

var _gravity_pending: bool = false
var _jumped_this_tick: bool = false
var _grounded_snapshot: bool = false
var _grounded_snapshot_valid: bool = false
var _auto_move_pending: bool = false

# --- Called by the level's clock / rune system ---
# clock() and a tile's rune execute() can both fire on the same frame in
# either order. Several things depend on knowing the tick's true starting
# state, or on resolving only after every same-tick rune has had a say:
#   - jump() must know if the player was grounded at tick start, even if
#     a "run" move already carried them off a ledge earlier this tick.
#   - the auto-move driven by active_going must resolve *after* any rune
#     on the player's current tile (e.g. a Stop rune) has had a chance to
#     change active_going first — otherwise stopping lands one tick late.
#   - gravity must resolve after every synchronous move this tick.
# _snapshot_grounded_state() is called first thing by every entry point
# that can move the player, so whichever fires first this tick locks in
# the true starting state for the rest of the tick.

func clock() -> void:
	_snapshot_grounded_state()
	_request_auto_move_check()
	_request_gravity_check()


func jump() -> void:
	_snapshot_grounded_state()
	if not _grounded_snapshot:
		return
	if is_touching(Vector2(0, -1)):
		return
	_jumped_this_tick = true
	sprite.play("jump", 3.0 / move_time)
	_move_to(Vector2(0, -1), move_time)


func move_left() -> void:
	_snapshot_grounded_state()
	active_going = Vector2(-1, 0)


func move_right() -> void:
	_snapshot_grounded_state()
	active_going = Vector2(1, 0)


func die() -> void:
	dead.emit()
	glow.show()
	particles.show()
	sprite.hide()
	particles.emitting = true
	camera.camera_shake(5.0, 0.6)
	explode_sfx.play()
	_pulse_glow()


func win() -> void:
	winned.emit()
	camera.camera_shake(5.0, 0.6)
	win_sfx.play()
	_pulse_glow()


func is_player_on_ground() -> bool:
	return is_touching(Vector2(0, 1))


func is_touching(offset: Vector2) -> bool:
	if tilemap.get_cell_atlas_coords(tile_position + offset) == Vector2i(16, 11):
		return false
	elif offset != Vector2(0, 1):
		if tilemap.get_cell_atlas_coords(tile_position + offset) == Vector2i(15, 10) or\
			tilemap.get_cell_atlas_coords(tile_position + offset) == Vector2i(16, 10):
				return false
	return tilemap.get_cell_source_id(tile_position + offset) != -1


# --- Internal helpers ---

## Shared implementation for move_left()/move_right()/the auto-move step:
## walk if the way is clear, otherwise smack into the wall.
func _try_move(direction: Vector2) -> void:
	var facing_left := direction.x < 0
	if is_touching(direction):
		_smack(facing_left)
		return
	active_going = direction
	_update_direction_indicator()
	sprite.flip_h = facing_left
	sprite.play("walk", 2.0 / move_time)
	_move_to(direction, move_time)


func _snapshot_grounded_state() -> void:
	if _grounded_snapshot_valid:
		return
	_grounded_snapshot_valid = true
	_grounded_snapshot = is_player_on_ground()
	call_deferred("_clear_grounded_snapshot")


func _clear_grounded_snapshot() -> void:
	_grounded_snapshot_valid = false


## The clock's "keep moving in active_going" step is deferred rather than
## applied inline, so a same-tick rune (e.g. Stop) gets to update
## active_going first. Without this, the player would move one extra tile
## before a Stop rune's effect was observed.
func _request_auto_move_check() -> void:
	if _auto_move_pending:
		return
	_auto_move_pending = true
	call_deferred("_resolve_auto_move")


func _resolve_auto_move() -> void:
	_auto_move_pending = false
	if active_going.x == 1:
		_try_move(Vector2(1, 0))
	elif active_going.x == -1:
		_try_move(Vector2(-1, 0))


func _request_gravity_check() -> void:
	if _gravity_pending:
		return
	_gravity_pending = true
	call_deferred("_resolve_gravity")


func _resolve_gravity() -> void:
	_gravity_pending = false
	if _jumped_this_tick:
		_jumped_this_tick = false
		return
	if is_player_on_ground():
		return
	_move_to(Vector2(0, 1), move_time, Tween.EASE_IN, Tween.TRANS_CUBIC)

func _move_to(offset: Vector2, duration: float, ease_type := Tween.EASE_IN_OUT, trans_type := Tween.TRANS_SINE) -> void:
	tile_position += offset
	var tween := get_tree().create_tween().set_ease(ease_type).set_trans(trans_type)
	tween.tween_property(self, "position", tile_position * TILE_SIZE, duration)
	await tween.finished
	sprite.play("idle", 1.0 / clock_interval)


func _smack(facing_left: bool) -> void:
	active_going = Vector2.ZERO
	sprite.flip_h = facing_left
	sprite.play("smack", 2.0 / move_time)
	_update_direction_indicator()

func _pulse_glow() -> void:
	glow.show()
	_tween_scale(glow, Vector2(0.32, 0.32), 0.7, Tween.EASE_OUT, Tween.TRANS_CUBIC, Vector2(0.01, 0.01))
	var fade_tween := get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	fade_tween.tween_property(glow, "self_modulate:a", 0.0, 0.8)


func _update_direction_indicator() -> void:
	var was_hidden := not direction_indicator.visible
	if active_going.x != 0:
		direction_indicator.show()
		direction_indicator.flip_h = active_going.x < 0
		if was_hidden:
			await _tween_scale(direction_indicator, Vector2(1, 1), 0.5, Tween.EASE_OUT, Tween.TRANS_CUBIC, Vector2(0.01, 0.01))
	elif not was_hidden:
		await _tween_scale(direction_indicator, Vector2(0.01, 0.01), 0.5, Tween.EASE_OUT, Tween.TRANS_CUBIC)
		direction_indicator.hide()


## Tweens `node.scale` to `target_scale`. If `from_scale` is given, the node's
## scale is set to it first (used for pop-in effects starting from ~0).
func _tween_scale(node: Node, target_scale: Vector2, duration: float, ease_type: Tween.EaseType, trans_type: Tween.TransitionType, from_scale := Vector2.INF) -> Signal:
	if from_scale != Vector2.INF:
		node.scale = from_scale
	var tween := get_tree().create_tween().set_ease(ease_type).set_trans(trans_type)
	tween.tween_property(node, "scale", target_scale, duration)
	return tween.finished


func _input(event: InputEvent) -> void:
	if has_spoken:
		return
	if not Input.is_action_just_pressed("wrong button boi"):
		return
	has_spoken = true
	speech.scale = Vector2(0.01, 0.01)
	speech.show()
	await _tween_scale(speech, Vector2(1, 1), 0.5, Tween.EASE_OUT, Tween.TRANS_CUBIC)
	await get_tree().create_timer(5.0).timeout
	await _tween_scale(speech, Vector2(0.01, 0.01), 0.5, Tween.EASE_OUT, Tween.TRANS_CUBIC)
	speech.hide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("tilemap"):
		die()

func dash_right():
	sprite.flip_h = false
	if is_touching(Vector2(2, 0)):
		_smack(false)
		return
	sprite.play("dash", 2.0 / move_time)
	_move_to(Vector2(2, 0), move_time)

func down():
	sprite.play("down")
	if tilemap.get_cell_atlas_coords(tile_position + Vector2(0, 1)) == Vector2i(15, 10) or\
		tilemap.get_cell_atlas_coords(tile_position + Vector2(0, 1)) == Vector2i(16, 10):
		_move_to(Vector2(0, 1), move_time)

func heart():
	thanks.scale = Vector2(0.01, 0.01)
	thanks.show()
	_tween_scale(thanks, Vector2(1, 1), 0.5, Tween.EASE_OUT, Tween.TRANS_CUBIC)
