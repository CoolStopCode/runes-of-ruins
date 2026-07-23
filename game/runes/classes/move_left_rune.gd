class_name MoveLeftRune
extends Rune

func execute(player : Player) -> void:
	player.turn_left()
	player.move_forward()
