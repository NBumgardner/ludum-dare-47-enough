extends Node


onready var player_variables = get_node("/root/PlayerVariables")


# Listening for signals
func _on_Player_set_health_increase(amount):
	player_variables.player_current_health += amount
	if player_variables.player_current_health < 0:
		player_variables.player_current_health = 0


func _on_Player_set_smile_increase(amount):
	player_variables.player_current_smile += amount
	if player_variables.player_current_smile < 0:
		player_variables.player_current_smile = 0


func _on_Player_set_star_coin_increase(amount):
	player_variables.player_currency_star_coin += amount


func _on_Player_activate_market_area_saw(_body):
	_show_market_area_saw_active_checkmark()
	$SFX_Add_2_Star_Coins.play()


func _on_Player_activate_market(_body):
	_show_active_checkmark()
	$SFX_Add_2_Star_Coins.play()


# Logic for signals, excluding sound effects
func _show_active_checkmark():
	(
		$"Market_Area_Welcome/TextureRect/MarginContainer/Vertical Sections/Active Checkmark/Fade In Out"
	).play("Fade Checkmark Animation")

func _show_market_area_saw_active_checkmark():
	(
		$"Market_Area_Saw/TextureRect/MarginContainer/Vertical Sections/Active Checkmark/Fade In Out"
	).play("Fade Checkmark Animation")
