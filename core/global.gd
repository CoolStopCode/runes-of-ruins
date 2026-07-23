extends Node

@export var tile_size : int = 16
@export var beat_time : float = 1.0

signal tick

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_up"):
		tick.emit()
	
