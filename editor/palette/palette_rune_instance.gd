class_name PaletteRuneInstance
extends Control

@export var rune_structure : RuneStructure
@export var rune_count : int: 
	set(value):
		rune_count = value
		update_rune_count()
@export var texture : TextureRect
@export var outline : TextureRect
@export var label : Label

signal pressed(palette_rune_instance : PaletteRuneInstance)

func setup_from_structure(structure : RuneStructure, count : int) -> void:
	rune_structure = structure
	rune_count = count
	update_rune_count()
	texture.texture = structure.texture
	size = structure.size
	

var hovering : bool = false

func update_rune_count():
	if rune_count == 0:
		texture.self_modulate = Color(0.5, 0.5, 0.5)
	elif rune_count == -1:
		label.hide()
		texture.self_modulate = Color(1, 1, 1)
	else:
		texture.self_modulate = Color(1, 1, 1)
	label.text = str(rune_count)

func _on_mouse_entered() -> void:
	if rune_count == 0: return
	hovering = true
	outline.show()

func _on_mouse_exited() -> void:
	if rune_count == 0: return
	hovering = false
	outline.hide()

func _on_gui_input(event: InputEvent) -> void:
	if rune_count == 0: return
	if event is InputEventMouseButton:
		if event.pressed:
			outline.hide()
			pressed.emit(self)
