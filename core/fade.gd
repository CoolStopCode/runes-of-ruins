class_name Fade
extends ColorRect

func _ready() -> void:
	hide()

func enter(transition : float):
	modulate.a = 1.0
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0 , transition)
	await tween.finished
	hide()

func exit(transition : float):
	show()
	modulate.a = 0.0
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0 , transition)
