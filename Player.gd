extends KinematicBody2D

class_name Player

var level = 1

var max_speed = 220
var ACCELERATION = 10000
var motion = Vector2.ZERO

var inventory = {}
var current_item
var current_item_index = 0

var hit_timer

func _ready():
	pass

func _physics_process(delta):
	# Item selection
	if Input.is_action_just_released("scroll_up"):
		cycle_up()
	elif Input.is_action_just_released("scroll_down"):
		cycle_down()
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
			$AnimatedSprite.play("Walk_Right") # Walk_Right
		# THE LEFT MOVEMENT ANIMATORS
		elif axis.x < -.5 and axis.y > .5:		# left down
			pass
		elif axis.x < -.5 and axis.y < -.5:		# left up
			pass
		elif axis.x < -.5:						# just left
			$AnimatedSprite.play("Walk_Left") # Walk_Left
		# THE DOWN MOVEMENT ANIMATOR
		elif axis.y > .5:						# just down
			$AnimatedSprite.play("Idle") # Walk Down
		# THE UP MOVEMENT ANIMATOR
		elif axis.y < -.5:						# just up
			$AnimatedSprite.play("Idle") # Walk_Up
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

func add_item(item): # adds item to inventory
	add_child(item)
	item.item_beam.visible = false # don't want it to show up anymore
	if inventory.has(item):
		inventory[item] += 1
		return
	inventory[item] = 1
	if current_item == null: # if not holding anything, want to put it in hand
		current_item = item

func remove_item(item): # removes item from inventory
	remove_child(item)
	if inventory.has(item):
		inventory.erase(item)
	else:
		print("nothing to remove!")

func cycle_up():
	current_item.visible = false
	if current_item_index + 1 >= inventory.size(): # can't have index of size or more
		current_item_index = 0
	else:
		current_item_index += 1
	current_item = inventory.keys()[current_item_index]
	#current_item.position = position
	current_item.visible = true
	print("Weapon is now: " + current_item.name)

func cycle_down():
	current_item.visible = false
	if current_item_index - 1 <= -1: # can't have index of -1 or less
		current_item_index = inventory.size() - 1
	else:
		current_item_index -= 1
	current_item = inventory.keys()[current_item_index]
	#current_item.position = position
	current_item.visible = true
	print("Weapon is now: " + current_item.name)

func get_pos():
	return get_global_position()

func get_class(): return "Player"