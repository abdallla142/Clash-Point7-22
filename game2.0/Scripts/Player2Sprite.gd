extends Sprite2D

@onready var animationplayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func playanimation(thisani: String):
	if not animationplayer.is_playing():
		animationplayer.play(thisani)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
