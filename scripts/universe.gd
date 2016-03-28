
extends Node

var player

func _init():
	set_process_input(true)
	var playerScene = load("res://scenes/Player.scn")
	player = playerScene.instance()
	add_child(player)

func _input(ev):
	if (ev.type==InputEvent.MOUSE_BUTTON):
		print("Mouse Click/Unclick at: ",ev.pos)
		if (ev.button_mask == 0 and ev.button_index == 2):
			player.moveTo(ev.pos)
		if (ev.button_mask == 0 and ev.button_index == 1):
			var bulletScene = load("res://scenes/Bullet.scn")
			var bullet = bulletScene.instance()
			bullet.setPosition(player.get_pos(), ev.pos - player.get_pos())
			add_child(bullet)

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _input(ev) :
#	if (ev.type==InputEvent.MOUSE_BUTTON):
#		print("Mouse Click/Unclick at: ",ev.pos)
#		if (ev.button_mask == 0 and ev.button_index == 2) :
#			movePos0 = ev.pos - self.get_pos()
#			movePos1 = ev.pos - self.get_pos()
#		if (ev.button_mask == 0 and ev.button_index == 1) :
#			#var scene = load("res://bullet.scn")
#			#var node = scene.instance()
#			#add_child(node)
#			pass
#		print(ev.button_index)
#	elif (ev.type==InputEvent.MOUSE_MOTION):
#		pass