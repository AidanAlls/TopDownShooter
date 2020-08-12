extends KinematicBody2D

class_name Player

var level = 1
var health = 4
var armor_mult = 1 # a value of less than one will reduce damage taken by that amoubnt

var max_speed = 420
var ACCELERATION = 10000
var motion = Vector2.ZERO

var inventory = {}
var current_item
var current_item_index = 0

var rng
var hit_timer
var hit_marker = preload("res://HitMarker.tscn")

func _ready():
	# setup rng
	rng = RandomNumberGenerator.new()
	
	# setup timer
	hit_timer = $HitTimer

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

func take_damage(amount):
	amount = amount * armor_mult
	health = health - amount
	
	# create hitmarker
	rng.randomize()
	var hit_marker_instance = hit_marker.instance()
	get_tree().get_root().add_child(hit_marker_instance)
	hit_marker_instance.set_global_position(global_position)
	hit_marker_instance.apply_impulse(Vector2(), Vector2(0, 100).rotated(rng.randf_range(2.4, 3.8)))
	hit_marker_instance.setup_text(String(amount)) # should be last because queue frees
	
	# blink red
	modulate = Color(1, 0, 0, 1)
	hit_timer.stop()
	hit_timer.wait_time = 0.35
	hit_timer.start()
	
	# check if dead
	if health <= 0:
		die()

func _on_HitTimer_timeout():
	modulate = Color(1,1,1,1)

func die():
	#put animation/sounds here
	queue_free()

func get_pos():
	return get_global_position()

func get_class(): return "Player"

