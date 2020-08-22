extends Node2D

var room = preload("res://Room.tscn")

onready var rooms = $Rooms
onready var Map = $TileMap
onready var DetailMap = $TileMapDetails
onready var BorderMap = $BorderMap
onready var BorderMap_holder = TileMap.new()
onready var EnemyGenerator = $EnemyGenerator
onready var world = get_node("/root").get_child(0)
onready var Player = world.get_child(0)

var tile_size = 32
var num_rooms = 40
var min_size = 8
var max_size = 24
var h_spread = 400
var cull = 0.62 # rough percentage of rooms that will be removed 0.5 = 50%
var rock_cull = 0.05 # what percetage of tiles will have rocks on them
var enemy_cull = 0.005 # what percentage of tiles will have enemies on them
var screen_buffer = 30 # num tiles buffer from edge of map
var tile_buffer = 5 # num tiles buffer from edge of physical room collidor

var chest_room_limit = 15
var challenge_room_limit = 22

var path = null# an AStar pathfinding object
var start_room = null
var end_room = null
var play_mode = false

signal finished_generation

func _ready():
	randomize()
	make_rooms()

func make_rooms():
	for i in range(num_rooms):
		var pos = Vector2(rand_range(-h_spread, h_spread),0)
		var r = room.instance()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		r.make_room(pos, Vector2(w,h) * tile_size)
		$Rooms.add_child(r)
	# wait for movement to settle
	yield(get_tree().create_timer(1.1), "timeout")
	# cull rooms
	var room_positions = []
	for room in rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC
			room_positions.append(Vector3(room.position.x, room.position.y, 0))
	yield(get_tree(), "idle_frame")
	# generate a minimum spanning tree for pathways
	path = find_mst(room_positions)

func _draw():
	# start/end room drawing GOES HERE
	if play_mode:
		return
	for room in rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size * 2), Color(32, 228, 0), false)
	if path:
		for p in path.get_points():
			for c in path.get_point_connections(p):
				var p_pos = path.get_point_position(p)
				var c_pos = path.get_point_position(c)
				draw_line(Vector2(p_pos.x, p_pos.y), Vector2(c_pos.x, c_pos.y), Color(1, 1, 0), 15, true)

func _process(delta):
	update()

func find_mst(nodes):
	# Prim's algorithm
	var path = AStar.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	# repeat until no  nodes remain
	while nodes:
		var min_dist = INF # minimum dist so far
		var min_pos = null # the pos of that node
		var p = null # current position looking at
		# loop through all points
		for p1 in path.get_points():
			p1 = path.get_point_position(p1)
			# loop through the remaining points
			for p2 in nodes:
				var dist = p1.distance_to(p2)
				if dist < min_dist:
					min_dist = dist
					min_pos = p2
					p = p1
		var n = path.get_available_point_id()
		path.add_point(n, min_pos)
		path.connect_points(path.get_closest_point(p), n)
		nodes.erase(min_pos)
	return path

func make_map():
	# creates tilemap from generated rooms/paths
	Map.clear()
	
	# BACKGROUND 
	# fill area with ocean water
	var full_rect = Rect2()
	for room in rooms.get_children():
		var r = Rect2(room.position - room.size, room.get_node("CollisionShape2D").shape.extents*2)
		full_rect = full_rect.merge(r)
	var topleft = Map.world_to_map(full_rect.position)
	var bottomright = Map.world_to_map(full_rect.end)
	for x in range(topleft.x - screen_buffer, bottomright.x + screen_buffer):
		for y in range(topleft.y - screen_buffer, bottomright.y + screen_buffer):
			Map.set_cell(x, y, 0) # sets everything to water, CAN POTENTIALL JUST HAVE BACKGROUND BE WATER??
	
	var corridors = []
	
	# MAP
	# carve rooms
	for room in rooms.get_children():
		var tile_list = room.get_room_tiles() # returns all the tiles that need to be removed from Map
		var tile_border_list = room.get_border_tiles()
		var border_list = room.find_unique(tile_border_list, tile_list)
		
		room.border_list = border_list
		
		remove_tiles(tile_list)
		place_room_tiles(tile_list, tile_border_list)
		update_border_map(border_list)
		
		# carve connecting corridor
		var p = path.get_closest_point(Vector3(room.position.x, room.position.y, 0))
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Map.world_to_map(Vector2(path.get_point_position(p).x, path.get_point_position(p).y))
				var end = Map.world_to_map(Vector2(path.get_point_position(conn).x, path.get_point_position(conn).y))
				carve_path(start, end)
		corridors.append(p)
	
	Map.update_bitmask_region() # updates bitmasks for auto tiles
	DetailMap.update_bitmask_region()
	
	# place special rooms
	find_start_room()
	find_end_room()
	
	# disable bordermap
	BorderMap_holder = BorderMap
	remove_child($BorderMap)
	
	emit_signal("finished_generation") # emits custom signal

func remove_tiles(pos_list): # removes tiles from the pos_list of global coords
	for pos in pos_list:
		pos = Map.world_to_map(pos)
		Map.set_cell(pos.x, pos.y, -1)
		DetailMap.set_cell(pos.x, pos.y, -1)

func place_room_tiles(pos_list, border_list):
	
	for pos in border_list: # border
		pos = Map.world_to_map(pos)
		DetailMap.set_cell(pos.x, pos.y, 0)
	
	
	for pos in pos_list: # snow
		pos = Map.world_to_map(pos)
		Map.set_cell(pos.x, pos.y, 1) # set snow
		#DetailMap.set_cell(pos.x, pos.y, -1) # remove border
		if randf() < rock_cull:
			DetailMap.set_cell(pos.x, pos.y, 1) # set rock
	

func place_enemies(pos_list, room):
	var e
	for pos in pos_list:
		if randf() < enemy_cull: # should be own number (not just cull)
			#pos = Map.world_to_map(pos)
			e = EnemyGenerator.get_enemy()
			room.Enemies.add_child(e)
			e.position = Map.map_to_world(Map.world_to_map(pos + Vector2(0, tile_size)))
	room.num_enemies = room.Enemies.get_child_count()

func update_border_map(pos_list): # Adds border blocks around a room, adding to the total border map that gets activated every time you enter a room
	for pos in pos_list:
		pos = Map.world_to_map(pos)
		BorderMap.set_cell(pos.x, pos.y, 0)

func find_start_room():
	# finds farthest left room
	var lowest_x = INF
	for room in rooms.get_children():
		if room.position.x < lowest_x:
			lowest_x = room.position.x
			start_room = room
	start_room.type = "start"

func find_end_room():
	# finds farthest left room
	var highest_x = -INF
	for room in rooms.get_children():
		if room.position.x > highest_x:
			highest_x = room.position.x
			end_room = room
	end_room.type = "end"

func carve_path(pos1, pos2): # carves a path from pos1 to pos2
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = pow(-1.0, randi() % 2) # in case 0
	if y_diff == 0: y_diff = pow(-1.0, randi() % 2) # in case 0
	# choose to go x val first or y val first
	var x_y = pos1
	var y_x = pos2
	if (randi() % 2) > 0:
		x_y = pos2
		y_x = pos1
	for x in range (pos1.x, pos2.x, x_diff):
		# set snow
		Map.set_cell(x, x_y.y, 1) # CHANGE THE CELL TYPE FROM 1
		Map.set_cell(x, x_y.y + y_diff, 1) # to widen the corridor
		# set border
		DetailMap.set_cell(x, x_y.y, 0)
		DetailMap.set_cell(x, x_y.y - y_diff, 0)
		DetailMap.set_cell(x, x_y.y + y_diff, 0)
		DetailMap.set_cell(x, x_y.y + 2*y_diff, 0)
	for y in range (pos1.y, pos2.y, y_diff):
		# set snow
		Map.set_cell(y_x.x, y, 1) # CHANGE THE CELL TYPE FROM 1
		Map.set_cell(y_x.x + x_diff, y, 1) # to widen the corridor
		# set border
		DetailMap.set_cell(y_x.x, y, 0)
		DetailMap.set_cell(y_x.x - x_diff, y, 0)
		DetailMap.set_cell(y_x.x + x_diff, y, 0)
		DetailMap.set_cell(y_x.x + 2*x_diff, y, 0)

func populate_rooms():
	var average_size
	var size_factor
	for room in rooms.get_children():
		if not (room.type == "start" || room.type == "end"): # they're already assigned, so don't want to overwrite
			average_size = (room.size.x + room.size.y) / 2
			size_factor = average_size / tile_size
			if size_factor < chest_room_limit:
				room.type = "chest"
			elif size_factor > challenge_room_limit:
				room.type = "challenge"
		room.populate()








