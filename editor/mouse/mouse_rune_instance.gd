class_name MouseRuneInstance
extends Control

signal rune_dropped(rune : RuneStructure)
var active : bool = false
var held_rune_structure : RuneStructure

@export var texture : TextureRect

func _process(_delta: float) -> void:
	if active:
		show()
		global_position = get_global_mouse_position() - size / 2
		if Input.get_mouse_button_mask() == 0:
			active = false
			rune_dropped.emit(held_rune_structure)
			held_rune_structure = null
	else:
		hide()
		held_rune_structure = null

func pick_up_rune(structure : RuneStructure) -> void:
	held_rune_structure = structure
	active = true
	texture.texture = structure.texture
	size = structure.size
