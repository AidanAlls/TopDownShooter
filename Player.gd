extends KinematicBody2D

var max_speed = 250
var ACCELERATION = 10000
var motion = Vector2.ZERO
var current_item = preload("res://Weapon.tscn") # this initializer is temporary
var level = 1

func _ready():
	pass

func _physics_process(delta):
	#temporary
	if Input.is_action_just_released("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	# Item use
	if Input.is_action_pressed("use_item") and current_item.can_use:
		current_item.use()
	# Movement
	var axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
		$AnimatedSprite.play("Idle") # Plays idle animation when stopped
	else:
		apply_movement(axis * ACCELERATION * delta) # apply movement
		# update animations
		# THE RIGHT MOVEMENT ANIMATORS
		if axis.x > .5 and axis.y > .5:			# right down
			pass
		elif axis.x > .5 and axis.y < -.5:		# right up
			pass
		elif axis.x > .5:						# just right
			$AnimatedSprite.play("Walk_Right")
		# THE LEFT MOVEMENT ANIMATORS
		elif axis.x < -.5 and axis.y > .5:		# left down
			pass
		elif axis.x < -.5 and axis.y < -.5:		# left up
			pass
		elif axis.x < -.5:						# just left
			$AnimatedSprite.play("Walk_Left")
		# THE DOWN MOVEMENT ANIMATOR
		elif axis.y > .5:						# just down
			$AnimatedSprite.play("Walk_Down")
		# THE UP MOVEMENT ANIMATOR
		elif axis.y < -.5:						# just up
			$AnimatedSprite.play("Walk_Up")
	motion = move_and_slide(motion) # move_and_slide can be changed to a different algorithm

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	axis.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return axis.normalized()

func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(max_speed)

func render_current_item():
	pass

func get_pos():
	return get_global_position()

