
extends Node

var frames = 0
var player
var planets = [
["p1", -800, -800, 0],
["p2",1000,1000, 0]
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
		planet[4].set_pos(Vector2(planet[1], planet[2]))
	checkPlanets()

func _process(delta):
	frames += 1
	if (frames%10) :
		player.Rotate((get_viewport().get_mouse_pos()-get_viewport().get_rect().size/2))
		checkPlanets()
		if (frames > 1000): 
			frames = 0

func checkPlanets ():
	var d0 = sqrt((planets[0][1] - player.get_pos().x)*(planets[0][1] - player.get_pos().x) + (planets[0][2] - player.get_pos().y)*(planets[0][2] - player.get_pos().y))
	var mim_index = 0
	for i in range(1, planets.size()):
		var d = sqrt((planets[i][1] - player.get_pos().x)*(planets[i][1] - player.get_pos().x) + (planets[i][2] - player.get_pos().y)*(planets[i][2] - player.get_pos().y))
		if d < d0 :
			d0 = d
			mim_index = i
	
	for i in range(0, planets.size()):
		if (i == mim_index) :
			if (planets[i][3] == 0):
				planets[i][3] = 1
				planets[i][4].set_hidden(false)
		elif (planets[i][3] == 1) :
			#print ("matou"+planet[0])
			#print (planet[3])
			planets[i][3] = 0
			planets[i][4].set_hidden (true)

func _input(ev):
	if (ev.type==InputEvent.MOUSE_BUTTON):
		if (ev.button_mask == 0 and ev.button_index == 2):
			player.get_child(0).moveTo(ev.pos - get_viewport().get_rect().size/2 + player.get_pos())
		if (ev.button_mask == 0 and ev.button_index == 1):
			var bulletScene = load("res://scenes/bullets/Bullet.scn")
			var bullet = bulletScene.instance()
			bullet.setPosition(player.get_pos(), ev.pos - get_viewport().get_rect().size/2)
			add_child(bullet)
			#player.bar.takeDamage(50)

func isInRange (playerPos, planetPos):
	if ((planetPos - playerPos).length() < 600):
		return 1
	return 0

func _ready():
	pass
