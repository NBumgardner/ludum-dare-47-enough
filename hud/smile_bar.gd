extends TextureProgressBar


@onready var player_variables = get_node("/root/PlayerVariables")


func _process(_delta):
	value = _get_player_smile_percentage()

func _get_player_smile_percentage():
	if player_variables.INITIAL_MAX_SMILE > 0:
		return (
			float(player_variables.player_current_smile)
			/ float(player_variables.INITIAL_MAX_SMILE)
		) * 100
	else:
		return 0
