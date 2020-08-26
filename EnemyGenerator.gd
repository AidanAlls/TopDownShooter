extends Node2D

onready var Enemy = preload("res://Enemy.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var special_cull = 0.13 # the number a randf must be lower than to make an enemy level up, essentially

func get_enemy(): # returns an enemy
	print("making enemy...")
	var enemy
	randomize()
	if randf() < special_cull: # will be at least level 2
		randomize()
		if randf() < special_cull: # will be level 3
			return make_enemy(3) # returns level 3
		return make_enemy(2) # returns level 2
	return make_enemy(1) # fails special enemy cutoff, so is just normal

func make_enemy(level): # returns a specific enemy of the given level
	var enemy = Enemy.instance()
	enemy = assign_role(enemy) # assign its role
	if level == 2: # don't need one for level 1 because it won't change anything
		enemy.scale = enemy.scale * 1.5
		enemy.modulate = Color(1, .7, .5, 1)
		enemy.normal_color = Color(1, .7, .5, 1)
		enemy.health = enemy.health * 1.5
	if level >= 3: # level 3+ most powerful, all become level 3
		enemy.scale = enemy.scale * 1.8
		enemy.modulate = Color(1, .5, .5, 1)
		enemy.normal_color = Color(1, .5, .5, 1)
		enemy.health = enemy.health * 2
	return enemy

func assign_role(enemy): # specializes the enemy
	var num_types = 4
	randomize()
	var type = randi() % num_types
	if type == 0: # 5 shot shotgun
		enemy.projectile_speed = 400
	if type == 1: # 4 shot shotgun
		enemy.projectile_count = 4
		enemy.projectile_speed = 420
		enemy.max_distance = 240
		enemy.distance_range = 120
		enemy.max_speed = 120
		enemy.attack_timer_start = .8
		enemy.attack_timer = .8
	if type == 2: # sniper
		enemy.projectile_count = 1
		enemy.projectile_speed = 750
		enemy.max_distance = 400
		enemy.distance_range = 50
		enemy.max_speed = 80
		enemy.attack_timer_start = 1.5
		enemy.attack_timer = .3
	if type == 3: # machine gun
		enemy.projectile_count = 1
		enemy.projectile_speed = 600
		enemy.attack_timer = 1
		enemy.attack_timer_start = 0.15
		enemy.max_distance = 275
		enemy.distance_range = 100
		enemy.max_speed = 105
	return enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
