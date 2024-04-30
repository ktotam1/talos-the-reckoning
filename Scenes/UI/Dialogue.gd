extends Control

var dialogue_data = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_dialogue(dialogue_txt:String):
	var file = load("res://path/to/your/text/file.txt")
	if file:
		var text = file.get_as_text()
		text = text.split("\n").map(_parse_dialogue_file)
	else:
		push_error("Failed to load file")	
		
func _parse_dialogue_file(text_line):
	var splitted = text_line.split("</C>")
	assert(splitted.size() == 2)
	var char_name = splitted[0]
	var char_text = splitted[1]
	char_text = char_text.replace("<br>","\n")
	return {char_name : char_text}	
	
	

