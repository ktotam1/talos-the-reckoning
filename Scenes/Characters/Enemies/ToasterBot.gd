extends CharacterBody2D

enum {IDLE, ATTACKING, DYING}

@onready var player = get_node("../../Player")
@onready var animator = $AnimatedSprite2D
@onready var healthbar = $ProgressBar
@onready var hitbox = $Hitbox/CollisionShape2D

var state = IDLE
var MAX_HEALTH = 5
var health = MAX_HEALTH
var elapsed_death = 0.0
var SPEED = 80
# Called when the node enters the scene tree for the first time.
func _ready():
	healthbar.max_value = MAX_HEALTH
	healthbar.value = health
	animator.play("idle")#Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if state == DYING:
		animator.play("die")
		return
	if health <= 0:
		state = DYING
		animator.play("idle")
		return
		#self.queue_free()
	var x = player.global_position.x
	
	if state != ATTACKING:
		if abs(x - global_position.x) > 125:
			state=IDLE 
		else:
			state=ATTACKING

	match state:
		IDLE:
			animator.play("idle")
		ATTACKING:
			animator.play("attack")
	move_and_slide()


func _on_animated_sprite_2d_animation_finished():
	if animator.get_animation() == "die":
		self.queue_free()
	elif state != DYING:
		state = IDLE # Replace with function body.


func _on_area_2d_area_entered(area):
	health -= 1
	healthbar.value = health # Replace with function body.


func _on_animated_sprite_2d_frame_changed():
	if animator != null:
		if animator.get_animation() == "attack":
			match animator.get_frame():
				0:
					self.hitbox.get_shape().set_size(Vector2(20,12))
					self.hitbox.position.x = 1
				1:
					self.hitbox.get_shape().set_size(Vector2(28,12))
					self.hitbox.position.x = 4.0
				2: 
					self.hitbox.get_shape().set_size(Vector2(30,12))
					self.hitbox.position.x = 5
				3: 
					self.hitbox.get_shape().set_size(Vector2(30,12))
					self.hitbox.position.x = 5
				4: 
					self.hitbox.get_shape().set_size(Vector2(23,12))
					self.hitbox.position.x = 2
				5: 
					self.hitbox.get_shape().set_size(Vector2(96,12))
					self.hitbox.position.x = 38
				6: 
					self.hitbox.get_shape().set_size(Vector2(96,12))
					self.hitbox.position.x = 38
				7:
					self.hitbox.get_shape().set_size(Vector2(96,12))
					self.hitbox.position.x = 38
				8: 
					self.hitbox.get_shape().set_size(Vector2(96,12))
					self.hitbox.position.x = 38
				9: 
					self.hitbox.get_shape().set_size(Vector2(96,12))
					self.hitbox.position.x = 38
				10: 
					self.hitbox.get_shape().set_size(Vector2(96,12))
					self.hitbox.position.x = 38
				11: 
					self.hitbox.get_shape().set_size(Vector2(96,12))
					self.hitbox.position.x = 38
				12: 
					self.hitbox.get_shape().set_size(Vector2(20,12))
					self.hitbox.position.x = 1
		else: 
			self.hitbox.get_shape().set_size(Vector2(1,12))
				
