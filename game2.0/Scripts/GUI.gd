extends Control

const p1maxbarval = 100
const p2maxbarval = 100

@onready var playerbar1 = $Panel/ProgressBar
@onready var playerbar2 = $Panel/ProgressBar2

func _ready():
	playerbar1.value = p1maxbarval
	playerbar2.value = p2maxbarval 

func _process(delta):
	pass
