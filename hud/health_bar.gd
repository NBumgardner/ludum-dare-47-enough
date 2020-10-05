extends TextureProgress


onready var player_variables = get_node("/root/PlayerVariables")


func _process(_delta):
	value = _get_player_health_percentage()

func _get_player_health_percentage():
	if player_variables.INITIAL_MAX_HEALTH > 0:
		return (
			float(player_variables.player_current_health)
			/ float(player_variables.INITIAL_MAX_HEALTH)
		) * 100
	else:
		return 0
