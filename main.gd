extends Node


onready var player_variables = get_node("/root/PlayerVariables")


func _on_Player_set_star_coin_increase(amount):
	player_variables.player_currency_star_coin += amount
