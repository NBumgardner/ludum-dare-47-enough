extends KinematicBody2D

const ACCELERATION = 1500
onready var MarketAreaDatabase = load("res://assets/market_area_database.gd")

onready var INCOME_FROM_MARKET_AREA_BED_HEALTH = _get_income(
	"Bed", "health")
onready var INCOME_FROM_MARKET_AREA_BED_STAR_COINS = _get_income(
	"Bed", "star_coins")
onready var INCOME_FROM_MARKET_AREA_HOUSE_ENVELOPES = _get_income(
	"House", "envelopes")
onready var INCOME_FROM_MARKET_AREA_HOUSE_PIZZA_SLICES = _get_income(
	"House", "pizza_slices")
onready var INCOME_FROM_MARKET_AREA_MAILBOX_HEALTH = _get_income(
	"Mailbox", "health")
onready var INCOME_FROM_MARKET_AREA_MAILBOX_STAR_COINS = _get_income(
	"Mailbox", "star_coins")
onready var INCOME_FROM_MARKET_AREA_MAILBOX_ENVELOPES = _get_income(
	"Mailbox", "envelopes")
onready var INCOME_FROM_MARKET_AREA_PIZZA_BOX_PIZZA_SLICES = _get_income(
	"PizzaBox", "pizza_slices")
onready var INCOME_FROM_MARKET_AREA_PIZZA_BOX_STAR_COINS = _get_income(
	"PizzaBox", "star_coins")
onready var INCOME_FROM_MARKET_AREA_VALENTINE_ENVELOPES = _get_income(
	"Valentine", "envelopes")
onready var INCOME_FROM_MARKET_AREA_VALENTINE_HEALTH = _get_income(
	"Valentine", "health")
onready var INCOME_FROM_MARKET_AREA_VALENTINE_SMILE = _get_income(
	"Valentine", "smile")
onready var INCOME_FROM_MARKET_AREA_SAW_HEALTH = _get_income(
	"Saw", "health")
onready var INCOME_FROM_MARKET_AREA_SAW_SMILE = _get_income(
	"Saw", "smile")
onready var INCOME_FROM_MARKET_AREA_SAW_STAR_COINS = _get_income(
	"Saw", "star_coins")

const MAX_SPEED = 400
const TAX_HEALTH = -1

var is_player_asleep = true
var motion = Vector2()
var player_is_inside = []

signal activate_market_area_bed(body)
signal activate_market_area_house(body)
signal activate_market_area_mailbox(body)
signal activate_market_area_pizza_box(body)
signal activate_market_area_saw(body)
signal activate_market_area_valentine(body)
signal cannot_affort_market_area_bed(body)
signal cannot_affort_market_area_house(body)
signal cannot_affort_market_area_mailbox(body)
signal cannot_affort_market_area_pizza_box(body)
signal cannot_affort_market_area_valentine(body)
signal set_envelope_increase(amount)
signal set_health_increase(amount)
signal set_pizza_slice_increase(amount)
signal set_smile_increase(amount)
signal set_star_coin_increase(amount)


onready var game_over_conditions = get_node("/root/GameOverConditions")
onready var player_variables = get_node("/root/PlayerVariables")


# Player Movement methods
func _physics_process(delta):
	# Stop timer and moving if player is out of money or health
	if game_over_conditions.is_player_out_of_health():
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


# Validate if Player May Use a Market Area
func _can_afford(costs):
	var can_afford = true

	if (typeof(costs) != TYPE_ARRAY
		|| costs[0] != "MarketArea"
		|| costs.size() != 7):
		return false

	var income_envelopes = costs[
		MarketAreaDatabase.market_area_index_income_envelopes
	]
	var income_pizza_slices = costs[
		MarketAreaDatabase.market_area_index_income_health
	]
	var income_star_coins = costs[
		MarketAreaDatabase.market_area_index_income_star_coins
	]

	if income_envelopes < 0:
		var player_envelopes = player_variables.player_currency_envelopes
		var remaining_envelopes = (
			player_envelopes
			+ income_envelopes
		)
		can_afford = can_afford && (
			remaining_envelopes >= 0
		)

	if income_pizza_slices < 0:
		var player_pizza_slices = player_variables.player_currency_pizza_slice
		var remaining_pizza_slices = (
			player_pizza_slices
			+ income_star_coins
		)
		can_afford = can_afford && (
			remaining_pizza_slices >= 0
		)

	if income_star_coins < 0:
		var player_star_coins = player_variables.player_currency_star_coin
		var remaining_star_coins = (
			player_star_coins
			+ income_star_coins
		)
		can_afford = can_afford && (
			remaining_star_coins >= 0
		)

	return can_afford

func _can_afford_and_benefit(costs):
	var can_afford = true
	var can_benefit = false

	if (typeof(costs) == TYPE_ARRAY
		&& costs[0] == "MarketArea"
		&& costs.size() == 7):
		can_afford = _can_afford(costs)
		can_benefit = _can_benefit(costs)

	return can_afford && can_benefit

func _can_benefit(costs):
	var can_benefit = false

	if (typeof(costs) != TYPE_ARRAY
		|| costs[0] != "MarketArea"
		|| costs.size() != 7):
		return false

	var income_health = costs[
		MarketAreaDatabase.market_area_index_income_health
	]
	var income_smile = costs[
		MarketAreaDatabase.market_area_index_income_smile
	]

	if income_health > 0:
		can_benefit = can_benefit || (
			player_variables.player_current_health
			< player_variables.INITIAL_MAX_HEALTH
		)

	if income_smile > 0:
		can_benefit = can_benefit || (
			player_variables.player_current_smile
			< player_variables.INITIAL_MAX_SMILE
		)

	return can_benefit

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


# Access Database fields
func _get_cost(market_area_name):
	return MarketAreaDatabase.DATA[
		MarketAreaDatabase.get(market_area_name)
	]

func _get_income(market_area_name, currency_name):
	var income = 0
	var income_index = 0

	match currency_name:
		"envelopes":
			income_index = MarketAreaDatabase.market_area_index_income_envelopes
		"health":
			income_index = MarketAreaDatabase.market_area_index_income_health
		"pizza_slices":
			income_index = (
				MarketAreaDatabase.market_area_index_income_pizza_slices
			)
		"smile":
			income_index = MarketAreaDatabase.market_area_index_income_smile
		"star_coins":
			income_index = (
				MarketAreaDatabase.market_area_index_income_star_coins
			)
		_:
			return income

	income = _get_cost(market_area_name)[income_index]

	return income


# Market Area Bed collision method
func _on_Market_Area_Bed_body_entered(body):
	if _can_afford_and_benefit(_get_cost("Bed")):
		_activate_Market_Area_Bed(body)
	else:
		emit_signal("cannot_affort_market_area_bed", body)


# Market Area House collision method
func _on_Market_Area_House_body_entered(body):
	if _can_afford_and_benefit(_get_cost("House")):
		_activate_Market_Area_House(body)
	else:
		emit_signal("cannot_affort_market_area_house", body)


# Market Area Mailbox collision method
func _on_Market_Area_Mailbox_body_entered(body):
	if _can_afford_and_benefit(_get_cost("Mailbox")):
		_activate_Market_Area_Mailbox(body)
	else:
		emit_signal("cannot_affort_market_area_mailbox", body)


# Market Area Pizza Box collision method
func _on_Market_Area_Pizza_Box_body_entered(body):
	if _can_afford_and_benefit(_get_cost("PizzaBox")):
		_activate_Market_Area_Pizza_Box(body)
	else:
		emit_signal("cannot_affort_market_area_pizza_box", body)


# Market Area Saw collision method
func _on_Market_Area_Saw_body_entered(body):
	_activate_Market_Area_Saw(body)


# Market Area Valentine collision method
func _on_Market_Area_Valentine_body_entered(body):
	if _can_afford_and_benefit(_get_cost("Valentine")):
		_activate_Market_Area_Valentine(body)
	else:
		emit_signal("cannot_affort_market_area_valentine", body)


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


# Logic for Market Area House
func _activate_Market_Area_House(body):
	emit_signal("activate_market_area_house", body)
	emit_signal(
		"set_envelope_increase",
		INCOME_FROM_MARKET_AREA_HOUSE_ENVELOPES
	)
	emit_signal(
		"set_pizza_slice_increase",
		INCOME_FROM_MARKET_AREA_HOUSE_PIZZA_SLICES
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


# Logic for Market Area Pizza Box
func _activate_Market_Area_Pizza_Box(body):
	emit_signal("activate_market_area_pizza_box", body)
	emit_signal(
		"set_pizza_slice_increase",
		INCOME_FROM_MARKET_AREA_PIZZA_BOX_PIZZA_SLICES
	)
	emit_signal(
		"set_star_coin_increase",
		INCOME_FROM_MARKET_AREA_PIZZA_BOX_STAR_COINS
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


# Logic for Market Area Valentine
func _activate_Market_Area_Valentine(body):
	emit_signal("activate_market_area_valentine", body)
	emit_signal(
		"set_envelope_increase",
		INCOME_FROM_MARKET_AREA_VALENTINE_ENVELOPES
	)
	emit_signal(
		"set_health_increase",
		INCOME_FROM_MARKET_AREA_VALENTINE_HEALTH
	)
	emit_signal(
		"set_smile_increase",
		INCOME_FROM_MARKET_AREA_VALENTINE_SMILE
	)

	if (OS.is_debug_build()):
		print("Player entered " + str(body))


# Logic for passive loss of health while smile is empty and game is not over
func _start_Tax_Timer():
	if is_player_asleep && !game_over_conditions.is_player_rich():
		is_player_asleep = false

func _on_Tax_Timer_timeout():
	if !is_player_asleep && player_variables.player_current_smile <= 0:
		emit_signal(
			"set_health_increase",
			TAX_HEALTH
		)

func _stop_Tax_Timer():
	is_player_asleep = true
