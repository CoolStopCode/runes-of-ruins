class_name World
extends Node2D

var player : Player
var level : Player
@export var player_scene : PackedScene

func load_from_world_data(world_data : WorldData):
	player = player_scene.instantiate()
	player.position = world_data.player_start
	add_child(player)
	
