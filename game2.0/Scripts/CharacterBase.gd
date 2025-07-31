extends Node2D

signal emitingInput

@export_category("Attack Inputs")
@export var LightAttack:= KEY_0
@export var HeavyAttack:= KEY_1
@export var Special:= KEY_2


@export_category("Movement Inputs")
@export var FWD:= KEY_3
@export var BWD:= KEY_4
@export var JMP:= KEY_5
@export var CRC:= KEY_6

@export_category("Movement Speed")
@export var ForwardSpeed = 300.0
@export var BackwardSpeed = 300.0

enum CombatStates{
	ATTACKING,
	DEFENDING,
	IDLE,
	STUNNED
}

@export_category("States")
@export var FlipX:= false
@export var ThisState = CombatStates.DEFENDING

func _ready():
	pass

func setCharacterState(number: int):
	ThisState = CombatStates.find_key(number)

func _process(delta):
	#Movement
	if Input.is_key_pressed(FWD):
		emitingInput.emit("FWD")
	if Input.is_key_pressed(BWD):
		emitingInput.emit("BWD")
	if Input.is_key_pressed(JMP):
		emitingInput.emit("JMP")
	if Input.is_key_pressed(CRC):
		emitingInput.emit("CRC")
	#Fighting Inputs
	if Input.is_key_pressed(LightAttack):
		emitingInput.emit("L")
	if Input.is_key_pressed(HeavyAttack):
		emitingInput.emit("H")
	if Input.is_key_pressed(Special):
		emitingInput.emit("S")
