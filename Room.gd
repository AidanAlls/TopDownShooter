# world gen/physical world, but not entire enviroenment (no chests

extends RigidBody2D

onready var type = ""
onready var Map = $TileMap
onready var DetailMap = $TileMapDetails
onready var Collider = $CollisionShape2D
onready var Enemies = $Enemies
onready var world = get_node("/root").get_child(0)
onready var player = world.get_child(0)
onready var world_gen = world.get_child(1)
onready var BorderMap = world_gen.get_child(3)

var size
var size_factor
var min_dimension = 0
var tile_size = 32
var tile_buffer = 2
var tile_border_buffer
var distance_to_player = 0
var unvisited = true
var finished = false
var tile_list # all the floor tiles
var tile_border_list # all the floor tiles plus a border (for trim)
var border_list # all the edge tiles (no inner tiles included)
var num_enemies = 10000


var chest = preload("res://Chest.tscn")

func _ready():
	pass

func _process(delta):
	if finished:
		return
	if unvisited && (type != "start"):
		distance_to_player = get_distance_to(player)
		if distance_to_player < min_dimension*0.5:
			unvisited = false
			activate_room()
	else: # if visited but not finished AKA still fighting
		num_enemies = Enemies.get_child_count()
		if num_enemies <= 0:
			finish_room()

# makes room in initial position BEFORE COLLISION MOVES EVERYTHING
func make_room(_pos, _size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.custom_solver_bias = .75
	s.extents = size
	$CollisionShape2D.shape = s
	
	var average_size = (size.x + size.y) / 2
	min_dimension = min(size.x, size.y)
	size_factor = int(average_size / tile_size)
	tile_border_buffer = tile_buffer - 1

func activate_room():
	world_gen.place_enemies(tile_list, self)
	world_gen.BorderMap = world_gen.BorderMap_holder
	world_gen.add_child(world_gen.BorderMap)
	BorderMap.visible = true

func finish_room():
	# do pickup spawning here
	BorderMap.visible = false
	world_gen.remove_child(world_gen.BorderMap)
	finished = true

func get_room_tiles(): # returns a list of all the tiles the room is made of
	var s = (size / tile_size).floor() # half number of tiles (tile extents)
	var upper_left = -s
	var current_pos
	var pos_list = [] # every tile we change we need to remove from world map background
	var global_node = Node2D.new() # used to convert coords to global coords
	add_child(global_node)
	
	for x in range (tile_buffer, s.x * 2 - tile_buffer): # starts at 2 so buffer of 2 tiles
		for y in range(tile_buffer, s.y * 2 - tile_buffer):
			current_pos = Vector2(upper_left.x + x, upper_left.y + y)
			current_pos = Map.map_to_world(current_pos) # turns it into actual position
			global_node.position = current_pos
			current_pos = global_node.global_position # convert to global coords
			pos_list.append(current_pos ) # we need to remove the water tiles from world map bc they are the collsion tiles
	
	tile_list = pos_list
	return pos_list

func get_border_tiles():
	var s = (size / tile_size).floor() # half number of tiles (tile extents)
	var upper_left = -s
	var current_pos
	var pos_list = [] # every tile we change we need to remove from world map background
	var global_node = Node2D.new() # used to convert coords to global coords
	add_child(global_node)
	
	for x in range (tile_border_buffer, s.x * 2 - tile_border_buffer): # starts at 1 so outside of tiles
		for y in range(tile_border_buffer, s.y * 2 - tile_border_buffer):
			current_pos = Vector2(upper_left.x + x, upper_left.y + y)
			current_pos = Map.map_to_world(current_pos) # turns it into actual position
			global_node.position = current_pos
			current_pos = global_node.global_position # convert to global coords
			pos_list.append(current_pos ) # we need to remove the water tiles from world map bc they are the collsion tiles
	
	tile_border_list = pos_list
	return pos_list

func populate():
	if type == "start":
		return
	elif type == "end":
		return
	elif type == "chest":
		var c = chest.instance()
		add_child(c)
		c.global_position = global_position #Vector2(global_position.x, global_position.y)
		c.z_index = 1
		return
	elif type == "challenge":
		pass
	else: # standard room w enemies
		pass

func find_unique(set1, set2): #returns the items only found in set1
	var unique_set = []
	for item in set1:
		if ! set2.has(item):
			unique_set.append(item)
	return unique_set

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