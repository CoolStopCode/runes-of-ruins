class_name Clock
extends Node

signal clock
signal half_clock

var time: float = 0.0
var active: bool = false
var half_clock_emitted: bool = false

@export var clock_interval: float
@export var audio: AudioStream
@export var audio_player: AudioStreamPlayer
@export var offset : float

func load_from_world_data(world_data: WorldData) -> void:
	audio = world_data.audio
	clock_interval = world_data.clock_interval
	offset = world_data.offset

	time = clock_interval - offset
	half_clock_emitted = false
	active = true

	audio_player.stream = audio
	audio_player.play()


func _process(delta: float) -> void:
	if not active:
		return

	time += delta

	if not half_clock_emitted and time >= clock_interval / 2.0:
		half_clock_emitted = true
		half_clock.emit()

	if time >= clock_interval:
		time -= clock_interval
		half_clock_emitted = false
		clock.emit()
