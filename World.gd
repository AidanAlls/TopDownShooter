extends Node2D

onready var loot_generator = LootGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(loot_generator)
	var player = $Player
	player.current_item = generate_loot()
	player.add_child(player.current_item)

func _process(delta):
	pass

func generate_loot():
	return(loot_generator.generate_loot(1))# this 1 should be player level