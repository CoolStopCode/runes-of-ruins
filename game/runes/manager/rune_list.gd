extends Control

@export var runes : Array[Rune]
@export var rune_instance :PackedScene
@export var spacing : int
@export var top_slots : Array[EmptySlot]
@export var slots : Control
func _ready() -> void:
	Global.setup.connect(setup)
	Global.tick.connect(tick)

func tick():
	top_slots = slots.get_n_empty_slots(10)

func setup():
	var i := 0
	for rune in runes:
		var new_rune_instance := rune_instance.instantiate()
		new_rune_instance.set_tex(rune.texture)
		new_rune_instance.position.y = i * spacing
		add_child(new_rune_instance)
		i += 1
