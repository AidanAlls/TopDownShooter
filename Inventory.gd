extends Node # STANCE DANCE

class_name Inventory

var slot_count = 10
var used_slots = 0
var items # should be a dictionary where item is key, value is number of that item (should cap at each items stack_limit field)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
