extends CharacterBody2D

enum {IDLE, WALKING, ATTACKING}

@onready var player = get_node("../../Player")
@onready var animator = $AnimatedSprite2D
var state = IDLE
# Called when the node enters the scene tree for the first time.
func _ready():

	animator.play("idle")#Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	var x = player.global_position.x
	if x < global_position.x:
		animator.flip_h = true

	else: 
		animator.flip_h = false
	if state != ATTACKING:
		if abs(x - global_position.x) > 125:
			state=IDLE 
		elif abs(x - global_position.x)  > 30:
			state=WALKING
		else:
			state=ATTACKING

	match state:
		IDLE:
			velocity.x = 0
			animator.play("idle")
		WALKING: 
			animator.play("walk")
			if x < global_position.x:
				animator.flip_h = true
				velocity.x = -50
			else: 
				animator.flip_h = false
				velocity.x = 50
		ATTACKING:
				animator.play("attack")
				velocity.x = 0
	velocity.y += 200 * delta
	move_and_slide()


func _on_animated_sprite_2d_animation_finished():
	print("ANIMATION DONE")
	state = IDLE # Replace with function body.
