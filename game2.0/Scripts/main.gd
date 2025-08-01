extends Node2D
@onready var player1 = $p1
@onready var player2 = $CharacterBody2D
@onready var CharHolder = $CharacterHolder
@onready var GUI = $CanvasLayer/GUI
@onready var Win_Animation = $CanvasLayer/Label/AnimationPlayer
@onready var Win_text = $CanvasLayer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	player1 = CharHolder.get_children()[0]
	player2 = CharHolder.get_children()[1]
	
	Win_text.hide()
	
	var children = get_children()
	
	player1.damaged.connect(updateGUI)
	player2.damaged.connect(updateGUI)

func _process(delta):
	pass

func updateGUI(dmg: int, p: Node):
	print(p.name)
	if p.name == "p1":
		GUI.P1Hp -= 10
	else:
		GUI.P2Hp -= 10


func _on_control_player_1_wins():
	Win_text.text =  " player 1 wins"
	GameValues.thisMS.player1round += 1
	#print("player one round won:",GameValues.thisMS.player1round)
	reload_scene()
	

func reload_scene():
	Win_Animation.play("Player has won")
	
	await Win_Animation.animation_finished
	print("plING")
	# Get the current scene's file pathh
	var current_scene = "res://Scenes/main.tscn"
	# Reload the jjdjjscen
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_gui_player_2_wins() -> void:	
	Win_text.text =  " Player 2 Wins"
	GameValues.thisMS.player2round += 1
	#print("player two round won:",GameValues.thisMS.player2round)
	reload_scene()
