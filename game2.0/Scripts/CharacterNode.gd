extends CharacterBody2D

const SPEED = 300.0
@export var JUMP_VELOCITY = 400.0
const maxHP = 300
var AttackName

signal damaged(amount, thisplayer)

@onready var pkeys = [KEY_H, KEY_J, KEY_K, KEY_L]

@export var LeftMove = KEY_UP
@export var RightMove = KEY_D
@export var JumpUp = KEY_W

@export var light_attack = KEY_H
@export var special = KEY_J
@export var attack1 = KEY_K
@export var attack2 = KEY_L

@onready var pivot = $Pivot
@onready var pTimer = $Pivot/Timer
@onready var player = $PLayer
@onready var spriteAni = $PLayer/AnimationPlayer
@onready var rTransform = $RemoteTransform2D
@onready var hitbox = $Pivot/HitArea2D
@onready var hurtbox = $Pivot/HurtArea2D
@onready var body_shape = $CollisionShape2D   # Main movement collision shape

var is_attacking = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var ExplosionScene = preload("res://Scenes/explosion.tscn")
var FireScene = preload("res://Scenes/fire.tscn")

enum aniState { ATTACKING, IDLE, DAMAGED }
var thisState = aniState.IDLE

func _ready():
	pkeys = [special, light_attack, attack1, attack2]
	spriteAni.connect("animation_finished", Callable(self, "_on_animation_finished"))
	face_right()

# ---- FLIPPING ----
func face_right():
	pivot.scale.x = 1
	body_shape.position.x = abs(body_shape.position.x) # Keep physics shape aligned right

func face_left():
	pivot.scale.x = -1
	body_shape.position.x = -abs(body_shape.position.x) # Keep physics shape aligned left

# ---- ATTACKS ----
func Special():
	if pTimer.is_stopped() and !is_attacking:
		is_attacking = true
		AttackName = "special"
		spriteAni.play("special")
		pTimer.one_shot = true
		pTimer.wait_time = 0.6
		pTimer.start()

func Light_Attack():
	if !is_attacking:
		is_attacking = true
		spriteAni.play("light_attack")

func Attack1():
	if !is_attacking:
		is_attacking = true
		spriteAni.play("attack1")

func Attack2():
	if !is_attacking:
		is_attacking = true
		spriteAni.play("attack2")

# ---- INPUT AXIS ----
func KeyGetAxis(key1, key2) -> int:
	var result = 0
	if Input.is_key_label_pressed(key1):
		face_right()
		result = 1
	elif Input.is_key_label_pressed(key2):
		face_left()
		result = -1
	return result

func play_idle_pose():
	spriteAni.play("walking")
	spriteAni.seek(0, true)

# ---- MOVEMENT ----
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	var direction = KeyGetAxis(RightMove, LeftMove)

	if direction != 0:
		velocity.x = direction * SPEED
		if !is_attacking and spriteAni.current_animation != "walking":
			spriteAni.play("walking")
	else:
		velocity.x = move_toward(velocity.x, 0, 25)
		if !is_attacking:
			play_idle_pose()

	if Input.is_key_label_pressed(JumpUp) and is_on_floor():
		velocity.y = -JUMP_VELOCITY

	move_and_slide()

# ---- STATE ----
func stateDecider():
	if spriteAni.current_animation in ["light_attack", "attack1", "attack2", "special", "lighting"]:
		thisState = aniState.ATTACKING
	elif spriteAni.current_animation == "hit":
		thisState = aniState.DAMAGED
	else:
		thisState = aniState.IDLE

# ---- PROCESS ----
func _process(delta):
	if is_multiplayer_authority():
		if Input.is_key_label_pressed(pkeys[0]):
			Special()
		elif Input.is_key_label_pressed(pkeys[1]):
			Light_Attack()
		elif Input.is_key_label_pressed(pkeys[2]):
			Attack1()
		elif Input.is_key_label_pressed(pkeys[3]):
			Attack2()

		stateDecider()
		rpc("remote_set_position", position)

@rpc("unreliable")
func remote_set_position(authority_position):
	global_position = authority_position

# ---- HIT DETECTION ----
func _on_hit_area_2d_area_entered(area):
	var attacker = area.get_owner()

	if area.name == "HurtArea2D" and attacker != self:
		spriteAni.play("hit")
		velocity.x += 500 if pivot.scale.x == 1 else -500
		is_attacking = false
		damaged.emit(30, self)
		print("I'm being hit by another character!")

		if attacker.AttackName == "special":
			var fire = FireScene.instantiate()
			fire.position = global_position
			get_parent().add_child(fire)
			fire.call_deferred("set_lifetime", 2.0)
		else:
			var explosion = ExplosionScene.instantiate()
			explosion.position = global_position
			get_parent().add_child(explosion)
			explosion.call_deferred("set_lifetime", 2.0)

# ---- ANIMATION FINISHED ----
func _on_animation_finished(anim_name):
	if anim_name in ["light_attack", "attack1", "attack2", "special", "lighting", "hit"]:
		is_attacking = false
		var direction = KeyGetAxis(RightMove, LeftMove)
		if direction == 0:
			play_idle_pose()
