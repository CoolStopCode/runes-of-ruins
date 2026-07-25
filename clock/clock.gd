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
@export var audio_offset : float
@export var audio_fade_in : float

func load_from_world_data(world_data: WorldData) -> void:
	audio = world_data.audio
	clock_interval = world_data.clock_interval
	offset = world_data.offset
	audio_offset = world_data.audio_offset
	audio_fade_in = world_data.audio_fade_in
	
	audio_player.stream = audio

func start():
	time = clock_interval - offset
	half_clock_emitted = false
	active = true
	
	audio_player.volume_linear = 0.0
	var tween := get_tree().create_tween()
	tween.tween_property(audio_player, "volume_linear", 1.0, audio_fade_in)
	audio_player.play(audio_offset)

func stop():
	active = false

func _process(delta: float) -> void:
	if not active: return

	time += delta

	if not half_clock_emitted and time >= clock_interval / 2.0:
		half_clock_emitted = true
		half_clock.emit()

	if time >= clock_interval:
		time -= clock_interval
		half_clock_emitted = false
		clock.emit()
