extends Node


const GAME_OVER_LOSE_STAR_COIN_AMOUNT = 0
const GAME_OVER_LOSE_TEXT = "Game Over"
const GAME_OVER_WIN_STAR_COIN_AMOUNT = 10
const GAME_OVER_WIN_TEXT = "Congratulations!"


onready var player_variables = get_node("/root/PlayerVariables")


func get_game_over_text():
	if is_player_rich():
		return GAME_OVER_WIN_TEXT
	elif is_player_out_of_money():
		return GAME_OVER_LOSE_TEXT
	else:
		return ""

func is_player_rich():
	return (
		player_variables.player_currency_star_coin
		>= GAME_OVER_WIN_STAR_COIN_AMOUNT
	)

func is_player_out_of_money():
	return (
		player_variables.player_currency_star_coin
		<= GAME_OVER_LOSE_STAR_COIN_AMOUNT
	)
