class_name World
extends Node2D

var player : Player
var level : Level
@export var player_scene : PackedScene

const tile_size := Vector2(16, 16)
func load_from_world_data(world_data : WorldData):
	if player: player.queue_free()
	if level: level.queue_free()
	level = world_data.level.instantiate()
	level.clock_interval = world_data.clock_interval
	add_child(level)
	
	player = player_scene.instantiate()
	player.position = world_data.player_start * tile_size
	player.tile_position = world_data.player_start
	player.tilemap = level.tilemap
	player.move_time = world_data.clock_interval / 4
	player.clock_interval = world_data.clock_interval
	add_child(player)

func clock():
	level.clock()
