extends Control

@onready var characterslist = $Characters

var whichplayer = 1
var inx = 0
var movingplayertexture: TextureRect

var p1selection: String
var p2selection: String


func _input(event: InputEvent) -> void:
	var y: float
	if whichplayer == 1:
		y = 140
		movingplayertexture = $p1_indicator
	else:
		y = 100
		movingplayertexture = $p2_indicator
	
	if Input.is_action_just_pressed("ui_right"):
		inx += 1
	if Input.is_action_just_pressed("ui_left"):
		inx -= 1
	if Input.is_action_just_pressed("ui_accept"):
		if whichplayer == 1:
			p1selection = characterslist.get_children()[inx % 4].name
			whichplayer = 2
		else:
			p2selection = characterslist.get_children()[inx % 4].name
			print("p1 selects: ", p1selection, "  p2 selects: ", p2selection)
	
	var x = characterslist.get_children()[inx % 4].global_position.x + 10
	movingplayertexture.position = Vector2(x, y)



func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
