extends RigidBody2D

var lifetime
var damage
var scalar
var rng

var hit_marker = preload("res://HitMarker.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$"AnimatedSprite".play("Projectile")
	
	#setup rng
	rng = RandomNumberGenerator.new()
	
	gravity_scale = 0

func _process(delta):
	scale = Vector2(1*scalar, 1*scalar) # for some reason this has to be set every process?

func explode(): # what happens when it breaks
	set_can_sleep(true)
	set_sleeping(true)	# these two lines make sure it won't move anymore
	
	# create hitmarker
	var hit_marker_instance = hit_marker.instance()
	get_tree().get_root().add_child(hit_marker_instance)
	hit_marker_instance.set_global_position(global_position)
	hit_marker_instance.apply_impulse(Vector2(), Vector2(0, 100).rotated(rng.randf_range(2.4, 3.8)))
	hit_marker_instance.setup_text(String(damage)) # should be last because queue frees
	
	# animate explosion
	rotate(-rotation)
	set_global_rotation(-global_rotation) # these two lines roughly align the explosion to be upright everytime
	$"AnimatedSprite".play("Explosion")
	yield($"AnimatedSprite", "animation_finished") # makes sure to wait for the animation to finish before removing
	
	# remove from world
	queue_free()

func _on_Projectile_body_entered(body):
	#print("body: " + body.get_name() + " body parent: " + body.get_node("..").get_name())
	#if body.get_node("..").get_name() != "Player": # this is a SHITTY Workaround but the layers and masks just LITERALLY DONT FUCKING WORK
	explode()
