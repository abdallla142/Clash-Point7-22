extends Control

var timertime
var P1Hp: float = 100
var P2Hp: float = 100
var P1HPDisp: float = 0
var P2HPDisp: float = 0 

signal Player1Wins
signal Player2Wins

# Called when the node enters the scene tree for the first time.
func _ready():
	$p1bar.value = 100
	$p2bar.value = 100 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$p1bar.value = lerp(P1HPDisp,P1Hp,0.2)
	
	$p2bar.value = lerp(P2HPDisp,P2Hp,0.2)

	P1HPDisp = $p1bar.value 
	P2HPDisp = $p2bar.value
	
	timertime = $Timer.time_left
	$Label.text = str(round(timertime))



func _on_p_1_bar_value_changed(value):
	if value < 1:
		Player1Wins.emit() # Replace with function body.


func _on_p_2_bar_value_changed(value):
	if value < 1:
		Player2Wins.emit() # Replace with function body.
