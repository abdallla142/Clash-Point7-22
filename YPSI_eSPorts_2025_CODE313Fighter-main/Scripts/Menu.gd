extends Control


var multiplayer_peer = ENetMultiplayerPeer.new()

const PORT = 7800
const ADDRESS = "127.0.0.1"

var connectedpeerIds = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	# Get the current scene's file path
	var maingame = "res://Scenes/main.tscn"
	# Reload the scene
	get_tree().change_scene_to_file(maingame) # Replace with function body.

func _on_host_pressed():
	$Host.hide()
	$Join.hide()
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	
	addplayer(1)
	
	multiplayer_peer.peer_connected.connect(
		func(new_peer_id):
			get_tree().create_timer(1).timeout
			rpc("addnewcharacter", new_peer_id)
			rpc_id(new_peer_id, "addprevconnectedcharacter", connectedpeerIds)
			
			addplayer(new_peer_id)
	)

func _on_join_pressed():
	$Host.hide()
	$Join.hide()
	multiplayer_peer.create_client(ADDRESS,PORT)
	multiplayer.multiplayer_peer = multiplayer_peer

func addplayer(peer_id):
	connectedpeerIds.append(peer_id)
	
	var charNode = load("res://CharacterNode.tscn").instantiate()
	charNode.set_multiplayer_authority(peer_id)
	add_child(charNode)
	
	charNode.position = Vector2(400,200)

@rpc func addnewcharacter(new_peer_id):
	addplayer(new_peer_id)

@rpc func addprevconnectedcharacter(peer_ids):
	for peer_id in peer_ids:
		addplayer(peer_id)
