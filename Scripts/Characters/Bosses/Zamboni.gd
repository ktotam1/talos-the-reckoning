extends CharacterBody2D

@onready var player = get_node("../Player")
@onready var animator = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("idle ")#Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var x = player.global_position.x
	if x < global_position.x:
		animator.flip_h = true
		velocity.x = -50
	else: 
		animator.flip_h = false
		velocity.x = 50
		
	velocity.y += 200 * delta
	move_and_slide()
