extends Node2D

onready var loot_generator = LootGenerator.new()
onready var world_gen = $WorldGenerator
onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(loot_generator)
	player.add_item(generate_loot(0)) # putting in 0 means changes loot level relative to player level by 0 when generating loot

func _process(delta):
	if Input.is_action_just_released("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func generate_loot(mod):
	return(loot_generator.generate_loot(1 + mod))# this 1 should be player level

func place_loot(pos, mod = 0):
	var weapon = generate_loot(mod)
	add_child(weapon)
	weapon.global_position = Vector2(pos.x - 32, pos.y)
	weapon.z_index = 3
	

func _input(event):
	if event.is_action_pressed("ui_select"):
		for n in world_gen.rooms.get_children():
			n.queue_free()
		world_gen.path = null
		world_gen.make_rooms()

	if event.is_action_pressed("ui_focus_next"):
		world_gen.make_map()
		world_gen.populate_rooms()
		world_gen.play_mode = true

func place_player_start():
	player.position = world_gen.start_room.position

func _on_WorldGenerator_finished_generation():
	place_player_start()
