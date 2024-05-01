extends Node
class_name GameManager

signal toggle_game_paused(is_paused: bool)
signal save_game_signal
signal dialog_forward_input(event: InputEvent)

# Because of a bug in Godot not following the spec of GDScript's @export annotation, exporting this
# in the Global's file (where it should be) doesn't make it show up in the Inspector, making it 
# unfriendly for us game devs
# I am thus exporting it here
@export_file("*.tscn") var FIRST_LEVEL

@onready var current_level_parent = $"Gui/Current Level"


@onready var fader = $Gui/fader
@onready var fader_animation = $Gui/fader/AnimationPlayer
var new_level_scene_res

var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused",game_paused)

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.game_manager_singleton = self
	toggle_game_paused.connect($"CanvasLayer/Pause Menu".game_manager_requested_pause)
	set_current_level(FIRST_LEVEL)
	
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	DialogueManager.get_current_scene = func(): return current_level_parent
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel") and not Globals.is_in_dialogue:
		game_paused = !game_paused


func _on_pause_menu_save_button_pressed():
	# For now separate function, maybe we want to choose a save slot?
	save_game()


func save_game(): # Conn
	save_game_signal.emit() # For now only that
	
func set_current_level(scene_name : String):
	fader_animation.play("fade_to_black")
	var num_children = current_level_parent.get_child_count(false) # = 0 only on setup 
	if num_children > 1:
		push_error("Current Level Node has more than 1 child!")
	if num_children != 0:
		var current_level = current_level_parent.get_child(0)
		current_level.queue_free()
		
	new_level_scene_res = load(scene_name)
	
	get_tree().paused = true

func _on_dialogue_ended(_resource: DialogueResource):
	Globals.is_in_dialogue = false
	get_tree().paused = false


func _on_fader_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		var new_level_scene_node = new_level_scene_res.instantiate()	
		current_level_parent.add_child(new_level_scene_node)
		fader_animation.play("fade_to_normal")
	else:
		get_tree().paused = false
		
func change_fader_state(val):
	fader.visible = val
