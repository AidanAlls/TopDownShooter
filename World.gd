extends Node2D

onready var loot_generator = LootGenerator.new()

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(loot_generator)
	player = $Player
	player.add_item(generate_loot(0)) # putting in 0 means changes loot level relative to player level by 0 when generating loot

func _process(delta):
	if Input.is_action_just_released("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func generate_loot(mod):
	return(loot_generator.generate_loot(1 + mod))# this 1 should be player level