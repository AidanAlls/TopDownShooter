extends Node

class_name LootGenerator

onready var rng = RandomNumberGenerator.new()
onready var level_1_cores = []
onready var level_1_mod1s = []
onready var level_1_mod2s = []
onready var level_1_mod3s = []

func _ready():
	rng = RandomNumberGenerator.new()
	
	setup_cores()
	setup_mod1s()
	setup_mod2s()
	setup_mod3s()
	

func generate_loot(level): # takes in loot level, returns weapon
	var weapon = Weapon.new()
	rng.randomize()
	# Get the cores
	var core = level_1_cores[rng.randi_range(0, level_1_cores.size() - 1)]
	var mod1 = level_1_mod1s[rng.randi_range(0, level_1_mod1s.size() - 1)]
	var mod2 = level_1_mod2s[rng.randi_range(0, level_1_mod2s.size() - 1)]
	var mod3 = level_1_mod3s[rng.randi_range(0, level_1_mod3s.size() - 1)]
	# THE ALGORITHMS
	# Name
	weapon.name = mod1.name_segment + " " + mod2.name_segment + " " + mod3.name_segment + " " + core.name_segment
	# Scale
	weapon.scale_mult = core.scale_mult_mod * mod1.scale_mult_mod * mod2.scale_mult_mod * mod3.scale_mult_mod
	# Projectile Count
	weapon.projectile_count = core.projectile_count_mod * mod1.projectile_count_mod * mod2.projectile_count_mod * mod3.projectile_count_mod
	# Projectile Life
	weapon.projectile_life = core.projectile_life_mod * mod1.projectile_life_mod * mod2.projectile_life_mod * mod3.projectile_life_mod
	# Projectile Speed
	weapon.projectile_speed = core.projectile_speed_mod * mod1.projectile_speed_mod * mod2.projectile_speed_mod * mod3.projectile_speed_mod
	# Projectile Size
	weapon.projectile_size_mult = core.projectile_size_mult_mod * mod1.projectile_size_mult_mod * mod2.projectile_size_mult_mod * mod3.projectile_size_mult_mod
	# Projectile Color
	weapon.projectile_color = core.projectile_color_mod * mod1.projectile_color_mod * mod2.projectile_color_mod * mod3.projectile_color_mod
	# Accuracy
	weapon.accuracy = core.accuracy_mod * mod1.accuracy_mod * mod2.accuracy_mod * mod3.accuracy_mod
	# Damage
	weapon.damage = core.damage_mod * mod1.damage_mod * mod2.damage_mod * mod3.damage_mod
	# Energy Amount
	weapon.energy_amount = core.energy_amount_mod * mod1.energy_amount_mod * mod2.energy_amount_mod * mod3.energy_amount_mod
	# Energy Drain
	weapon.energy_drain = core.energy_drain_mod * mod1.energy_drain_mod * mod2.energy_drain_mod * mod3.energy_drain_mod
	# Energy Cooldown
	weapon.energy_cooldown = core.energy_cooldown_mod * mod1.energy_cooldown_mod * mod2.energy_cooldown_mod * mod3.energy_cooldown_mod
	# Energy Recharge
	weapon.energy_recharge = core.energy_recharge_mod * mod1.energy_recharge_mod * mod2.energy_recharge_mod * mod3.energy_recharge_mod
	# Use Rate
	weapon.use_rate = core.use_rate_mod * mod1.use_rate_mod * mod2.use_rate_mod * mod3.use_rate_mod
	
	return weapon

func setup_cores(): # creates and adds cores to the core pool
	# LEVEL 1 CORES
	# Stinger
	var core_stinger = Weapon_Part.new() # create new part
	core_stinger.name_segment = "Stinger"
	core_stinger.damage_mod = 5
	core_stinger.projectile_size_mult_mod = 1
	core_stinger.projectile_speed_mod = 820
	core_stinger.accuracy_mod = .18
	core_stinger.use_rate_mod = .08
	core_stinger.projectile_color_mod = Color(.9, .9, .8, 1)
	level_1_cores.append(core_stinger) # add it to the array
	# Twin
	var core_twin = Weapon_Part.new() # create new part
	core_twin.name_segment = "Twin"
	core_twin.damage_mod = 4
	core_twin.projectile_count_mod = 2
	core_twin.projectile_speed_mod = 800
	core_twin.projectile_color_mod = Color(1, 1, 1, 1)
	core_twin.accuracy_mod = .3
	core_stinger.use_rate_mod = .15
	level_1_cores.append(core_twin) # add it to the array
	# Magic Stick
	var core_magic_stick = Weapon_Part.new() # create new part
	core_magic_stick.name_segment = "Magic Stick"
	core_magic_stick.damage_mod = 7
	core_magic_stick.projectile_size_mult_mod = 2.5
	core_magic_stick.projectile_color_mod = Color(1, 1, 1, .6)
	core_magic_stick.projectile_speed_mod = 780
	level_1_cores.append(core_magic_stick) # add it to the array

func setup_mod1s():
	# LEVEL 1 MOD1s
	# Slightly
	var mod1_slightly = Weapon_Part.new() # create new part
	mod1_slightly.name_segment = "Slightly"
	mod1_slightly.damage_mod = 1.1
	mod1_slightly.accuracy_mod = 0.9
	mod1_slightly.projectile_size_mult_mod = 0.9
	mod1_slightly.use_rate_mod = 1.1
	mod1_slightly.projectile_color_mod = Color(1, 1, .8, 1)
	level_1_mod1s.append(mod1_slightly) # add it to the array
	# Swiftly
	var mod1_swiftly = Weapon_Part.new() # create new part
	mod1_swiftly.name_segment = "Swiftly"
	mod1_swiftly.accuracy_mod = 0.8
	mod1_swiftly.projectile_size_mult_mod = 0.9
	mod1_swiftly.use_rate_mod = 1.15
	mod1_swiftly.projectile_speed_mod = 1.2
	level_1_mod1s.append(mod1_swiftly) # add it to the array
	# Questionably
	var mod1_questionably = Weapon_Part.new() # create new part
	mod1_questionably.name_segment = "Questionably"
	mod1_questionably.accuracy_mod = 1.25
	mod1_questionably.projectile_size_mult_mod = 0.5
	mod1_questionably.use_rate_mod = 1.1
	mod1_questionably.projectile_speed_mod = 1.2
	mod1_questionably.projectile_color_mod = Color(.2, .3, 1, 1)
	level_1_mod1s.append(mod1_questionably) # add it to the array

func setup_mod2s():
	# LEVEL 2 MOD2s
	# Disgusting
	var mod2_disqusting = Weapon_Part.new() # create new part
	mod2_disqusting.name_segment = "Disgusting"
	mod2_disqusting.damage_mod = 1.7
	mod2_disqusting.accuracy_mod = 1.1
	mod2_disqusting.use_rate_mod = 1.1
	level_1_mod2s.append(mod2_disqusting) # add it to the array
	# Exhilarating
	var mod2_exhilarating = Weapon_Part.new() # create new part
	mod2_exhilarating.name_segment = "Exhilarating"
	mod2_exhilarating.damage_mod = .9
	mod2_exhilarating.accuracy_mod = .8
	mod2_exhilarating.use_rate_mod = 0.9
	mod2_exhilarating.projectile_speed_mod = 1.05
	level_1_mod2s.append(mod2_exhilarating) # add it to the array
	# Enticing
	var mod2_enticing = Weapon_Part.new() # create new part
	mod2_enticing.name_segment = "Enticing"
	mod2_enticing.damage_mod = 1.2
	mod2_enticing.accuracy_mod = 1.1
	mod2_enticing.use_rate_mod = 1.1
	level_1_mod2s.append(mod2_enticing) # add it to the array

func setup_mod3s():
	# LEVEL 1 MOD3s
	# Mini
	var mod3_mini = Weapon_Part.new() # create new part
	mod3_mini.name_segment = "Mini -"
	mod3_mini.scale_mult_mod = .7
	mod3_mini.damage_mod = 1.34
	mod3_mini.projectile_size_mult_mod = 0.5
	level_1_mod3s.append(mod3_mini) # add it to the array
	# Double
	var mod3_double = Weapon_Part.new() # create new part
	mod3_double.name_segment = "Double"
	mod3_double.damage_mod = .9
	mod3_double.projectile_size_mult_mod = 0.8
	mod3_double.projectile_count_mod = 2
	level_1_mod3s.append(mod3_double) # add it to the array
	# Triple
	var mod3_triple = Weapon_Part.new() # create new part
	mod3_triple.name_segment = "Triple"
	mod3_triple.damage_mod = .7
	mod3_triple.projectile_size_mult_mod = 0.7
	mod3_triple.projectile_count_mod = 3
	mod3_triple.use_rate_mod = 1.2
	level_1_mod3s.append(mod3_triple) # add it to the array