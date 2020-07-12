extends RigidBody2D

onready var animated_sprite = AnimatedSprite.new()
onready var sprite_frames = SpriteFrames.new()
onready var collider = CollisionShape2D.new()
onready var shape = RectangleShape2D.new()

var world
var player
var can_open = true

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_animations()
	
	shape.extents = Vector2(36.8, 25)
	add_child(collider)
	collider.shape = shape
	world = get_node("/root").get_child(0)
	player = world.get_node("Player")
	
	set_contact_monitor(true)
	set_max_contacts_reported(1)

func set_animations():
	add_child(animated_sprite)
	animated_sprite.scale = Vector2(2.3, 2.3)
	animated_sprite.frames = sprite_frames
	#Idle
	sprite_frames.add_animation("Idle")
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-0.png"), -1)
	sprite_frames.set_animation_loop("Idle", false)
	animated_sprite.play("Idle")
	#Open
	sprite_frames.add_animation("Open")
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-1.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-2.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-3.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-4.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-5.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-6.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-7.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-8.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-9.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-10.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-11.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-12.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-13.png"), -1)
	sprite_frames.set_animation_loop("Open", false) # should be false
	sprite_frames.set_animation_speed("Open", 10)

func open():
	animated_sprite.play("Open")
	yield(animated_sprite, "animation_finished")
	world.place_loot(global_position)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("interact"):
		if can_open:
			player = world.get_node("Player")
			print("player pos: " + str(player.position))
			print("distance: " + str(position.distance_to(player.position)))
			if world.has_node("Player"):
				var distance_to_player = get_distance_to(player)
				if distance_to_player < 60:
					print("it's close enough")
					open()
					can_open = false

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