extends AnimatedSprite

class_name ItemBeam

onready var sprite_frames = SpriteFrames.new()

func _ready():
	frames = sprite_frames
	sprite_frames.add_animation("Idle")
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Item Beam/Item-Beam-0.png"), -1)
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Item Beam/Item-Beam-1.png"), -1)
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Item Beam/Item-Beam-2.png"), -1)
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Item Beam/Item-Beam-3.png"), -1)
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Item Beam/Item-Beam-4.png"), -1)
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Item Beam/Item-Beam-5.png"), -1)
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Item Beam/Item-Beam-6.png"), -1)
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Item Beam/Item-Beam-7.png"), -1)
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Item Beam/Item-Beam-8.png"), -1)
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Item Beam/Item-Beam-9.png"), -1)
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Item Beam/Item-Beam-10.png"), -1)
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Item Beam/Item-Beam-11.png"), -1)
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Item Beam/Item-Beam-12.png"), -1)
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Item Beam/Item-Beam-13.png"), -1)
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Item Beam/Item-Beam-14.png"), -1)
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Item Beam/Item-Beam-15.png"), -1)
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Item Beam/Item-Beam-16.png"), -1)
	sprite_frames.set_animation_speed("Idle", 13)
	play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
