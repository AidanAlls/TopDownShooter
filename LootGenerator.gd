extends Node

class_name LootGenerator

onready var rng = RandomNumberGenerator.new()
onready var level_1_cores = []

func _ready():
	rng = RandomNumberGenerator.new()
	

func generate_loot(level): # takes in loot level, returns weapon
	var weapon = Weapon.new()
	rng.randomize()
	weapon.projectile_count = rng.randf_range(0,7)
	weapon.accuracy = rng.randf_range(0.1, 0.5)
	weapon.use_rate = rng.randf_range(.001, 2)
	return weapon