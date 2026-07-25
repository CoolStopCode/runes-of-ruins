class_name RuneButton
extends Control


signal pressed
@export var texture : Texture
@export var texture_rect : TextureRect
@export var outline : TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	outline.hide()
	texture_rect.texture = texture

func _on_mouse_entered() -> void:
	outline.show()

func _on_mouse_exited() -> void:
	outline.hide()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		pressed.emit()
