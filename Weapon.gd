extends Item

class_name Weapon

var rng
var projectile = preload("res://Projectile.tscn")
var scale_mult = 1.6 # 1 is actual size, bigger is larger
var is_pickable = true

export var projectile_count = 7
export var projectile_life = 10 # how long it's alive/range
export var projectile_speed = 800
export var projectile_size_mult = 2 # multiplied by 1 in Vector2D
export var projectile_color = Color(1,1,1,1)
export var accuracy = 0.2 # lower is more accurate
export var damage = 1 # per projectile
export var energy_amount = 0 # 'clip size'
export var energy_drain = 0 # how much used per shot
export var energy_cooldown = 0 # how much time before it recharges
export var energy_recharge = 0 # how quickly it recharges
#children nodes
onready var player = get_tree().root.get_child(0).get_child(0)
onready var animated_sprite = AnimatedSprite.new() # the image for the weapon
onready var animator = SpriteFrames.new() # the spriteframes for the image
onready var projectile_point = Node2D.new() # where the projectiles come from
onready var item_beam = ItemBeam.new()
onready var click_area = CollisionShape2D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	#collider
	add_child(click_area)
	var shape = CapsuleShape2D.new()
	shape.radius = 5 + 1 * scale_mult
	shape.height = 16 + 6 * scale_mult
	click_area.shape = shape
	click_area.rotation_degrees = 90
	click_area.position = Vector2(24 + 10 * scale_mult, 0)
	click_area.connect("input_event", self, "_input_event")
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)
	set_collision_layer_bit(4, true)
	set_collision_mask_bit(4, true)
	set_pickable(true)
	
	# item beam
	add_child(item_beam)
	item_beam.translate(Vector2(32, 0))
	item_beam.scale = Vector2(2, 2)
	
	# big stuff
	setup_proj_point()
	setup_animator()
	
	#setup rng
	rng = RandomNumberGenerator.new()

func setup_proj_point(): #sets up where the projectiles come out
	add_child(projectile_point)
	projectile_point.translate(Vector2((36 + 32*(scale_mult*.5)),0)) # set up spawn point for projectiles

func setup_animator():
	add_child(animated_sprite)
	animated_sprite.translate(Vector2(32,0)) # move it over  the length of an item
	animated_sprite.scale = Vector2(1*scale_mult, 1*scale_mult)
	animated_sprite.frames = animator
	#TEMPORARY FROM HERE DOWN, this will be part of loot generation
	animator.add_animation("Idle")
	animator.add_frame("Idle", load("res://Assets/Animation Sprites/Wand Use/Wand_Use-1.png"), -1)
	animated_sprite.play("Idle")
	animator.set_animation_loop("Idle", false)
	animated_sprite.connect("animation_finished", self, "return_idle") # makes idle the resting state
	
	animator.add_animation("Use")
	animator.add_frame("Use", load("res://Assets/Animation Sprites/Wand Use/Wand_Use-1.png"), -1)
	animator.add_frame("Use", load("res://Assets/Animation Sprites/Wand Use/Wand_Use-2.png"), -1)
	animator.add_frame("Use", load("res://Assets/Animation Sprites/Wand Use/Wand_Use-3.png"), -1)
	animator.add_frame("Use", load("res://Assets/Animation Sprites/Wand Use/Wand_Use-4.png"), -1)
	animator.add_frame("Use", load("res://Assets/Animation Sprites/Wand Use/Wand_Use-5.png"), -1)
	animator.add_frame("Use", load("res://Assets/Animation Sprites/Wand Use/Wand_Use-1.png"), -1)
	animator.set_animation_speed("Use", 8)
	animator.set_animation_loop("Use", false)

func _process(delta):
	pass

func use():
	animated_sprite.play("Use")
	for i in range(projectile_count): # makes the correct number of projectiles
		var projectile_instance = projectile.instance()
		var rot = player.get_angle_to(get_global_mouse_position())
		projectile_instance.damage = damage
		projectile_instance.lifetime = projectile_life
		projectile_instance.position = projectile_point.get_global_position()
		projectile_instance.rotation = rot
		projectile_instance.scalar = projectile_size_mult
		projectile_instance.modulate = projectile_color
		projectile_instance.apply_impulse(Vector2(), Vector2(projectile_speed, 0).rotated(rot + rng.randf_range(-accuracy, accuracy)))
		get_tree().get_root().add_child(projectile_instance)
	
	can_use = false # begin buffer use period
	yield(get_tree().create_timer(use_rate), "timeout")
	can_use = true # resetting to true after a period of use_rate

func return_idle():
	animated_sprite.play("Idle")

func get_class(): return "Weapon"

func _input_event(viewport, event, shape_idx):
	if is_pickable:
		if get_node("..").get_class() != "Player":
			get_node("..").remove_child(self)
			player.add_item(self)
			parent = player
			position = Vector2(0,0)
