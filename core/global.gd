extends Node

@export var tile_size : int = 16
@export var beat_time : float = 1.0
@onready var subviewport : SubViewport = get_node("/root/window/SubViewportContainer/SubViewport")

signal tick
signal setup

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_up"):
		tick.emit()
	if Input.is_action_just_pressed("ui_down"):
		open_level(preload("res://game/levels/template.tscn"))

func open_level(scene : PackedScene):
	subviewport.load_level(scene)
	setup.emit()
