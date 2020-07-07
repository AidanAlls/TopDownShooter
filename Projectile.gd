extends RigidBody2D

class_name Projectile

var lifetime
var damage
var scalar

# Called when the node enters the scene tree for the first time.
func _ready():
	$"AnimatedSprite".play("Projectile")
	
	gravity_scale = 0

func _process(delta):
	scale = Vector2(1*scalar, 1*scalar) # for some reason this has to be set every process?

func _physics_process(delta):
	if lifetime <= 0:
		explode()
	lifetime = lifetime - delta

func explode(): # what happens when it breaks
	set_can_sleep(true)
	set_sleeping(true)	# these two lines make sure it won't move anymore
	
	# animate explosion
	rotate(-rotation)
	set_global_rotation(-global_rotation) # these two lines roughly align the explosion to be upright everytime
	$"AnimatedSprite".play("Explosion")
	yield($"AnimatedSprite", "animation_finished") # makes sure to wait for the animation to finish before removing
	
	# remove from world
	queue_free()

func _on_Projectile_body_entered(body):
	if body.get_class() == "Enemy":
		body.take_damage(damage)
	explode()
