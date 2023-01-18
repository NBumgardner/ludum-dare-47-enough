extends Node


onready var player_variables = get_node("/root/PlayerVariables")


# Listening for signals
func _on_Player_set_health_increase(amount):
	player_variables.player_current_health = clamp(
		player_variables.player_current_health + amount,
		0,
		player_variables.INITIAL_MAX_HEALTH
	)


func _on_Player_set_envelope_increase(amount):
	player_variables.player_currency_envelope += amount


func _on_Player_set_pizza_slice_increase(amount):
	player_variables.player_currency_pizza_slice += amount


func _on_Player_set_smile_increase(amount):
	player_variables.player_current_smile = clamp(
		player_variables.player_current_smile + amount,
		0,
		player_variables.INITIAL_MAX_SMILE
	)


func _on_Player_set_star_coin_increase(amount):
	player_variables.player_currency_star_coin += amount


func _on_Player_activate_market_area_bed(_body):
	_show_market_area_bed_active_checkmark()
	$SFX_Add_2_Star_Coins.play()


func _on_Player_activate_market_area_house(_body):
	_show_market_area_house_active_checkmark()
	$SFX_Add_2_Star_Coins.play()


func _on_Player_activate_market_area_mailbox(_body):
	_show_market_area_mailbox_active_checkmark()
	$SFX_Add_2_Star_Coins.play()


func _on_Player_activate_market_area_pizza_box(_body):
	_show_market_area_pizza_box_active_checkmark()
	$SFX_Add_2_Star_Coins.play()


func _on_Player_activate_market_area_saw(_body):
	_show_market_area_saw_active_checkmark()
	$SFX_Add_2_Star_Coins.play()


func _on_Player_activate_market_area_valentine(_body):
	_show_market_area_valentine_active_checkmark()
	$SFX_Add_2_Star_Coins.play()


func _show_market_area_bed_active_checkmark():
	(
		$"Market_Area_Bed/TextureRect/MarginContainer/Vertical Sections/Active Checkmark/Fade In Out"
	).play("Fade Checkmark Animation")

func _show_market_area_house_active_checkmark():
	(
		$"Market_Area_House/TextureRect/MarginContainer/Vertical Sections/Active Checkmark/Fade In Out"
	).play("Fade Checkmark Animation")

func _show_market_area_mailbox_active_checkmark():
	(
		$"Market_Area_Mailbox/TextureRect/MarginContainer/Vertical Sections/Active Checkmark/Fade In Out"
	).play("Fade Checkmark Animation")

func _show_market_area_pizza_box_active_checkmark():
	(
		$"Market_Area_Pizza_Box/TextureRect/MarginContainer/Vertical Sections/Active Checkmark/Fade In Out"
	).play("Fade Checkmark Animation")

func _show_market_area_saw_active_checkmark():
	(
		$"Market_Area_Saw/TextureRect/MarginContainer/Vertical Sections/Active Checkmark/Fade In Out"
	).play("Fade Checkmark Animation")

func _show_market_area_valentine_active_checkmark():
	(
		$"Market_Area_Valentine/TextureRect/MarginContainer/Vertical Sections/Active Checkmark/Fade In Out"
	).play("Fade Checkmark Animation")


# Sound effect when player enters a market area the player cannot afford
func _on_Player_cannot_afford_market_area_bed(_body):
	$SFX_Cannot_Afford.play()

func _on_Player_cannot_afford_market_area_house(_body):
	$SFX_Cannot_Afford.play()

func _on_Player_cannot_afford_market_area_mailbox(_body):
	$SFX_Cannot_Afford.play()

func _on_Player_cannot_afford_market_area_pizza_box(_body):
	$SFX_Cannot_Afford.play()

func _on_Player_cannot_afford_market_area_valentine(_body):
	$SFX_Cannot_Afford.play()
