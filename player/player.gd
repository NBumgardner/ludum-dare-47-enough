extends KinematicBody2D

const ACCELERATION = 1500
onready var MarketAreaDatabase = load("res://assets/market_area_database.gd")

const MAX_SPEED = 400
const TAX_HEALTH = -1

var is_player_asleep = true
var motion = Vector2()
var player_is_inside = []


# 6 signals for activating a market area successfully.
# Generated dynamically by function _activate_Market_Area.
#warning-ignore:unused_signal
signal activate_market_area_bed(body)
#warning-ignore:unused_signal
signal activate_market_area_house(body)
#warning-ignore:unused_signal
signal activate_market_area_mailbox(body)
#warning-ignore:unused_signal
signal activate_market_area_pizza_box(body)
#warning-ignore:unused_signal
signal activate_market_area_saw(body)
#warning-ignore:unused_signal
signal activate_market_area_valentine(body)


# 5 signals for failing to activate a market area which is too expensive to use.
signal cannot_afford_market_area_bed(body)
signal cannot_afford_market_area_house(body)
signal cannot_afford_market_area_mailbox(body)
signal cannot_afford_market_area_pizza_box(body)
signal cannot_afford_market_area_valentine(body)


# 5 signals for increasing or decreasing a player resource.
# Generated dynamically by function _activate_Market_Area.
#warning-ignore:unused_signal
signal set_envelope_increase(amount)
#warning-ignore:unused_signal
signal set_health_increase(amount)
#warning-ignore:unused_signal
signal set_pizza_slice_increase(amount)
#warning-ignore:unused_signal
signal set_smile_increase(amount)
#warning-ignore:unused_signal
signal set_star_coin_increase(amount)


onready var game_over_conditions = get_node("/root/GameOverConditions")
onready var player_variables = get_node("/root/PlayerVariables")

var income_types = [
	"envelope",
	"health",
	"pizza_slice",
	"smile",
	"star_coin"
]

var income_types_limited = [
	"health",
	"smile"
]

var income_types_unlimited = [
	"envelope",
	"pizza_slice",
	"star_coin"
]

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
	motion = motion.limit_length(MAX_SPEED)


# Validate if Player May Use a Market Area
func _can_afford(costs):
	var can_afford = true

	if (typeof(costs) != TYPE_ARRAY
		|| costs[0] != "MarketArea"
		|| costs.size() != 7):
		return false

	var income_envelope = costs[
		MarketAreaDatabase.market_area_index_income_envelope
	]
	var income_pizza_slice = costs[
		MarketAreaDatabase.market_area_index_income_pizza_slice
	]
	var income_star_coin = costs[
		MarketAreaDatabase.market_area_index_income_star_coin
	]

	if income_envelope < 0:
		var player_envelope = player_variables.player_currency_envelope
		var remaining_envelope = (
			player_envelope
			+ income_envelope
		)
		can_afford = can_afford && (
			remaining_envelope >= 0
		)

	if income_pizza_slice < 0:
		var player_pizza_slice = player_variables.player_currency_pizza_slice
		var remaining_pizza_slice = (
			player_pizza_slice
			+ income_pizza_slice
		)
		can_afford = can_afford && (
			remaining_pizza_slice >= 0
		)

	if income_star_coin < 0:
		var player_star_coin = player_variables.player_currency_star_coin
		var remaining_star_coin = (
			player_star_coin
			+ income_star_coin
		)
		can_afford = can_afford && (
			remaining_star_coin >= 0
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

	# Check if any unlimited currency would be increased.
	for income_type in income_types_unlimited:
		var income = _get_income(
			costs[MarketAreaDatabase.market_area_index_title],
			income_type
		)
		if income > 0:
			can_benefit = true

	# Check if any limited currency would be increased.
	for income_type in income_types_limited:
		var income = _get_income(
			costs[MarketAreaDatabase.market_area_index_title],
			income_type
		)
		if income > 0:
			can_benefit = can_benefit || (
				_get_player_currency_amount(income_type)
				< _get_player_currency_maximum(income_type)
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
	var sanitized_currency_name = currency_name.to_lower()
	var income = 0
	var income_index = 0

	match sanitized_currency_name:
		"envelope":
			income_index = MarketAreaDatabase.market_area_index_income_envelope
		"health":
			income_index = MarketAreaDatabase.market_area_index_income_health
		"pizza_slice":
			income_index = (
				MarketAreaDatabase.market_area_index_income_pizza_slice
			)
		"smile":
			income_index = MarketAreaDatabase.market_area_index_income_smile
		"star_coin":
			income_index = (
				MarketAreaDatabase.market_area_index_income_star_coin
			)
		_:
			return income

	income = _get_cost(market_area_name)[income_index]

	return income

func _get_player_currency_amount(currency_name):
	var amount = 0

	match currency_name:
		"envelope":
			amount = player_variables.player_current_envelope
		"health":
			amount = player_variables.player_current_health
		"pizza_slice":
			amount = player_variables.player_current_pizza_slice
		"smile":
			amount = player_variables.player_current_smile
		"star_coin":
			amount = player_variables.player_current_star_coin
		_:
			return amount

	return amount

func _get_player_currency_maximum(currency_name):
	var maximum = 0

	match currency_name:
		"health":
			maximum = player_variables.INITIAL_MAX_HEALTH
		"smile":
			maximum = player_variables.INITIAL_MAX_SMILE
		_:
			return maximum

	return maximum


# Market Area Bed collision method
func _on_Market_Area_Bed_body_entered(body):
	if _can_afford_and_benefit(_get_cost("Bed")):
		_activate_Market_Area_Bed(body)
	else:
		emit_signal("cannot_afford_market_area_bed", body)


# Market Area House collision method
func _on_Market_Area_House_body_entered(body):
	if _can_afford_and_benefit(_get_cost("House")):
		_activate_Market_Area_House(body)
	else:
		emit_signal("cannot_afford_market_area_house", body)


# Market Area Mailbox collision method
func _on_Market_Area_Mailbox_body_entered(body):
	if _can_afford_and_benefit(_get_cost("Mailbox")):
		_activate_Market_Area_Mailbox(body)
	else:
		emit_signal("cannot_afford_market_area_mailbox", body)


# Market Area Pizza Box collision method
func _on_Market_Area_Pizza_Box_body_entered(body):
	if _can_afford_and_benefit(_get_cost("PizzaBox")):
		_activate_Market_Area_Pizza_Box(body)
	else:
		emit_signal("cannot_afford_market_area_pizza_box", body)


# Market Area Saw collision method
func _on_Market_Area_Saw_body_entered(body):
	_activate_Market_Area_Saw(body)


# Market Area Valentine collision method
func _on_Market_Area_Valentine_body_entered(body):
	if _can_afford_and_benefit(_get_cost("Valentine")):
		_activate_Market_Area_Valentine(body)
	else:
		emit_signal("cannot_afford_market_area_valentine", body)


# Logic for Market Areas
func _activate_Market_Area_Bed(body):
	_activate_Market_Area("Bed", "bed", body)

func _activate_Market_Area_House(body):
	_activate_Market_Area("House", "house", body)

func _activate_Market_Area_Mailbox(body):
	_activate_Market_Area("Mailbox", "mailbox", body)

func _activate_Market_Area_Pizza_Box(body):
	_activate_Market_Area("PizzaBox", "pizza_box", body)

func _activate_Market_Area_Saw(body):
	_activate_Market_Area("Saw", "saw", body)

func _activate_Market_Area_Valentine(body):
	_activate_Market_Area("Valentine", "valentine", body)

func _activate_Market_Area(
	market_area_name,
	activate_market_area_name,
	body
):
	var _signal_name_activate = "activate_market_area_" + \
		activate_market_area_name
	emit_signal(_signal_name_activate, body)

	for incomeType in income_types:
		var _increase = _get_income(market_area_name, incomeType)
		
		if _increase != 0:
			var _signal_name_income = "set_" + incomeType + "_increase"
			emit_signal(
				_signal_name_income,
				_get_income(market_area_name, incomeType)
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
