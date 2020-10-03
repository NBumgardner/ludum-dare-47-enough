extends KinematicBody2D

const ACCELERATION = 750
const DECELERATION = ACCELERATION * 2
const MAX_SPEED = 400

var motion = Vector2()

func _physics_process(delta):
	var axis = _get_input_axis()
	if axis == Vector2.ZERO:
		_apply_friction(DECELERATION * delta)
	else:
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


# Market Area Welcome collision methods
func _on_Market_Area_Welcome_body_entered(_body):
	if (OS.is_debug_build()):
		print("Welcome to the market!")

func _on_Market_Area_Welcome_body_exited(_body):
	if (OS.is_debug_build()):
		print("Please come again!")
