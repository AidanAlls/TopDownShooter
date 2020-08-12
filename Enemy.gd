extends KinematicBody2D

class_name Enemy

export var level = 1
export var health = 100

var is_idle = true
var world
var player
var distance_to_player
export var notice_distance = 300
export var max_distance = 280 # the maximum distance the enemy wants to be
var min_distance
export var distance_range = 135 # will be subtracted from max distance to get min distance

export var attack_timer_start = .9 # where the attack timer resets each time
export var attack_timer = .9 # the starting attack time, in seconds

export var projectile_count = 5
export var projectile_speed = 300
export var projectile_life = 1.0

export var max_speed = 110
export var ACCELERATION = 1000
var motion = Vector2.ZERO

var current_item
export var armor_mult = 1 # a value of less than one will reduce damage taken by that amoubnt
var normal_color = Color(1, 1, 1, 1)

var rng
var hit_marker = preload("res://HitMarker.tscn")
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_node("/root").get_child(0)
	player = world.get_child(0)
	
	# setup rng
	rng = RandomNumberGenerator.new()
	
	# setup timer
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout")
	add_child(timer) #to process
	
	# setup min distance
	min_distance = max_distance - distance_range
	
	# setup item
	current_item = PigWeapon.new()
	current_item.projectile_count = projectile_count
	current_item.projectile_speed = projectile_speed
	current_item.projectile_life = projectile_life
	add_child(current_item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if world.has_node("Player"):
		distance_to_player = get_distance_to(player)
		if is_idle:
			if distance_to_player <= notice_distance:
				notice_player()
		else: # if actively pursuing player
			# movement
			var axis = get_movement_axis(player)
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
					$AnimatedSprite.play("Idle") # Walk_Right
				# THE LEFT MOVEMENT ANIMATORS
				elif axis.x < -.5 and axis.y > .5:		# left down
					pass
				elif axis.x < -.5 and axis.y < -.5:		# left up
					pass
				elif axis.x < -.5:						# just left
					$AnimatedSprite.play("Idle") # Walk_Left
				# THE DOWN MOVEMENT ANIMATOR
				elif axis.y > .5:						# just down
					$AnimatedSprite.play("Idle") # Walk Down
				# THE UP MOVEMENT ANIMATOR
				elif axis.y < -.5:						# just up
					$AnimatedSprite.play("Idle") # Walk_Up
			motion = move_and_slide(motion) # move_and_slide can be changed to a different algorithm
			# attacking
			if attack_timer <= 0: # that means it can attack
				current_item.use()
				attack_timer = attack_timer_start
			else:
				attack_timer = attack_timer - delta

func get_distance_to(object): # gets the distance to a given object
	var obj_pos = object.get_global_position()
	var pos = get_global_position()
	
	var max_x = max(obj_pos.x, pos.x)
	var max_y = max(obj_pos.y, pos.y)
	var min_x = min(obj_pos.x, pos.x)
	var min_y = min(obj_pos.y, pos.y)
	
	var x_dist = max_x - min_x
	var y_dist = max_y - min_y
	
	if x_dist == 0 && y_dist == 0: # if both 0, we have no distance
		return 0
	
	if x_dist == 0: # then y_dist is dist
		return y_dist
	
	if y_dist == 0: # then x_dist is 0
		return x_dist
	
	return sqrt(x_dist*x_dist + y_dist*y_dist) #return the distance

func get_movement_axis(object): # this is where complex behaviours can be added
	var axis = Vector2(0,0) # if nothing else happens, should be 0,0
	if distance_to_player >= max_distance:
		axis = position.direction_to(object.get_global_position())
	elif distance_to_player <= min_distance:
		axis = position.direction_to(object.get_global_position())
		axis.x = -axis.x
		axis.y = -axis.y # turns it backwards
	return axis

func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(max_speed)

func notice_player():
	is_idle = false
	# play notice animation/sound

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
	timer.stop()
	timer.wait_time = 0.5
	timer.start()
	
	# check if dead
	if health <= 0:
		die()

func _on_timer_timeout():
	modulate = normal_color

func die():
	# die animation, sound, etc. goes before queue free
	queue_free()
	
func get_class(): return "Enemy"