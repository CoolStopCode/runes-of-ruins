class_name RuneInstance
extends Control

var dragging := false
var hovering := false
var drag_offset : Vector2
var inserted := false
var inserted_target : TextureRect
var inserting_target : TextureRect

@export var texturerect : TextureRect
@export var outline : TextureRect

const snap_distance := 20
func set_tex(tex : Texture):
	texturerect.texture = tex

func _process(delta: float) -> void:
	if inserted:
		global_position = inserted_target.global_position
	
	if dragging:
		global_position = get_global_mouse_position() + drag_offset
		
		outline.show()
		modulate = Color(1.3, 1.3, 1.3, 1)
		scale = Vector2(1.2, 1.2)
		
		for slot in get_parent().top_slots:
			if global_position.distance_to(slot.global_position + Vector2(10, 10)) < snap_distance:
				global_position = slot.global_position - Vector2(3, 1.5)
				scale = Vector2(1, 1)
		
		
	elif hovering:
		modulate = Color(1.0, 1.0, 1.0, 1)
		scale = Vector2(1.0, 1.0)
		outline.show()
	else:
		modulate = Color(1.0, 1.0, 1.0, 1)
		scale = Vector2(1.0, 1.0)
		outline.hide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if hovering:
				drag_offset = global_position - get_global_mouse_position()
				dragging = true
		else:
			dragging = false


func _on_mouse_entered() -> void:
	hovering = true
	

func _on_mouse_exited() -> void:
	hovering = false

func tick():
	pass

func _ready() -> void:
	Global.tick.connect(tick)
