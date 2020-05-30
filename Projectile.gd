extends RigidBody2D

var lifetime
var damage
var scalar

# Called when the node enters the scene tree for the first time.
func _ready():
	$"AnimatedSprite".play("Projectile")
	
	gravity_scale = 0

func _process(delta):
	scale = Vector2(1*scalar, 1*scalar) # for some reason this has to be set every process?

func explode(): # what happens when it breaks
	set_can_sleep(true)
	set_sleeping(true)	# these two lines make sure it won't move anymore
	rotate(-rotation)
	set_global_rotation(-global_rotation) # these two lines roughly align the explosion to be upright everytime
	$"AnimatedSprite".play("Explosion")
	yield($"AnimatedSprite", "animation_finished") # makes sure to wait for the animation to finish before removing
	queue_free()

func _on_Projectile_body_entered(body):
	#print("body: " + body.get_name() + " body parent: " + body.get_node("..").get_name())
	#if body.get_node("..").get_name() != "Player": # this is a SHITTY Workaround but the layers and masks just LITERALLY DONT FUCKING WORK
	explode()
