class_name LeftRuneStructure
extends RuneStructure

func execute(player : Player):
	if player.can_air_walk or player.is_player_on_ground():
		player.move_left()
	else:
		player.try_fall()
