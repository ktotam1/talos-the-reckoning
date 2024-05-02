extends Area2D


@onready var path = get_parent()
@export var speed = 23
@export var stop_time = 3
@onready var animator = $AnimatedSprite2D
var move = true
var recently_stopped = false

@export var shift_at_half_time = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func animate():
	if move:
		animator.play("walking")
	else:
		animator.play("idle")
	if shift_at_half_time:
		if path.get_progress_ratio() > .5:
			animator.flip_h = true
		else: animator.flip_h = false

func _physics_process(delta):
	#if shift_at_half_time and recently_stopped and (abs(path.get_progress_ratio() - 0.5) > 0.01 and abs(path.get_progress_ratio()) > 0.01):
	#	recently_stopped = false
	#if shift_at_half_time and !recently_stopped and ((path.get_progress_ratio() - 0.5 > 0 and path.get_progress_ratio() - 0.5 < 0.01) or abs(path.get_progress_ratio()) < 0.01):
	#	move = false
	#	recently_stopped = true
	animate()
	
	if move:
		path.set_progress(path.get_progress() + speed * delta)



func _on_area_entered(area):
	if "player" in area.name:
		move = false
		recently_stopped = true
		DialogueManager.show_dialogue_balloon_scene(load(Globals.balloon_scene_path), load("res://Resources/UI/Dialogues/intro.dialogue"), "scene_2")
		#DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
		
