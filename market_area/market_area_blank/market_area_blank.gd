extends Area2D


var market_area_name = "Bed"


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect/MarginContainer/VerticalSections/HeaderTitle.text = market_area_name
	showElements()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func showElements():
	$TextureRect/MarginContainer/VerticalSections/HeaderTitle.visible = true
	$TextureRect/MarginContainer/VerticalSections/CostIcons.visible = true
	$TextureRect/MarginContainer/VerticalSections/BenefitIcons.visible = true
