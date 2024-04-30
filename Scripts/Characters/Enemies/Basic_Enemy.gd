extends CharacterBody2D

enum {IDLE, WALKING, ATTACKING, DYING}

@onready var player = get_node("../../Player")
@onready var animator = $AnimatedSprite2D
@onready var healthbar = $ProgressBar
@onready var hitbox = $Hitbox/CollisionShape2D

var state = IDLE
var MAX_HEALTH = 30
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
	if elapsed_death > 1:
		self.queue_free()
		return
	if state == DYING:
		animator.rotate(-0.025)
		animator.translate(Vector2(-.4,.1))
		elapsed_death += delta
		return
	if health <= 0:
		state = DYING
		animator.play("idle")
		return
		#self.queue_free()
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
				velocity.x = -SPEED
			else: 
				animator.flip_h = false
				velocity.x = SPEED
		ATTACKING:
				animator.play("attack")
				velocity.x = 0
	velocity.y += 200 * delta
	move_and_slide()


func _on_animated_sprite_2d_animation_finished():
	if state != DYING:
		state = IDLE # Replace with function body.


func _on_area_2d_area_entered(area):
	health -= 1
	healthbar.value = health # Replace with function body.


func _on_animated_sprite_2d_frame_changed():
	if animator != null:
		if animator.get_animation() == "attack":
			match animator.get_frame():
				0:
					self.hitbox.get_shape().set_size(Vector2(1,17))
				1:
					self.hitbox.get_shape().set_size(Vector2(1,17))
				2: 
					self.hitbox.get_shape().set_size(Vector2(1,17))
				3: 
					self.hitbox.get_shape().set_size(Vector2(44,8))
				4: 
					self.hitbox.get_shape().set_size(Vector2(44,12))
				5: 
					self.hitbox.get_shape().set_size(Vector2(50,15))
				6: 
					self.hitbox.get_shape().set_size(Vector2(55,15))
				7:
					self.hitbox.get_shape().set_size(Vector2(80,17))
				8: 
					self.hitbox.get_shape().set_size(Vector2(80,17))
				9: 
					self.hitbox.get_shape().set_size(Vector2(1,17))
				10: 
					self.hitbox.get_shape().set_size(Vector2(80,17))
				11: 
					self.hitbox.get_shape().set_size(Vector2(1,17))
				12: 
					self.hitbox.get_shape().set_size(Vector2(1,17))
		else: 
			self.hitbox.get_shape().set_size(Vector2(1,17))
				
