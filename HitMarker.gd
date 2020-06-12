extends RigidBody2D

var time_left = 1.3

# Called when the node enters the scene tree for the first time.
func _ready():
	rotate(-rotation)
	set_global_rotation(-global_rotation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time_left > 0:
		scale.x = scale.x - delta * 30 * (1.0 - time_left)
		scale.y = scale.y - delta * 30 * (1.0 - time_left)
		time_left = time_left - delta
	else: # time_left < 0
		queue_free()


func setup_text(text): # sets up text and timer to queue free
	$RichTextLabel.add_text(text)
