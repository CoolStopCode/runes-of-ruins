class_name MiniRune
extends Area2D

@export var rune_structure : RuneStructure
@export var sprite : Sprite2D
@export var particles : GPUParticles2D

var pos_offset := 0
signal pickup(rune_struct: RuneStructure)

func clock():
	if pos_offset == 0:
		pos_offset = 1
	else:
		pos_offset = 0
	sprite.position = Vector2(0, pos_offset)

func setup():
	particles.texture = rune_structure.particle_texture
	sprite.texture = rune_structure.mini_texture
	show()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_area"):
		pickup.emit(rune_structure)
		particles.emitting = true
		sprite.hide()
		set_deferred("monitering", false)
