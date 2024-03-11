extends Resource
class_name SaveInfoItem


@export var save_name: String = "default_save_name"
@export var last_accessed : int = 0

func load_game(parent_path=Globals.SAVES_DIR_NAME)->GameState:
	var save_path=parent_path+save_name+".tres"
	if not FileAccess.file_exists(save_path):
		push_error("Save filename for save "+save_name+" doesn't exist...")
	return ResourceLoader.load(save_path,"GameState")
	
