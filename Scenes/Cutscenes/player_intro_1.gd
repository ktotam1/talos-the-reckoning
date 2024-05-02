extends Area2D


@onready var path = get_parent()
@export var speed = 20
@export var stop_time = 3
@onready var animator = $AnimatedSprite2D
var move = false
var recently_stopped = false
var setup_stage = 0

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

func _physics_process(delta):
	animate()
	if move and not Globals.is_in_dialogue:
		path.set_progress(path.get_progress() + speed * delta)
	else:
		if setup_stage == 0:
			DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
			DialogueManager.show_dialogue_balloon_scene(load(Globals.balloon_scene_path), load("res://Resources/UI/Dialogues/intro.dialogue"), "scene_2")
		move = true

func _on_dialogue_ended(_res):
	$"AnimatedSprite2D".rotation = 0
	setup_stage += 1
