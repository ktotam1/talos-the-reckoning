extends Resource
class_name SaveMetadata

@export var all_games_metadata : Array[SaveInfoItem] = []

func sort_by_last_savedate_ascending(a:SaveInfoItem,b:SaveInfoItem):
	return a.last_accessed < b.last_accessed

func add_and_sort(new_save:SaveInfoItem):
	all_games_metadata.append(new_save)
	all_games_metadata.sort_custom(sort_by_last_savedate_ascending)
	
