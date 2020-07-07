extends Weapon

class_name PigWeapon

export var step_degree = 27
var spread

var world

# Called when the node enters the scene tree for the first time.
func _ready():
	# THIS SHOULD BE Bullet.tscn !!!!
	projectile = preload("res://Bullet.tscn") # shoots bullets instead of magic projectiles
	
	# setting up the spread/step_degree in radians
	step_degree = deg2rad(step_degree)
	spread = step_degree*(projectile_count-1)
	
	# OVERWRITES
	is_pickable = false
	
	player = parent.get_node("..").get_child(0)
	world = parent.get_node("..")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func use():
	animated_sprite.play("Use")
	for i in range(projectile_count): # makes the correct number of projectiles
		var projectile_instance = projectile.instance()
		var rot = parent.get_angle_to(player.get_global_position())
		rot = rot - spread/2 + i*step_degree
		projectile_instance.damage = damage
		projectile_instance.lifetime = projectile_life
		projectile_instance.position = projectile_point.get_global_position()
		projectile_instance.rotation = rot
		projectile_instance.scalar = projectile_size_mult
		projectile_instance.modulate = projectile_color
		projectile_instance.apply_impulse(Vector2(), Vector2(projectile_speed, 0).rotated(rot))
		get_tree().get_root().add_child(projectile_instance)
	

func _process(delta):
	if parent.get_class() == "Enemy" && world.has_node("Player"):
		look_at(player.get_global_position())

func get_class(): return "PigWeapon"