extends Control

signal clock_signal
signal setup_signal

@export var world : World
@export var editor : Editor

func setup(world_data : WorldData):
	world.load_from_world_data(world_data)
	editor.load_from_world_data(world_data)
	setup_signal.emit()
