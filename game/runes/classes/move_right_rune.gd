class_name MoveRightRune
extends Rune

func execute(player : Player) -> void:
	player.turn_right()
	player.move_forward()
