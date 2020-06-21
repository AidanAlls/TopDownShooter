extends Weapon

class_name PigWeapon

export var spread = 100 # the number of degrees the projectiles are spread between
var step_degree
var holder # the parent node

# Called when the node enters the scene tree for the first time.
func _ready():
	# THIS SHOULD BE Bullet.tscn !!!!
	projectile = preload("res://Projectile.tscn") # shoots bullets instead of magic projectiles
	
	# setting up the spread in radians
	step_degree = deg2rad(spread/projectile_count)
	spread = deg2rad(spread)
	
	holder = get_node("..")
	set_pickable(false)
	
	player = holder.get_node("..").get_child(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func use():
	animated_sprite.play("Use")
	for i in range(projectile_count): # makes the correct number of projectiles
		var projectile_instance = projectile.instance()
		var p_pos = player.get_global_position()
		var rot = holder.get_angle_to(p_pos)
		print("rot: " + str(rot))
		projectile_instance.damage = damage
		projectile_instance.lifetime = projectile_life
		projectile_instance.position = projectile_point.get_global_position()
		projectile_instance.rotation = rot - spread/2 + i*step_degree
		projectile_instance.scalar = projectile_size_mult
		projectile_instance.modulate = projectile_color
		projectile_instance.apply_impulse(Vector2(), Vector2(projectile_speed, 0).rotated(rot - spread/2 + i*step_degree))
		get_tree().get_root().add_child(projectile_instance)
	
	can_use = false # begin buffer use period
	yield(get_tree().create_timer(use_rate), "timeout")
	can_use = true # resetting to true after a period of use_rate

func get_class(): return "PigWeapon"