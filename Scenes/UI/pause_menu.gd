extends Control

signal save_button_pressed

func _ready():
	if !get_parent().is_in_group("GAME_MANAGER_DO_NOT_ADD"):
		push_error("Pause Menu not instantiated in a Game Manager, things will not work as expected")
	hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_save_button_pressed():
	save_button_pressed.emit()

func game_manager_requested_pause(is_paused: bool):
	if is_paused:
		show()
	else:
		hide()
