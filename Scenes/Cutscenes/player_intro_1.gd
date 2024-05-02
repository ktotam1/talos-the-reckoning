extends Area2D


@onready var path = get_parent()
@export var speed = 20
@export var stop_time = 3
@onready var animator = $AnimatedSprite2D
@onready var timer = $Timer
var move = false
var die = false
var recently_stopped = false
var setup_stage = 0

@export var shift_at_half_time = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func go_next():
	if die:
		Globals.game_manager_singleton.set_current_level("res://Scenes/Levels/campsite.tscn")

func animate():
	if die:
		animator.play("die")
		return
	elif move:
		animator.play("walking")
	else:
		animator.play("idle")
	if shift_at_half_time:
		if path.get_progress_ratio() > .5:
			animator.flip_h = true
		else: animator.flip_h = false

func _physics_process(delta):
	if shift_at_half_time and recently_stopped and (abs(path.get_progress_ratio() - 0.5) > 0.01 and abs(path.get_progress_ratio()) > 0.01):
		recently_stopped = false
	if shift_at_half_time and !recently_stopped and ((path.get_progress_ratio() - 0.5 > 0 and path.get_progress_ratio() - 0.5 < 0.01) or abs(path.get_progress_ratio()) < 0.01):
		move = false
		recently_stopped = true
		timer.start(stop_time)
	if path.get_progress_ratio() >= 0.99 and not die:
		die = true
	animate()
	
	if move and not die:
		path.set_progress(path.get_progress() + speed * delta)
	
	if not move:
		if setup_stage == 0:
			DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
			DialogueManager.show_dialogue_balloon_scene(load(Globals.balloon_scene_path), load("res://Resources/UI/Dialogues/intro.dialogue"), "scene_2")
		move = true

func _on_dialogue_ended(_res):
	$"AnimatedSprite2D".rotation = 0
	setup_stage += 1
