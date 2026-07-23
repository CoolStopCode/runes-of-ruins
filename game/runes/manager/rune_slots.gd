extends Control

@export var empty_tex : Texture
@export var pulse_tex : Texture

var pulse_node : TextureRect
var index : int = 0
@export var runes : Array[Rune]
@export var spacing : int

func setup(length : int):
	for child in get_children():
		child.queue_free()
		
	pulse_node = TextureRect.new()
	pulse_node.size = Vector2(22, 22)
	pulse_node.pivot_offset = Vector2(11, 11)
	pulse_node.texture = pulse_tex
	pulse_node.modulate.a = 0.0
	pulse_node.z_index = 1
	pulse_node.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(pulse_node)
	
	size.y = length * spacing
	position.y = 6
	for i in length:
		var texture := empty_tex
		var empty := TextureRect.new()
		empty.texture = texture
		empty.position.y = i * spacing
		empty.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		add_child(empty)

func _ready() -> void:
	Global.tick.connect(tick)
	setup(1000)

func tick():
	pulse_node.modulate.a = 1.0
	pulse_node.position = Vector2(-1, -1 + index * spacing)
	pulse_node.scale = Vector2(1.5, 1.5)
	var tween1 := get_tree().create_tween()
	tween1.tween_property(pulse_node, "scale", Vector2(1, 1), Global.beat_time / 4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween1.finished
	
	var tween2 := get_tree().create_tween()
	tween2.tween_property(pulse_node, "modulate:a", 0.0, Global.beat_time / 4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	index += 1
	var tween3 := get_tree().create_tween()
	tween3.tween_property(self, "position:y", position.y - (20+2), Global.beat_time / 4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
