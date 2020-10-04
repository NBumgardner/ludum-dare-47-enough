extends Label


const GAME_OVER_LOSE = "Game Over"
const GAME_OVER_STAR_COIN_AMOUNT = 0
const GAME_OVER_WIN = "Congratulations!"
const GAME_WIN_STAR_COIN_AMOUNT = 10


onready var game_over_conditions = get_node("/root/GameOverConditions")


func _process(_delta):
	if game_over_conditions.is_player_rich():
		text = game_over_conditions.GAME_OVER_WIN_TEXT
	elif game_over_conditions.is_player_out_of_money():
		text = game_over_conditions.GAME_OVER_LOSE_TEXT
