
extends Node

var frames = 0
var player
var skills = [
[0],
[0],
[0]
]
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
		planet[4].set_process(true)
	initSkill()

func _process(delta):
	frames += 1
	if (frames%10 == 0) :
		checkPlanets()
		if (frames > 1000): 
			frames = 0
	player.Rotate((get_viewport().get_mouse_pos()-get_viewport().get_rect().size/2))

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
				putToSleep(planets[i][4], false)
				planets[i][4].set_hidden(false)
		else :
			planets[i][3] = 0
			if ((planets[i][4].is_processing()) == true) :
				putToSleep(planets[i][4], true)
				planets[i][4].set_hidden (true)

func _input(ev):
	if (ev.type==InputEvent.KEY):
		if (ev.scancode == 81) :
			setSkill(0)
	if (ev.type==InputEvent.MOUSE_BUTTON):
		if (ev.button_mask == 0 and ev.button_index == 2):
			player.get_child(0).moveTo(ev.pos - get_viewport().get_rect().size/2 + player.get_pos())
		if (ev.button_mask == 0 and ev.button_index == 1):
			#print (getSkill())
			var bulletScene = load(getSkill())
			var bullet = bulletScene.instance()
			add_child(bullet)
			bullet.setPosition(player.get_pos(), ev.pos - get_viewport().get_rect().size/2)

func isInRange (playerPos, planetPos):
	if ((planetPos - playerPos).length() < 600):
		return 1
	return 0

func initSkill ():
	for skill in skills :
		skill.append(player.skillPath[skills.find(skill)])

func setSkill (i):
	for skill in skills :
		skill[0] = 0
	skills[i][0] = 1
	skills[i][1] = player.skillPath[i]
	player.skillCharges[i] = -1

func getSkill () :
	for skill in skills :
		if (skill[0] == 1): 
			#print (player.skillCharges[skills.find(skill)])
			if (player.skillCharges[skills.find(skill)] > 0 or player.skillCharges[skills.find(skill)] == -1) :
				print ("dont care")
				print (player.skillCharges[skills.find(skill)])
				print (skills.find(skill))
				return skill[1]
	return player.basicAttack

func putToSleep (sce, value) :
	sce.set_process (!value)
	for chi in  sce.get_children () :
		putToSleep (chi, value)

func _ready():
	checkPlanets()
	pass
