extends Node

onready var animated_sprite = AnimatedSprite.new()
onready var sprite_frames = SpriteFrames.new()
onready var collider = CollisionShape2D.new()
onready var shape = RectangleShape2D.new()

var world

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_animations()
	
	shape.extents = Vector2(36.8, 25)
	add_child(collider)
	collider.shape = shape
	
	world = get_node("..")

func set_animations():
	add_child(animated_sprite)
	animated_sprite.scale = Vector2(2.3, 2.3)
	animated_sprite.frames = sprite_frames
	#Idle
	sprite_frames.add_animation("Idle")
	sprite_frames.add_frame("Idle", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-0.png"), -1)
	sprite_frames.set_animation_loop("Idle", false)
	animated_sprite.play("Idle")
	#Open
	sprite_frames.add_animation("Open")
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-1.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-2.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-3.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-4.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-5.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-6.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-7.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-8.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-9.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-10.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-11.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-12.png"), -1)
	sprite_frames.add_frame("Open", load("res://Assets/Animation Sprites/Police Chest Open/Police-Chest-Open-13.png"), -1)
	sprite_frames.set_animation_loop("Open", false) # should be false
	sprite_frames.set_animation_speed("Open", 10)

func open():
	animated_sprite.play("Open")
	yield(animated_sprite, "animation_finished")
	var weapon = world.generate_loot()
	weapon.position = Vector2(self.position.x, self.position.y)
	world.add_child(weapon)
	weapon.z_index = 2
	weapon.translate(Vector2(-32, 0))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Chest_body_entered(body):
	open()
