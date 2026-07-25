class_name RightRuneStructure
extends RuneStructure

func execute(player: Player) -> void:
	if player.active_going.x == 1:
		return
	player.move_right()
