extends Control

var all_saves = SaveMetadata.new();

@onready var rects = $rectangles

# Called when the node enters the scene tree for the first time.
func _ready():
	# Hide all submenus
	$"Sub Options".visible=false;
	
	# Load saves
	__load_saves();
	
	
func __load_saves():
	var dir = DirAccess.open(Globals.SAVES_FULL_DIR);
	if dir:
		all_saves = ResourceLoader.load(Globals.SAVES_FULL_DIR+Globals.SAVES_METADATA_FULL_NAME);
	else : 
		DirAccess.make_dir_absolute(Globals.SAVES_FULL_DIR);
		ResourceSaver.save(all_saves,Globals.SAVES_FULL_DIR+Globals.SAVES_METADATA_FULL_NAME);	
	# all_saves.all_games_metadata is assumed to be sorted in descending order by last accessed
	# That is, its first item is the game played the furthest in time
	# Since adding children (`add_child`) adds items at the bottom, we can simply add them linearly 	
	for save_metadata in all_saves.all_games_metadata:
		save_metadata = save_metadata as SaveInfoItem
		$"All Saves".add_child(__get_load_game_item(save_metadata))
		
	#Finally, add the "Create new game" element
	$"Sub Options/All Saves".add_child(__get_create_new_game_element())

func __get_create_new_game_element()->Button:
	var btn = Button.new()
	btn.text = "+ New Game"
	btn.pressed.connect(self._create_new_game)
	return btn

func __get_load_game_item(save_metadata:SaveInfoItem)->HBoxContainer:
	var ret = HBoxContainer.new()
	ret.pressed.connect(self._load_and_start_game.bind(Globals.SAVES_FULL_DIR+"/"+save_metadata.save_name))
	# TODO: add image
	var save_name_beautified = save_metadata.save_name.capitalize()
	var date_string = Time.get_datetime_string_from_unix_time(save_metadata.last_accessed,true)
	
	var vbox = VBoxContainer.new()
	var name_label = Label.new()
	var date_label = Label.new()
	
	name_label.text = save_name_beautified
	date_label.text = date_string
	
	vbox.add_child(name_label)
	vbox.add_spacer(false)
	vbox.add_child(date_label)
	
	ret.add_child(vbox)
	
	return ret

func _create_new_game():
	get_tree().change_scene_to_file("res://Scenes/GameManager.tscn")
	
func _load_and_start_game(save_path:String):
	pass


func _input(event):
	if event.is_action_pressed("ui_mainmenu_clear"):
		$"Sub Options".visible=false;


func _on_quit_pressed():
	get_tree().quit(0)


func _on_load_pressed():
	$"Sub Options".visible = false; #Clear current submenu
	$"Sub Options".visible = true;
	$"Sub Options/All Saves".visible = true;
	
func _process(_delta):
	var tween = rects.create_tween()
	var offset = - get_global_mouse_position() * 0.1
	tween.tween_property(rects,"position",offset,1.0)
	for rect in rects.get_children():
		var rect_tween = rects.create_tween()
		var current_color = rect.color
		rect_tween.tween_property(rect,"modulate",Color(current_color,(rect.position-get_global_mouse_position()).length()*0.005),1.0)


