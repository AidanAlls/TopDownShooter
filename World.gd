extends Node2D

onready var loot_generator = LootGenerator.new()

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(loot_generator)
	player = $Player
	player.current_item = generate_loot(0) # putting in 0 means changes loot level relative to player level by 0 when generating loot
	player.add_child(player.current_item)
	player.current_item.item_beam.visible = false

func _process(delta):
	pass

func generate_loot(mod):
	return(loot_generator.generate_loot(1 + mod))# this 1 should be player level