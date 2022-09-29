# MarketArea = [
#   Type,
#   IncomeHealth,
#   IncomeSmile,
#   IncomeStarCoins,
#   IncomeEnvelopes,
#   IncomePizzaSlices,
#   Title
# ]

enum {
	Bed,
	House,
	Mailbox,
	PizzaBox,
	Saw,
	Valentine
}

const DEFAULT_MARKET_AREA = [
	"MarketArea",
	0,
	0,
	0,
	0,
	0,
	""
]

const DATA = {
	Bed: [
		"MarketArea",
		2,
		0,
		-1,
		0,
		0,
		"Bed"
	],
	House: [
		"MarketArea",
		0,
		0,
		0,
		-1,
		1,
		"House"
	],
	Mailbox: [
		"MarketArea",
		-1,
		0,
		-1,
		5,
		0,
		"Mailbox"
	],
	PizzaBox: [
		"MarketArea",
		0,
		0,
		20,
		0,
		-8,
		"PizzaBox"
	],
	Saw: [
		"MarketArea",
		-1,
		-1,
		2,
		0,
		0,
		"Saw"
	],
	Valentine: [
		"MarketArea",
		1,
		2,
		0,
		-1,
		0,
		"Valentine"
	]
}

const market_area_index_income_health = 1
const market_area_index_income_smile = 2
const market_area_index_income_star_coins = 3
const market_area_index_income_envelopes = 4
const market_area_index_income_pizza_slices = 5
