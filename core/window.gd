extends Control

signal setup_signal

@export var world_datas : Array[WorldData]
@export var world : World
@export var editor : Editor
@export var clock : Clock
@export var fade : Fade

func setup(world_data : WorldData):
	world.load_from_world_data(world_data)
	editor.load_from_world_data(world_data)
	clock.load_from_world_data(world_data)
	editor.player = world.player
	world.player.dead.connect(func(): reset(world_data, 2.0))
	setup_signal.emit()

func _ready() -> void:
	clock.clock.connect(world.clock)
	clock.clock.connect(editor.clock)
	clock.half_clock.connect(editor.half_clock)
	reset(world_datas[0], 0.0)

func reset(world_data : WorldData, duration : float):
	clock.stop()
	fade.exit(duration / 2)
	await get_tree().create_timer(duration / 2).timeout
	setup(world_data)
	fade.enter(duration / 2)
	await get_tree().create_timer(duration / 2).timeout
	clock.start()
