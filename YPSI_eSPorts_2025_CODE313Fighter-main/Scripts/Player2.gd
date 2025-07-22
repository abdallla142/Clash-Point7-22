extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	$CollisionShape2D.position = $Sprite2D.position
	# Light Attack
	if Input.is_key_pressed(KEY_Q):
		$Sprite2D.playanimation("LightAttack")
		
	# Heavy Attack
	if Input.is_key_pressed(KEY_W):
		if $Timer.is_stopped:
			Timer
			$Timer.one_shot = true
			$Timer.wait_time = 7
			$Timer.start()
			
			print($Timer.wait_time)
			$Sprite2D.playanimation("HeavyAttack")
		else: 
			print("special move attempt")
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("P2_Right", "P2_Left")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
