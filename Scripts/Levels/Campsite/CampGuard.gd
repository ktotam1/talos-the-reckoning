extends Area2D


@onready var path = get_parent()
@export var speed = 20
@export var stop_time = 3
@export var flip_flipped = false
@onready var animator = $AnimatedSprite2D
@onready var timer = $Timer
var move = true
var recently_stopped = false

@export var shift_at_half_time = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func animate():
	if move:
		animator.play("walking")
	else:
		animator.play("idle")
	if shift_at_half_time and path.get_progress_ratio() > .5:
		animator.flip_h = not flip_flipped
	else: animator.flip_h = flip_flipped

func _physics_process(delta):
	if shift_at_half_time and recently_stopped and (abs(path.get_progress_ratio() - 0.5) > 0.01 and abs(path.get_progress_ratio()) > 0.01):
		recently_stopped = false
	if shift_at_half_time and !recently_stopped and ((path.get_progress_ratio() - 0.5 > 0 and path.get_progress_ratio() - 0.5 < 0.01) or abs(path.get_progress_ratio()) < 0.01):
		move = false
		recently_stopped = true
		timer.start(stop_time)
	animate()
	
	if move:
		path.set_progress(path.get_progress() + speed * delta)


func _on_timer_timeout():
	move = true # Replace with function body.
