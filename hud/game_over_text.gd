extends Label


onready var game_over_conditions = get_node("/root/GameOverConditions")


func _process(_delta):
	text = game_over_conditions.get_game_over_text()
