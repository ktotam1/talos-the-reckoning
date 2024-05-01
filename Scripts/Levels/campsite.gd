extends Node

@onready var chest: AnimatedSprite2D = $Chest/AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	chest.play("closed") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		chest.play("opening")

func _on_area_2d_body_exited(body):
	chest.play("closing")


func _on_animated_sprite_2d_animation_finished(anim_name):
	if anim_name == "closing":
		chest.play("closed") # Replace with function body.
	if anim_name == "opening":
		chest.play("opened")

