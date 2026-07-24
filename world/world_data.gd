class_name WorldData
extends Resource

@export_category("Editor")
@export var palette : Palette
@export var workspace_length : int

@export_category("World")
@export var level : PackedScene
@export var player_start : Vector2

@export_category("Clock")
@export var clock_interval : float
@export var audio : AudioStream
@export var offset : float
