extends 'res://addons/gut/test.gd'

onready var player_variables = get_node("/root/PlayerVariables")

func test_player_initial_counters_not_negative():
	assert_false(
		player_variables.INITIAL_ENVELOPES < 0,
		"Should pass, envelopes start not negative"
	)
	assert_false(
		player_variables.INITIAL_HEALTH < 0,
		"Should pass, health starts not negative"
	)
	assert_false(
		player_variables.INITIAL_PIZZA_SLICES < 0,
		"Should pass, pizza slices start not negative"
	)
	assert_false(
		player_variables.INITIAL_SMILE < 0,
		"Should pass, smile starts not negative"
	)
	assert_false(
		player_variables.INITIAL_STAR_COINS < 0,
		"Should pass, star coins start not negative"
	)

func test_player_initial_health_not_greater_than_maximum():
	assert_false(
		player_variables.INITIAL_HEALTH > player_variables.INITIAL_MAX_HEALTH,
		"Should pass, health starts less than or equal to max health"
	)

func test_player_initial_health_positive():
	assert_true(
		player_variables.INITIAL_HEALTH > 0,
		"Should pass, health starts positive"
	)

func test_player_initial_smile_not_greater_than_maximum():
	assert_false(
		player_variables.INITIAL_MAX_SMILE > player_variables.INITIAL_MAX_SMILE,
		"Should pass, smile starts less than or equal to max health"
	)

func test_player_initial_smile_positive():
	assert_true(
		player_variables.INITIAL_SMILE > 0,
		"Should pass, smile starts positive"
	)
