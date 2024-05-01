extends Container

signal dialogue_ended(_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func dialogue_finito(scene_name):
	emit_signal("dialogue_ended",scene_name)
