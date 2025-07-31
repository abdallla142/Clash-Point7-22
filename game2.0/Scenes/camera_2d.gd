extends Camera2D

var targets

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	targets = get_parent().get_node("CharacterHolder").get_children()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pos1 = targets[0].position
	var pos2 = targets[1].position
	
	var direction: Vector2 = (pos2 + pos1) * 0.5
	
	position = lerp(position,(direction),0.5)
	
	var zoommag: float = ((pos1.x - pos2.x)/50) - 12
	var actualzoommag: float = min(abs(zoommag),2.0)
	
	print("old", zoommag)
	if zoommag > -1:
		zoommag = -1
	
	if zoommag < -2:
		zoommag = -2
	
	print("new", zoommag)
	zoom = lerp(zoom,Vector2(abs(zoommag),abs(zoommag)), 2 * delta)
	
