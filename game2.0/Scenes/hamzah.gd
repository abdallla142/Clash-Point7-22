extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = 400.0
const maxHP = 300
var AttackName

signal damaged(amount, thisplayer)

@onready var pkeys = [KEY_1, KEY_2, KEY_3, KEY_4]

@export var LeftMove = KEY_A
@export var RightMove = KEY_D
@export var JumpUp = KEY_W

@export var light_attack = KEY_1
@export var special = KEY_2
@export var attack1 = KEY_3
@export var attack2 = KEY_4

@onready var pTimer = $Timer
@onready var player = $PLayer
@export var FlipX = true
@onready var spriteAni = $PLayer/AnimationPlayer

@onready var rTransform = $RemoteTransform2D

enum aniState {
	ATTACKING,
	IDLE,
	DAMAGED
}

var thisState = aniState.IDLE

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	rTransform.scale.x = boolNegPosReturn(!FlipX)
	player.flip_h = FlipX
	pkeys = [special, light_attack, attack1, attack2]

func animationProgressCheck(percentage) -> bool:
	return spriteAni.current_animation_position > (spriteAni.current_animation_length * percentage)

func Special():
	if pTimer.is_stopped():
		AttackName = "special"
		spriteAni.play("special")
		pTimer.one_shot = true
		pTimer.wait_time = 0.6
		pTimer.start()
		


	if animationProgressCheck(0.8) and !pTimer.is_stopped():
		AttackName = "Follow Up Kick"
		spriteAni.stop()
		spriteAni.play("lighting")
func Light_Attack():
	if !spriteAni.is_playing():
		spriteAni.play("light_attack")
func Attack1():
	if !spriteAni.is_playing():
		spriteAni.play("attack1")
func Attack2():
	if !spriteAni.is_playing():
		spriteAni.play("attack2")

func KeyGetAxis(key1, key2) -> int:
	if Input.is_key_label_pressed(key1):
		return 1
	if Input.is_key_label_pressed(key2):
		return -1
	return 0

func boolNegPosReturn(boolean) -> int:
	return 1 if boolean else -1

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# Horizontal movement
	var direction = KeyGetAxis(RightMove, LeftMove)
	if direction:
		velocity.x = direction * SPEED
		spriteAni.play("walking")
	else:
		velocity.x = move_toward(velocity.x, 0, 25)

	# Jump
	if Input.is_key_label_pressed(JumpUp) and is_on_floor():
		velocity.y = -JUMP_VELOCITY

	move_and_slide()

func stateDecider():
	if spriteAni.current_animation.contains("Attack"):
		thisState = aniState.ATTACKING
	elif spriteAni.current_animation.contains("Stun"):
		thisState = aniState.DAMAGED
	else:
		thisState = aniState.IDLE

func _process(delta):
	if is_multiplayer_authority():
		if Input.is_key_label_pressed(pkeys[0]):
			Special()
		if Input.is_key_label_pressed(pkeys[1]):
			Light_Attack()
		if Input.is_key_label_pressed(pkeys[2]):
			Attack1()
		if Input.is_key_label_pressed(pkeys[3]):
			Attack2()
			

		stateDecider()
		rpc("remote_set_position", position)

@rpc("unreliable") func remote_set_position(authority_position):
	global_position = authority_position

func _on_hit_area_2d_area_entered(area):
	var attacker = area.get_owner()

	if area.name == "HurtArea2D" and attacker != self:
		spriteAni.play("hit")
		velocity.x += 500 if FlipX else -500
		damaged.emit(30, self)
		print("I'm being hit by another character!")
