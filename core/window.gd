extends Control

signal setup_signal

@export var world_datas : Array[WorldData]
@export var world : World
@export var editor : Editor
@export var clock : Clock

func setup(world_data : WorldData):
	world.load_from_world_data(world_data)
	editor.load_from_world_data(world_data)
	clock.load_from_world_data(world_data)
	editor.player = world.player
	
	setup_signal.emit()

func _ready() -> void:
	clock.clock.connect(world.clock)
	clock.clock.connect(editor.clock)
	clock.half_clock.connect(editor.half_clock)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		setup(world_datas[0])
