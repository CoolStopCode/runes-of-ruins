class_name JumpRuneStructure
extends RuneStructure

func execute(player : Player):
	if player.is_player_on_ground():
		player.jump()
	else:
		player.try_fall()
