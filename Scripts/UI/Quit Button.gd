extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	var confirm_quit = $"Confirm Quit"
	confirm_quit.visible = false
	confirm_quit.ok_button_text = "Quit"
	confirm_quit.title = "You are about to quit the game. All unsaved progress will be lost."
	confirm_quit.connect("confirmed",_on_confirmed_accept)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	$"Confirm Quit".visible = true
	
func _on_confirmed_accept():
	get_tree().quit()
