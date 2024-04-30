extends CharacterBody2D

@onready var player = get_node("../Player")
@onready var animator = $AnimatedSprite2D
@onready var healthbar = $ProgressBar
var physics_ready = false
var MAX_HEALTH = 60
var health = MAX_HEALTH
var dying = false
var elapsed_death = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	healthbar.max_value = MAX_HEALTH
	healthbar.value = health
	animator.play("idle")#Replace with function body.
	physics_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if elapsed_death > 1:
		self.queue_free()
		return
	if health <= 0:
		dying = true
	if dying:
		animator.rotate(-0.025)
		animator.translate(Vector2(-.4,.1))
		elapsed_death += delta
		return
	if !physics_ready:
		return
	var x = player.global_position.x
	if abs(x-global_position.x) > 160:
		return
	if x < global_position.x:
		animator.flip_h = true
		velocity.x = -50
	else: 
		animator.flip_h = false
		velocity.x = 50
		
	velocity.y += 200 * delta
	move_and_slide()



func _on_area_2d_area_entered(area):
	health -= 1
	healthbar.value = health  # Replace with function body.
