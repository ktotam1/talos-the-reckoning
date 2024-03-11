extends CharacterBody2D
@export var speed = 100
@export var gravity = 200
@export var jump_height = -100
@onready var bullet_load : PackedScene = preload("res://Scenes/Props/bullet.tscn")
@onready var pistol_bullet_marker : Marker2D = $Hand/Pivot/Pistol/PistolBulletMarker
@onready var animator : AnimatedSprite2D = $AnimatedSprite2D
@onready var hand : Node2D = $Hand
func horizontal_movement():
	var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = horizontal_input * speed
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
	
func _input(event):
	if event.is_action_pressed("ui_jump") and is_on_floor():
		velocity.y = jump_height
		$AnimatedSprite2D.play("jump")
	if event.is_action_pressed("shoot"):
		shoot()
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
			animator.play("Fall")
		else:
			animator.play("Jump")
func player_animations():
	#on left (add is_action_just_released so you continue running after jumping)
	if Input.is_action_pressed("ui_left"):
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("walking")
	
	#on right (add is_action_just_released so you continue running after jumping)
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("walking")
	if !Input.is_anything_pressed():
		$AnimatedSprite2D.play("idle")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += gravity * delta
	horizontal_movement()
	#player_animations()
	var input_vector = Input.get_axis("ui_left","ui_right")
	animate(input_vector)
	move_and_slide() 

