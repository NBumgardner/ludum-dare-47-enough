extends Node

const INITIAL_ENVELOPES = 0
const INITIAL_HEALTH = 10
const INITIAL_MAX_HEALTH = 10
const INITIAL_PIZZA_SLICES = 0
const INITIAL_STAR_COINS = 5
const PLAYER_HEALTH = INITIAL_HEALTH

var player_currency_envelope
var player_currency_pizza_slice
var player_currency_star_coin


func _ready():
	player_currency_envelope = INITIAL_ENVELOPES
	player_currency_pizza_slice = INITIAL_PIZZA_SLICES
	player_currency_star_coin = INITIAL_STAR_COINS
