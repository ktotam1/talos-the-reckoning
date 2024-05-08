extends CharacterBody2D
@export var speed = 100
@export var gravity = 200
@export var jump_height = -125
@onready var bullet_load : PackedScene = preload("res://Scenes/Props/bullet.tscn")
@onready var pistol_bullet_marker : Marker2D = $Hand/Pivot/Pistol/PistolBulletMarker
@onready var animator1 : AnimatedSprite2D = $AnimatedSprite2D
@onready var animator2 : AnimatedSprite2D = $CyberBody
@onready var hand : Node2D = $Hand
@onready var healthbar = $ProgressBar
@onready var attack2 = $Hitbox/CollisionShape2D
@onready var attackbar = $Attack2
@onready var crosshair = load("res://Resources/UI/crosshair048.png")

var upgraded = true
var animator
var MAX_HEALTH = 8
var health = MAX_HEALTH
var dying = false
var elapsed_death = 0.0

var attack2ing = false
var attack2_elapsed = 0.0
var attack2_total = .2
var attack2_recharge_time = 15
var recharging = false
var recharge_elapsed = attack2_recharge_time

@export var knockback_strength = 18
var knockback = Vector2(0,0)
var charging_jump = false
var jump_held = Time.get_ticks_msec()
var did_double_jump = false
func input_movement():
	var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = horizontal_input * speed + knockback.x * knockback_strength
	if is_on_floor():
		did_double_jump = false
	else: 
		charging_jump = false
	if (Input.is_action_just_pressed("ui_jump") or Input.get_action_strength("ui_jump") > 0) and is_on_floor() and !charging_jump:
		jump_held = Time.get_ticks_msec()
		charging_jump = true
	if Input.is_action_just_released("ui_jump") and is_on_floor() and charging_jump:
		velocity.y = max(-175, (jump_held-Time.get_ticks_msec())/3-50)
		charging_jump = false
	if Input.is_action_just_pressed("ui_jump") and !is_on_floor() and !did_double_jump:
		velocity.y = jump_height
		did_double_jump = true

# Called when the node enters the scene tree for the first time.
func _ready():
	attackbar.visible = upgraded
	if upgraded:
		animator = animator2
	else:
		animator = animator1
	healthbar.max_value = MAX_HEALTH
	healthbar.value = health
	Input.set_custom_mouse_cursor(crosshair)#,Input.CURSOR_ARROW, Vector2(16,16))

func _process(delta):
	attackbar.value = recharge_elapsed / attack2_recharge_time
	if attack2ing:
		attack2_elapsed += delta
	if recharging:
		recharge_elapsed += delta
	if recharge_elapsed > attack2_recharge_time:
		recharging = false
		recharge_elapsed = attack2_recharge_time
	if attack2_elapsed > attack2_total:
		attack2ing = false
		attack2_elapsed = 0
		attack2.get_shape().set_size(Vector2(1,1))

func shoot():
	#bullets_amount -= 1
	#EventManager.bullets_amount -= 1
	#EventManager.update_bullet_ui.emit()
	var mouse_position : Vector2 = (get_global_mouse_position() - global_position).normalized()
	#var muzzle = muzzle_load.instantiate()
	var bullet = bullet_load.instantiate()
	#pistol_bullet_marker.add_child(muzzle)
	bullet.global_position = pistol_bullet_marker.global_position
	bullet.target_vector = mouse_position
	bullet.rotation = mouse_position.angle()
	get_tree().current_scene.add_child(bullet)
	#AudioManager.play_sound(AudioManager.SHOOT)
	
func ability():
	attack2.get_shape().set_size(Vector2(250,100))
	attack2ing = true
func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()
	if upgraded and event.is_action_pressed("shoot2") and !recharging:
		ability()
		recharging = true
		recharge_elapsed = 0
	
func animate(input_vector):
	var mouse_position : Vector2 = (get_global_mouse_position() - global_position).normalized()
	if mouse_position.x > 0 and animator.flip_h:
		animator.flip_h = false
	elif mouse_position.x < 0 and not animator.flip_h:
		animator.flip_h = true
	
	hand.rotation = mouse_position.angle()
	if hand.scale.y == 1 and mouse_position.x < 0:
		hand.scale.y = -1
	elif hand.scale.y == -1 and mouse_position.x > 0:
		hand.scale.y = 1
	
	if is_on_floor():
		if input_vector != 0:
			animator.play("walking")
		else:
			animator.play("idle")
	else:
		if velocity.y > 0:
			animator.play("fall")
	if charging_jump:
		animator.play("jumping")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if elapsed_death > 1:
		Globals.game_manager_singleton.set_current_level("res://Scenes/Levels/campsite.tscn")# Replace with function body.
		return
	if health <= 0:
		dying = true
	if dying:
		animator.rotate(-0.025)
		animator.translate(Vector2(-.4,.1))
		elapsed_death += delta
		return
	velocity.y = min(velocity.y + gravity * delta, 200)
	input_movement()
	#player_animations()
	var input_vector = Input.get_axis("ui_left","ui_right")
	animate(input_vector)

	velocity += knockback * knockback_strength
	knockback = lerp(knockback, Vector2.ZERO, 0.1)
	

	move_and_slide() 



func _on_border_body_entered(body):
	pass # Replace with function body.


func _on_hurtbox_area_entered(area):
	health -= 1
	healthbar.value = health
	knockback = global_position - area.global_position
	knockback.y = -.8
	knockback.x = sign(knockback.x)*40
	print(knockback * knockback_strength)
