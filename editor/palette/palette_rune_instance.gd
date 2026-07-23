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
	label.text = str(rune_count)

func _on_mouse_entered() -> void:
	hovering = true
	outline.show()

func _on_mouse_exited() -> void:
	hovering = false
	outline.hide()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			outline.hide()
			pressed.emit(self)
