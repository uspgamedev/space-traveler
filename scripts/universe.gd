
extends Node

var frames = 0
var player
var planets = [
["p1", 100, 100, 0],
["p2",500,500, 0]
]

func _init():
	set_process_input(true)
	set_process(true)
	var playerScene = load("res://scenes/Player.scn")
	player = playerScene.instance()
	add_child(player)
	var name
	for planet in planets :
		var p
		var planetScene = load("res://scenes/planets/"+planet[0]+".xscn")
		p = planetScene.instance()
		planet.append(p)
		add_child(p)
		if (isInRange(Vector2(0, 0), Vector2(planet[1], planet[2]))) :
			planet[3] = 1
		else :
			planet[3] = 0
			planet[4].set_hidden (true)

func _process(delta):
	frames += 1
	if (frames%10) :
		player.Rotate((get_viewport().get_mouse_pos()-get_viewport().get_rect().size/2))
		checkPlanets()
		if (frames > 1000): 
			frames = 0

func checkPlanets ():
	for planet in planets :
		if (isInRange(player.get_pos(), Vector2(planet[1], planet[2]))) :
			if (planet[3] == 0):
				print ("criou"+planet[0])
				print (planet[3])
				planet[3] = 1
				planet[4].set_hidden(false)
		elif (planet[3] == 1) :
			print ("matou"+planet[0])
			print (planet[3])
			planet[3] = 0
			planet[4].set_hidden (true)

func _input(ev):
	if (ev.type==InputEvent.MOUSE_BUTTON):
		print("Mouse Click/Unclick at: ",ev.pos)
		if (ev.button_mask == 0 and ev.button_index == 2):
			player.moveTo(ev.pos - get_viewport().get_rect().size/2 + player.get_pos())
		if (ev.button_mask == 0 and ev.button_index == 1):
			var bulletScene = load("res://scenes/bullets/Bullet.scn")
			var bullet = bulletScene.instance()
			bullet.setPosition(player.get_pos(), ev.pos - get_viewport().get_rect().size/2)
			add_child(bullet)
			player.bar.takeDamage(50)

func isInRange (playerPos, planetPos):
	if ((planetPos - playerPos).length() < 400):
		return 1
	return 0

func _ready():
	pass
