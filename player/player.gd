extends KinematicBody2D

const ACCELERATION = 1500
const INCOME_FROM_MARKET_AREA_BED_HEALTH = 2
const INCOME_FROM_MARKET_AREA_BED_STAR_COINS = -1
const INCOME_FROM_MARKET_AREA_MAILBOX_HEALTH = -1
const INCOME_FROM_MARKET_AREA_MAILBOX_STAR_COINS = -1
const INCOME_FROM_MARKET_AREA_MAILBOX_ENVELOPES = 5
const INCOME_FROM_MARKET_AREA_WELCOME_STAR_COINS = 2
const INCOME_FROM_MARKET_AREA_SAW_HEALTH = -1
const INCOME_FROM_MARKET_AREA_SAW_SMILE = -1
const INCOME_FROM_MARKET_AREA_SAW_STAR_COINS = 2
const MAX_SPEED = 400
const TAX_STAR_COINS = -1

var is_player_asleep = true
var motion = Vector2()
var player_is_inside = []

signal activate_market(body)
signal activate_market_area_bed(body)
signal activate_market_area_mailbox(body)
signal activate_market_area_saw(body)
signal cannot_affort_market_area_bed(body)
signal cannot_affort_market_area_mailbox(body)
signal set_envelope_increase(amount)
signal set_health_increase(amount)
signal set_smile_increase(amount)
signal set_star_coin_increase(amount)


onready var game_over_conditions = get_node("/root/GameOverConditions")
onready var player_variables = get_node("/root/PlayerVariables")


# Player Movement methods
func _physics_process(delta):
	# Stop timer and moving if player is out of money or health
	if (
		game_over_conditions.is_player_out_of_money()
		|| game_over_conditions.is_player_out_of_health()
	):
		is_player_asleep = true
		return

	# Stop timer if player won
	if game_over_conditions.is_player_rich():
		is_player_asleep = true

	var axis = _get_input_axis()
	if axis == Vector2.ZERO:
		_apply_friction(ACCELERATION * delta)
	else:
		# Begin tax timer after the player begins to move.
		_start_Tax_Timer()
		_apply_movement(axis * ACCELERATION * delta)
	motion = move_and_slide(motion)

func _apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

func _apply_movement(amount):
	motion += amount
	motion = motion.clamped(MAX_SPEED)

func _get_input_axis():
	var axis = Vector2.ZERO
	axis.x = (
		int(Input.is_action_pressed("ui_right"))
		- int(Input.is_action_pressed("ui_left"))
	)
	axis.y = (
		int(Input.is_action_pressed("ui_down"))
		- int(Input.is_action_pressed("ui_up"))
	)
	return axis.normalized()


# Market Area Bed collision method
func _on_Market_Area_Bed_body_entered(body):
	var minimum_star_coins = 0
	var remaining_star_coins = (
		player_variables.player_currency_star_coin
		+ INCOME_FROM_MARKET_AREA_BED_STAR_COINS
	)
	if remaining_star_coins >= minimum_star_coins:
		_activate_Market_Area_Bed(body)
	else:
		emit_signal("cannot_affort_market_area_bed", body)


# Market Area Mailbox collision method
func _on_Market_Area_Mailbox_body_entered(body):
	var minimum_star_coins = 0
	var remaining_star_coins = (
		player_variables.player_currency_star_coin
		+ INCOME_FROM_MARKET_AREA_MAILBOX_STAR_COINS
	)
	if remaining_star_coins >= minimum_star_coins:
		_activate_Market_Area_Mailbox(body)
	else:
		emit_signal("cannot_affort_market_area_mailbox", body)


# Market Area Saw collision method
func _on_Market_Area_Saw_body_entered(body):
	_activate_Market_Area_Saw(body)


# Logic for Market Area Bed
func _activate_Market_Area_Bed(body):
	emit_signal("activate_market_area_bed", body)
	emit_signal(
		"set_star_coin_increase",
		INCOME_FROM_MARKET_AREA_BED_STAR_COINS
	)
	emit_signal(
		"set_health_increase",
		INCOME_FROM_MARKET_AREA_BED_HEALTH
	)

	if (OS.is_debug_build()):
		print("Player entered " + str(body))


# Logic for Market Area Mailbox
func _activate_Market_Area_Mailbox(body):
	emit_signal("activate_market_area_mailbox", body)
	emit_signal(
		"set_health_increase",
		INCOME_FROM_MARKET_AREA_MAILBOX_HEALTH
	)
	emit_signal(
		"set_star_coin_increase",
		INCOME_FROM_MARKET_AREA_MAILBOX_STAR_COINS
	)
	emit_signal(
		"set_envelope_increase",
		INCOME_FROM_MARKET_AREA_MAILBOX_ENVELOPES
	)

	if (OS.is_debug_build()):
		print("Player entered " + str(body))



# Logic for Market Area Saw
func _activate_Market_Area_Saw(body):
	emit_signal("activate_market_area_saw", body)
	emit_signal(
		"set_star_coin_increase",
		INCOME_FROM_MARKET_AREA_SAW_STAR_COINS
	)
	emit_signal(
		"set_smile_increase",
		INCOME_FROM_MARKET_AREA_SAW_SMILE
	)
	emit_signal(
		"set_health_increase",
		INCOME_FROM_MARKET_AREA_SAW_HEALTH
	)

	if (OS.is_debug_build()):
		print("Player entered " + str(body))


# Market Area Welcome collision methods
func _on_Market_Area_Welcome_body_entered(body):
	_activate_Market_Area_Welcome(body)

func _on_Market_Area_Welcome_body_exited(body):
	_deactivate_Market_Area_Welcome(body)


# Logic for Market Area Welcome
func _activate_Market_Area_Welcome(body):
	player_is_inside.push_back(body)
	emit_signal("activate_market", body)
	emit_signal(
		"set_star_coin_increase",
		INCOME_FROM_MARKET_AREA_WELCOME_STAR_COINS
	)

	if (OS.is_debug_build()):
		print("Player is in " + str(player_is_inside)
			+ " after entering " + str(body))

func _deactivate_Market_Area_Welcome(body):
	player_is_inside.remove(player_is_inside.find(body))

	if (OS.is_debug_build()):
		print("Player is in " + str(player_is_inside)
			+ " after leaving " + str(body))


# Logic for passive loss of star coin currency
func _start_Tax_Timer():
	if is_player_asleep && !game_over_conditions.is_player_rich():
		is_player_asleep = false

func _on_Tax_Timer_timeout():
	if !is_player_asleep:
		emit_signal(
			"set_star_coin_increase",
			TAX_STAR_COINS
		)

func _stop_Tax_Timer():
	is_player_asleep = true
