extends Node2D

onready var Enemy = preload("res://Enemy.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var special_cull = 0.13 # the number a randf must be lower than to make an enemy level up, essentially

func get_enemy(): # returns an enemy
	print("making enemy...")
	var enemy = Enemy.instance()
	return enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
