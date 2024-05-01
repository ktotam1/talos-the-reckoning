extends Area2D


@onready var balloon_scene : PackedScene = load(Globals.balloon_scene_path)
@export var intro_dialogue : DialogueResource = load("res://Resources/UI/Dialogues/intro.dialogue")
@export var start = "scene_1"


# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(_on_dialogue_start_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dialogue_start_area_entered(area):
	DialogueManager.show_dialogue_balloon_scene(balloon_scene, intro_dialogue, start)
