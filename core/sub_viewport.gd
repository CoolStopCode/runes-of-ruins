extends SubViewport

var current_level : Node2D

func load_level(scene : PackedScene):
	if current_level != null:
		current_level.queue_free()
	var instance := scene.instantiate()
	add_child(instance)
	current_level = instance
