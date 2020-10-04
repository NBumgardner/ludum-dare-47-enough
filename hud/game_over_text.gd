extends Label


const GAME_OVER_LOSE = "Game Over"
const GAME_OVER_STAR_COIN_AMOUNT = 0
const GAME_OVER_WIN = "Congratulations!"
const GAME_WIN_STAR_COIN_AMOUNT = 10


onready var player_variables = get_node("/root/PlayerVariables")


func _process(_delta):
	if _is_player_rich():
		text = GAME_OVER_WIN
	elif _is_player_out_of_money():
		text = GAME_OVER_LOSE


# Game Win or Lose Boolean Conditions
func _is_player_out_of_money():
	return (
		player_variables.player_currency_star_coin
		<= GAME_OVER_STAR_COIN_AMOUNT
	)

func _is_player_rich():
	return (
		player_variables.player_currency_star_coin
		>= GAME_WIN_STAR_COIN_AMOUNT
	)
