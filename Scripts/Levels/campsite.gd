extends Node

@onready var forest_border: RigidBody2D = $Trees/Border
@onready var forest_text: RichTextLabel = $Trees/PathBlockedMessage

# Called when the node enters the scene tree for the first time.
func _ready():

	forest_text.visible = false # Replace with function bod # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
