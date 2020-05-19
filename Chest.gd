extends Node

onready var animated_sprite = AnimatedSprite.new()
onready var sprite_frames = SpriteFrames.new()
onready var collider = CollisionShape2D.new()
onready var shape = RectangleShape2D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(animated_sprite)
	animated_sprite.frames = sprite_frames
	sprite_frames.add_animation("Idle") #TEMPORARY
	sprite_frames.add_frame("Idle", load("res://icon.png"), -1)
	sprite_frames.set_animation_loop("Idle", false)
	animated_sprite.play("Idle")
	
	add_child(collider)
	collider.shape = shape
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
