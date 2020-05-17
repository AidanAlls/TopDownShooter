extends Item

class_name Weapon

var rng
var projectile = preload("res://Projectile.tscn")

export var projectile_count = 7
export var projectile_life = 0 # how long it's alive/range
export var projectile_speed = 800
export var projectile_size_mult = 2 # multiplied by 1 in Vector2D
export var accuracy = 0.2 # lower is more accurate
export var damage = 1 # per projectile
export var energy_amount = 0 # 'clip size'
export var energy_drain = 0 # how much used per shot
export var energy_cooldown = 0 # how much time before it recharges
export var energy_recharge = 0 # how quickly it recharges

onready var player = get_node("..")
onready var projectile_point = Node2D.new()
onready var image = Sprite.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	image.translate(Vector2(0,25))
	add_child(image)
	
	projectile_point.translate(Vector2(64,25)) # set up spawn point for projectiles
	add_child(projectile_point)
	
	rng = RandomNumberGenerator.new()

func use():
	for i in range(projectile_count): # makes the correct number of projectiles
		var projectile_instance = projectile.instance()
		var rot = player.get_angle_to(get_global_mouse_position())
		projectile_instance.damage = damage
		projectile_instance.lifetime = projectile_life
		projectile_instance.position = projectile_point.get_global_position()
		projectile_instance.rotation = rot
		projectile_instance.scalar = projectile_size_mult
		projectile_instance.apply_impulse(Vector2(), Vector2(projectile_speed, 0).rotated(rot + rng.randf_range(-accuracy, accuracy)))
		get_tree().get_root().add_child(projectile_instance)
	
	can_use = false # begin buffer use period
	yield(get_tree().create_timer(use_rate), "timeout")
	can_use = true # resetting to true after a period of use_rate







































































































