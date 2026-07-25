class_name WorkspaceRuneInstance
extends Control

@export var count : int
@export var index : int
@export var rune_structure : RuneStructure
@export var texture : TextureRect
@export var outline : TextureRect
@export var effect : TextureRect
@export var label : Label
@export var empty_texture : Texture
@export var particles : GPUParticles2D

var executed : bool
var locked : bool
signal pressed(workspace_rune_instance : WorkspaceRuneInstance)

func setup_from_structure(structure : RuneStructure) -> void:
	label.text = str(count)
	if executed: return
	rune_structure = structure
	if structure != null:
		particles.texture = structure.particle_texture
		texture.texture = structure.texture
	else:
		texture.texture = empty_texture

var hovering : bool = false

func _on_mouse_entered() -> void:
	if executed: return
	if locked: return
	hovering = true
	if rune_structure != null:
		outline.show()

func _on_mouse_exited() -> void:
	if executed: return
	if locked: return
	hovering = false
	if rune_structure != null:
		outline.hide()

func _on_gui_input(event: InputEvent) -> void:
	if executed: return
	if locked: return
	if event is InputEventMouseButton:
		if event.pressed:
			outline.hide()
			pressed.emit(self)
 
func execute(player : Player):
	executed = true
	
	effect.show()
	effect.modulate.a = 1.0
	effect.scale = Vector2(0.2, 0.2)
	var tween1 := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween1.tween_property(effect, "scale", Vector2(1.2, 1.2), 0.5)
	var tween2 := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween2.tween_property(effect, "modulate:a", 0.0, 0.5)
	
	#outline.show()
	#outline.modulate.a = 1.0
	#var tween3 := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	#tween3.tween_property(outline, "modulate:a", 0.0, 0.5)
	
	outline.hide()
	label.show()
	if rune_structure:
		rune_structure.execute(player)
		particles.emitting = true
		texture.texture = empty_texture
	
	texture.modulate.a = 0.5
	label.modulate.a = 0.5
	
	await get_tree().create_timer(particles.lifetime).timeout
	particles.queue_free()
