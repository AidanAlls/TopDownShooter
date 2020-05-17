extends KinematicBody2D

var can_use = true # a boolean based on use_rate
export var worth = 0
export var level = 1
export var stack_limit = 1
export var use_rate = .15 # how long between each use (smaller = faster)

class_name Item

func _ready():
	pass

func use():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
