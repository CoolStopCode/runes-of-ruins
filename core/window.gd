extends Control

signal setup_signal

@export var world_datas : Array[WorldData]
@export var world_index : int
@export var sub_viewport_container : SubViewportContainer
@export var world : World
@export var editor : Editor
@export var clock : Clock
@export var fade : Fade

@export var title : Label
@export var space : Label
@export var bird : AudioStreamPlayer

func setup(world_data : WorldData):
	world.load_from_world_data(world_data)
	editor.load_from_world_data(world_data)
	clock.load_from_world_data(world_data)
	editor.player = world.player

	if editor.reset.is_connected(_on_editor_reset):
		editor.reset.disconnect(_on_editor_reset)
	editor.reset.connect(_on_editor_reset)

	if world.player.dead.is_connected(_on_player_dead):
		world.player.dead.disconnect(_on_player_dead)
	world.player.dead.connect(_on_player_dead)

	if world.player.winned.is_connected(_on_player_winned):
		world.player.winned.disconnect(_on_player_winned)
	world.player.winned.connect(_on_player_winned)

	setup_signal.emit()
	for mini_rune in world.level.mini_runes:
		mini_rune.pickup.connect(pickup_mini_rune)

func _on_editor_reset():
	reset(world_datas[world_index], 0.5, false)
func _on_player_dead():
	reset(world_datas[world_index], 2.0, false)
func _on_player_winned():
	reset(world_datas[world_index + 1], 2.0, true)

func pickup_mini_rune(rune_structure : RuneStructure, count : int):
	editor.pickup_mini_rune(rune_structure, count)

func _ready() -> void:
	clock.clock.connect(world.clock)
	clock.clock.connect(editor.clock)
	clock.half_clock.connect(editor.half_clock)
	world_index = 0
	setup(world_datas[world_index])
	
	bird.play()
	has_started = false
	title.text = "- Level " + str(world_datas[world_index].index) + " -"
	editor.position.x = 210 + 46
	sub_viewport_container.size.x = 210 + 46

func intro_animation():
	editor.position.x = 210 + 46
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(editor, "position:x", 210, 1.0)
	
	sub_viewport_container.size.x = 210 + 46
	var tween2 := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween2.tween_property(sub_viewport_container, "size:x", 210, 1.0)
	
	title.modulate.a = 1.0
	var tween3 := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween3.tween_property(title, "modulate:a", 0.0, 1.0)
	
	space.modulate.a = 1.0
	var tween4 := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween4.tween_property(space, "modulate:a", 0.0, 1.0)
	
	await tween4.finished
	clock.start()

func reset(world_data : WorldData, duration : float, new : bool):
	has_started = not new
	clock.stop()
	fade.exit(duration / 2)  
	clock.fade_out(duration / 2)
	await get_tree().create_timer(duration / 2).timeout  
	setup(world_data)
	if new:
		title.text = "- Level " + str(world_data.index) + " -"
		editor.position.x = 210 + 46
		sub_viewport_container.size.x = 210 + 46
		editor.won = false
		await get_tree().create_timer(1.0).timeout
		has_started = false
		title.modulate.a = 1.0
		title.show()
		space.modulate.a = 1.0
		space.show()
		fade.enter(duration / 2)
		world_index += 1
		bird.play()
		bird.volume_linear = 1.0
	else:
		fade.enter(duration / 2)
		await get_tree().create_timer(duration / 2).timeout
		clock.start()

var has_started : bool

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if not has_started:
			has_started = true
			intro_animation()
			var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(bird, "volume_linear", 0.0, 1.0)
