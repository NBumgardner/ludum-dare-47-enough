extends Label


onready var game_over_conditions = get_node("/root/GameOverConditions")
onready var player_variables = get_node("/root/PlayerVariables")


func _process(_delta):
	text = _get_star_coin_amount_and_goal()

func _get_star_coin_amount_and_goal():
	var amount = str(player_variables.player_currency_star_coin)
	var goal = ""

	if game_over_conditions.GAME_OVER_WIN_STAR_COIN_AMOUNT > 0:
		goal = (
			" / "
			+ str(game_over_conditions.GAME_OVER_WIN_STAR_COIN_AMOUNT)
		)

	return amount + goal
