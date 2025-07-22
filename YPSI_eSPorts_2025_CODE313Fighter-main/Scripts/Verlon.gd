extends CharacterBody2D

@onready var Base = $CharacterBase
@onready var animation = $AnimationPlayer
@onready var timer = $Timer


var AttackArray = []
var InputArray = []

func get_key_axis(one,two) -> int:
	if Input.is_key_pressed(one):
		return 1
	if Input.is_key_pressed(two):
		return -1
	return 0


func _physics_process(delta):
	var direction = get_key_axis(Base.FWD,Base.BWD)
	
	if direction:
		velocity.x = direction * Base.ForwardSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, Base.ForwardSpeed)
		
	move_and_slide()


func _on_character_base_emiting_input(inputString):
	var attackreqs = timer.is_stopped() and !animation.is_playing()
	var comboReqs = AttackArray.size() > 0 and !timer.is_stopped() and !animation.is_playing()
	
	InputArray.append(inputString)
	
	match inputString:
		"H":
			if attackreqs:
				animation.play(inputString)
				AttackArray.append(inputString)
				print(AttackArray)
				timer.wait_time = 0.51
				timer.start()
			#Combo 1
			if comboReqs:
				animation.play("H_2")
				AttackArray.append("H_2")
				print(AttackArray)
			


func _on_timer_timeout():
	AttackArray.clear()
	InputArray.clear()
	print("comboOver")
