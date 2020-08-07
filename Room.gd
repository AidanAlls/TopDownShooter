extends RigidBody2D

onready var type = ""
onready var Map = $TileMap
onready var DetailMap = $TileMapDetails
onready var Collider = $CollisionShape2D

var size
var size_factor
var tile_size = 32
var tile_buffer = 2
var tile_border_buffer
var world


var chest = preload("res://Chest.tscn")

func _ready():
	world = get_node("/root").get_child(0)

# makes room in initial position BEFORE COLLISION MOVES EVERYTHING
func make_room(_pos, _size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.custom_solver_bias = .75
	s.extents = size
	$CollisionShape2D.shape = s
	
	var average_size = (size.x + size.y) / 2
	size_factor = int(average_size / tile_size)
	tile_border_buffer = tile_buffer - 1

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
	
	return pos_list

func make_room_map():
	Map.clear()
	DetailMap.clear()
	align_to_world()
	
	var s = (size / tile_size).floor() # half number of tiles (tile extents)
	var upper_left = -s
	var current_pos
	var pos_list = [] # every tile we change we need to remove from world map background
	
	var global_node = Node2D.new() # used to convert coords to global coords
	add_child(global_node)
	# set snow
	for x in range (tile_buffer, s.x * 2 - tile_buffer): # starts at 2 so buffer of 2 tiles
		for y in range(tile_buffer, s.y * 2 - tile_buffer):
			current_pos = Vector2(upper_left.x + x, upper_left.y + y)
			#Map.set_cell(current_pos.x, current_pos.y, 1)
			current_pos = Map.map_to_world(current_pos) # turns it into actual position
			global_node.position = current_pos
			current_pos = global_node.global_position # convert to global coords
			pos_list.append(current_pos ) # we need to remove the water tiles from world map bc they are the collsion tiles
	
	# set snow border
	for x in range (tile_border_buffer, s.x * 2 - tile_border_buffer): # starts at 1 so outside of tiles
		for y in range(tile_border_buffer, s.y * 2 - tile_border_buffer):
			DetailMap.set_cell(upper_left.x + x, upper_left.y + y, 0)
	
	Map.update_bitmask_region()
	DetailMap.update_bitmask_region()
	return pos_list

func align_to_world(): # aligns to world tilemap
	Collider.disabled = true
	var world_map = world.get_node("WorldGenerator").Map
	
	position = world_map.map_to_world(world_map.world_to_map(position))
	

func populate():
	if type == "start":
		pass
	elif type == "end":
		pass
	elif type == "chest":
		print("chest room!")
		var c = chest.instance()
		add_child(c)
		c.global_position = global_position #Vector2(global_position.x, global_position.y)
		c.z_index = 1
		return
	elif type == "challenge":
		pass
	else: # standard room w enemies
		pass