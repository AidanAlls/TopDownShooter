extends RigidBody2D

var lifetime
var damage
var scalar

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Animated Sprite".play("Projectile")
	gravity_scale = 0

func _process(delta):
	scale = Vector2(1*scalar, 1*scalar) # for some reason this has to be set every process?

func _on_Projectile_body_entered(body):
	set_can_sleep(true)
	set_sleeping(true)	# these two lines make sure it won't move anymore
	rotate(-rotation)
	set_global_rotation(-global_rotation) # these two lines roughly align the explosion to be upright everytime
	$"Animated Sprite".play("Explosion")
	yield($"Animated Sprite", "animation_finished") # makes sure to wait for the animation to finish before removing
	queue_free()