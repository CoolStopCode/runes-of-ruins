class_name World
extends Node2D

var player : Player
var level : Level
@export var player_scene : PackedScene
@export var sky : TextureRect
@export var clouds : Parallax2D
@export var fog : TextureRect

const tile_size := Vector2(16, 16)
func load_from_world_data(world_data : WorldData):
	if player: player.queue_free()
	if level: level.queue_free()
	level = world_data.level.instantiate()
	level.clock_interval = world_data.clock_interval
	level.setup()
	add_child(level)
	
	player = player_scene.instantiate()
	player.position = world_data.player_start * tile_size
	player.tile_position = world_data.player_start
	player.tilemap = level.tilemap
	player.move_time = world_data.clock_interval / 6
	player.clock_interval = world_data.clock_interval
	add_child(player)
	
	sky.position = player.position + Vector2(128, -100)

func clock():
	clouds.scroll_offset.x += 1
	level.clock()
	player.clock()
	sky.position = player.position + Vector2(128, -100)
	fog.position = player.position + Vector2(128, -30)
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(sky, "modulate", Color(1, 1, 1), 0.8).from(Color(1.1, 1.1, 1.1))
