extends Node

const INITIAL_HEALTH = 10
const INITIAL_MAX_HEALTH = 10
const INITIAL_STAR_COINS = 5
const PLAYER_HEALTH = INITIAL_HEALTH

var player_currency_star_coin


func _ready():
	player_currency_star_coin = INITIAL_STAR_COINS
