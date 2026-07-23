class_name WorkspaceRuneInstance
extends Control

@export var index : int
@export var rune_structure : RuneStructure
@export var texture : TextureRect
@export var outline : TextureRect
@export var empty_texture : Texture

signal pressed(workspace_rune_instance : WorkspaceRuneInstance)

func setup_from_structure(structure : RuneStructure) -> void:
	rune_structure = structure
	if structure != null:
		texture.texture = structure.texture
	else:
		texture.texture = empty_texture

var hovering : bool = false

func _on_mouse_entered() -> void:
	hovering = true
	if rune_structure != null:
		outline.show()

func _on_mouse_exited() -> void:
	hovering = false
	if rune_structure != null:
		outline.hide()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			outline.hide()
			pressed.emit(self)
