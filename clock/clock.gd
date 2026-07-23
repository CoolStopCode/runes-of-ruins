class_name Clock
extends Node

signal clock
var time : float = 0.0

@export var clock_interval : float
@export var audio : AudioStream

@export var audio_player : AudioStreamPlayer

func load_from_world_data(world_data : WorldData):
	audio = world_data.audio
	clock_interval = world_data.clock_interval
	
	audio_player.stream = audio
	audio_player.play() 

func _process(delta: float) -> void:
	time += delta
	
	if time >= clock_interval:
		time -= clock_interval
		clock.emit()
