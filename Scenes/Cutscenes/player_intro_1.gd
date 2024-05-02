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
		elif setup_stage %2 == 1:
			move = true
			

func _on_dialogue_ended(_res):
	$"AnimatedSprite2D".rotation = 0
	setup_stage += 1


func _on_area_entered(area):
	if "petra" in area.name:
		move = false
		recently_stopped = true
		setup_stage+=1
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
		DialogueManager.show_dialogue_balloon_scene(load(Globals.balloon_scene_path), load("res://Resources/UI/Dialogues/intro.dialogue"), "scene_3")

		area.speed = 8
		area.move = true
		var path :Path2D = area.get_parent().get_parent()
		path.curve.set_point_position(1,Vector2(1,65))
		path.curve.set_point_position(2,Vector2(0,65))
	elif "portal" in area.name:
		Globals.game_manager_singleton.set_current_level("res://Scenes/Levels/level_1.tscn")
			
