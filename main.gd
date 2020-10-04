extends Node


onready var player_variables = get_node("/root/PlayerVariables")


func _on_Player_set_star_coin_increase(amount):
	player_variables.player_currency_star_coin += amount


func _on_Player_activate_market(_body):
	_show_active_checkmark()
	$SFX_Add_2_Star_Coins.play()

func _show_active_checkmark():
	(
		$"Market_Area_Welcome/TextureRect/MarginContainer/Vertical Sections/Active Checkmark/Fade In Out"
	).play("Fade Checkmark Animation")
