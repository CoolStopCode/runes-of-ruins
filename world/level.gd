class_name Level
extends Node2D

@export var tilemap : TileMapLayer
@export var clock_interval : float
@export var mini_runes : Array[MiniRune]

func clock():
	for mini_rune in mini_runes:
		mini_rune.clock()

func setup():
	for mini_rune in mini_runes:
		mini_rune.setup()
