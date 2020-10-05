extends Label


onready var player_variables = get_node("/root/PlayerVariables")


func _process(_delta):
	text = str(player_variables.player_currency_pizza_slice)
