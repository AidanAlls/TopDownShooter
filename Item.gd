extends KinematicBody2D

class_name Item

var can_use = true # a boolean based on use_rate
var parent

export var worth = 0
export var level = 1
export var stack_limit = 1
export var use_rate = .15 # how long between each use (smaller = faster)

func _ready():
	parent = get_node("..")

func use():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if parent.get_class() == "Player":
		look_at(get_global_mouse_position())
