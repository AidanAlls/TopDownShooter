extends RigidBody2D

onready var type = ""

var size
var tile_size = 32

var chest = preload("res://Chest.tscn")

func make_room(_pos, _size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.custom_solver_bias = .75
	s.extents = size
	$CollisionShape2D.shape = s

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