@abstract
class_name RuneStructure
extends Resource

@export var texture: Texture2D
@export var mini_texture: Texture2D
@export var size: Vector2 = Vector2(16, 16)
@export var particle_texture: Texture2D

@abstract func execute(player: Player)
