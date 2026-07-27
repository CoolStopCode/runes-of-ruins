class_name Kid
extends Node2D

@export var bounce_height: float = 20.0
@export var bounce_speed: float = 4.0
@export var start_offset: float = 0.0

var start_y: float
var time_passed: float = 0.0

func _ready() -> void:
	start_y = position.y
	time_passed = start_offset

func _process(delta: float) -> void:
	time_passed += delta
	position.y = start_y - abs(sin(time_passed * bounce_speed)) * bounce_height
