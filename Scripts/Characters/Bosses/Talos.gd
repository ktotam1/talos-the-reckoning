extends CharacterBody2D

enum {IDLE, DYING, ARM_SHOT, CHEST_SHOT, ELECTRIC, SHIELD_UP, DEAD}
var gravity = 160

@onready var healthbar = $Health
@onready var shieldbar = $Shield
@onready var player = get_node("../Player")
@onready var animator = $BodyAnimator
@onready var physicsbox = $PhysicsBox
@onready var hurtbox = $Area2D/HurtBox
@onready var enemy_load = preload("res://Scenes/Characters/Enemies/Basic_Enemy.tscn")
@onready var bullet_load : PackedScene = preload("res://Scenes/Props/bullet_talos.tscn")
@onready var pistol_bullet_marker : Marker2D = $PistolBulletMarker
@onready var idleTimer = $IdleTimer
@export var MAX_HEALTH = 200
var health = MAX_HEALTH
@export var MAX_SHIELD = 40
var shield = 0
var state = IDLE

var spawn_guy = 0
@export var bullets_to_spawn_guy = 21

@export var time_to_shoot_again = 1.7
var wait_time = 0.0

@export var shield_up_radius = 145

func _ready():
	healthbar.max_value = MAX_HEALTH
	shieldbar.max_value = MAX_SHIELD
	healthbar.value = health
	shieldbar.value = shield
	pass

func set_state():
	if state != IDLE:
		return state
	if abs(player.global_position.x - global_position.x) > shield_up_radius and shield == 0:
		return SHIELD_UP
	if spawn_guy > bullets_to_spawn_guy:
		spawn_guy = 0
		return CHEST_SHOT
	if wait_time > time_to_shoot_again:
		wait_time = 0
		return ARM_SHOT
	return IDLE

func _process(delta):
	if state == DYING or state == DEAD:
		return
	if health <= 0:
		state = DYING
		animator.play("die")
	wait_time += delta

	state = set_state()
	match state:
		IDLE:
			animator.play("idle")
		ARM_SHOT:
			animator.play("arm_cannon")
		SHIELD_UP:
			animator.play("shield_up")
		CHEST_SHOT:
			animator.play("chest_cannon")

func _physics_process(delta):
	if state == DEAD or state == DYING:
		return
	if shield > 0: 
		shieldbar.z_index = 1
	else:
		shieldbar.z_index = -1
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if player != null and physicsbox != null and animator != null and hurtbox != null:
		if player.global_position.x < global_position.x:
			animator.flip_h = true
			physicsbox.scale.x =-1
			hurtbox.scale.x = -1
			pistol_bullet_marker.position.x = 15
		else: 
			animator.flip_h = false
			physicsbox.scale.x =1
			hurtbox.scale.x = 1
			pistol_bullet_marker.position.x = -15
	
	move_and_slide()


func damage(area):
	if area.is_in_group("attack2"):
		shield = 0
	if shield > 0:
		shield -= 1
	else:
		health -= 1
	healthbar.value = health
	shieldbar.value = shield	

func _on_area_2d_area_entered(area):
	damage(area) # Replace with function body.


func _on_body_animator_animation_finished():
	if animator.get_animation() == "die":
		state = DEAD
		self.z_index=0
		physicsbox.disabled=true # Replace with function body.
	if animator.get_animation() == "shield_up":
		shield = MAX_SHIELD
		shieldbar.value = shield
		state = IDLE
	if animator.get_animation() == "chest_cannon":
		state = IDLE
	if animator.get_animation() == "arm_cannon":
		state = IDLE


func shoot(fromChest):
	if player != null:
		if !fromChest:
			var mouse_position : Vector2 = (player.global_position-pistol_bullet_marker.global_position).normalized()
			var bullet = bullet_load.instantiate()
			bullet.global_position = pistol_bullet_marker.global_position
			bullet.target_vector = mouse_position
			bullet.rotation = mouse_position.angle()
			get_tree().current_scene.add_child(bullet)
		else:
			var mouse_position : Vector2 = (player.global_position-global_position).normalized()
			var bullet = bullet_load.instantiate()
			bullet.global_position = global_position
			bullet.target_vector = mouse_position
			bullet.rotation = mouse_position.angle()
			Globals.game_manager_singleton.get_current_level_scene().add_child(bullet)
			var enemy = enemy_load.instantiate()
			enemy.global_position = global_position
			Globals.game_manager_singleton.get_current_level_scene().find_child("Enemies").add_child(enemy)
func _on_body_animator_frame_changed():
	if animator.get_animation() == "arm_cannon" and 1 <= animator.get_frame() and animator.get_frame() <= 3:
		shoot(false)
		spawn_guy+=1
	if animator.get_animation() == "chest_cannon" and animator.get_frame() == 3:
		shoot(true)

