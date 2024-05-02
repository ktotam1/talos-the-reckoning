extends CharacterBody2D

@onready var player = get_node("../Player")
@onready var animator = $AnimatedSprite2D
@onready var healthbar = $ProgressBar
@onready var col1 = $CollisionShape2D
@onready var col2 = $Area2D/CollisionShape2D
@onready var col3 = $Hitbox/CollisionShape2D
var physics_ready = false
var MAX_HEALTH = 60
var health = MAX_HEALTH
var dying = false
var elapsed_death = 0.0
var charging = false
var charge_timer = 0.0
var charge_time = 3.5
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
	if abs(x-global_position.x) > 170:
		return
	if charge_timer > charge_time:
		charging = false
		charge_timer = 0.0
	elif abs(x - global_position.x) > 120:
		charging = true
	if charging:
		charge_timer += delta
	if x < global_position.x:
		animator.flip_h = true
		col1.scale.x = -1
		col2.scale.x = -1
		col3.scale.x = -1
		if !charging:
			rotation = 0
			velocity.x = -70
		else:
			rotation = 1
			velocity.x = -120
	else: 
		animator.flip_h = false
		col1.scale.x = 1
		col2.scale.x = 1
		col3.scale.x = 1
		if !charging:
			rotation = 0
			velocity.x = 70
		else:
			rotation = -1
			velocity.x = 120
		
	velocity.y += 200 * delta
	move_and_slide()



func _on_area_2d_area_entered(area):
	var dmg = 1
	if area.is_in_group("attack2"):
		dmg = int(MAX_HEALTH / 6)

	health -= dmg
	healthbar.value = health  # Replace with function body.
