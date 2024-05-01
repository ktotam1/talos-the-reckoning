extends Node

# Script containing project-wide Globals

# [SAVES]
const ROOT_DIR = "user://";

const SAVES_DIR_NAME = "saves/";
const SAVES_FULL_DIR = ROOT_DIR+SAVES_DIR_NAME;

const SAVES_METADATA_FILENAME="all_saves"
const SAVES_METADATA_FULL_NAME = SAVES_METADATA_FILENAME+".tres"

# Game manager
var game_manager_singleton : GameManager

# Dialogue
var balloon_scene_path = "res://Scenes/UI/Dialogue.tscn"

var is_in_dialogue = false
var char_name = "HAHAHA"



signal toggle_game_paused(is_paused: bool)



# UNUSED FOR NOW
func _ready():
	pass # Replace with function body.
func _process(delta):
	pass
	
