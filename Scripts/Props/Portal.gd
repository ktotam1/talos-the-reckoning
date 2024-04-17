extends Area2D
signal portal_entered
@export var next_scene = "campsite"
@export var face_left = true;
@onready var portal = $AnimatedSprite2D
@export var leaving_scene=true
# Called when the node enters the scene tree for the first time.
func _ready():
	if !face_left:
		portal.flip_h = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body is CharacterBody2D:
		portal_entered.emit()
		portal.play("close") # Replace with function body.


func _on_body_exited(body):
	if body is CharacterBody2D:
		portal.play("close") # Replace with function body.

	

func _on_animated_sprite_2d_animation_finished():
	if leaving_scene:
		get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")# Replace with function body.
	else:
		self.monitoring=false
