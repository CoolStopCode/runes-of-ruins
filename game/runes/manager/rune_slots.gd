extends Control

@export var pulse_scene : PackedScene
@export var empty_slot_scene : PackedScene

var pulse_node : Control
var index : int = 0
@export var runes : Array[Rune]
@export var empty_slots : Array[EmptySlot]

@export var spacing : int

func get_n_empty_slots(n : int) -> Array[EmptySlot]:
	return empty_slots.slice(index, index + n - 1)

func setup(length : int):
	index = 0
	for child in get_children():
		child.queue_free()
	runes = []
	empty_slots = []
	runes.resize(length)
	
	pulse_node = pulse_scene.instantiate()
	pulse_node.modulate.a = 0.0
	pulse_node.z_index = 1
	pulse_node.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(pulse_node)
	
	size.y = length * spacing
	position.y = 6
	for i in length:
		var empty : EmptySlot = empty_slot_scene.instantiate()
		empty.index = i
		empty.position.y = i * spacing
		empty_slots.append(empty)
		add_child(empty)

func _ready() -> void:
	Global.tick.connect(tick)
	Global.setup.connect(func(): setup(100))

func tick():
	pulse_node.modulate.a = 1.0
	pulse_node.position = Vector2(-1, -1 + index * spacing)
	pulse_node.scale = Vector2(1.5, 1.5)
	if runes[index] != null:
		runes[index].execute(Global.subviewport.current_level.player)
	
	var tween1 := get_tree().create_tween()
	tween1.tween_property(pulse_node, "scale", Vector2(1, 1), Global.beat_time / 4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween1.finished
	
	var tween2 := get_tree().create_tween()
	tween2.tween_property(pulse_node, "modulate:a", 0.0, Global.beat_time / 4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	index += 1
	var tween3 := get_tree().create_tween()
	tween3.tween_property(self, "position:y", position.y - (20+2), Global.beat_time / 4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
