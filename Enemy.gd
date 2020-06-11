extends KinematicBody2D

class_name Enemy

var level = 1
var health = 100

var is_idle = true
var world
var player
var distance_to_player
var notice_distance = 300

var max_speed = 250
var ACCELERATION = 10000
var motion = Vector2.ZERO

var current_item

# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_node("..")
	player = world.get_node("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_idle:
		distance_to_player = get_distance_to(player)
		if distance_to_player <= notice_distance:
			notice_player()
	else: # if actively pursuing player
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
	return position.direction_to(object.get_global_position())

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
	print("Noticed player")