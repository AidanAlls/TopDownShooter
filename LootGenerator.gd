extends Node

class_name LootGenerator

onready var rng = RandomNumberGenerator.new()
onready var level_1_cores = []

var wand_base = preload("res://WandAnimatedSprite.tscn")

func _ready():
	rng = RandomNumberGenerator.new()
	wand_base 
	

func generate_loot(weapon : Weapon, level): # takes in loot level, returns weapon
	weapon.image.texture = wand_base
	weapon.projectile_count = rng.randf_range(0,10)
	weapon.accuracy = rng.randf_range(0.1, 0.9)
	weapon.use_rate = rng.randf_range(.01, 4)
	return weapon