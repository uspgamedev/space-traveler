
extends Node2D

var frames = 0
var player
var didMove = 0
var rightMouseIsPressed = 0
var indicatorRadious = 30.0
var lastMovePos = Vector2()
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
	update()
	if (frames%10 == 0) :
		checkPlanets()
		if (frames > 1000): 
			frames = 0
	player.Rotate((get_viewport().get_mouse_pos()-get_viewport().get_rect().size/2))
	if (player.bar.curHp == 0):
		var playerScene = load("res://scenes/Player.scn")
		player.queue_free()
		player = playerScene.instance()
		add_child(player)

func _draw():
	if (indicatorRadious > 0):
		draw_circle(lastMovePos, indicatorRadious, Color(178.0/255, 255.0/255, 89.0/255, 0.1))
		indicatorRadious -= 1

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
	#print(ev)
	if (ev.type==InputEvent.KEY):
		if (ev.scancode == 81) :
			doSkill(0)
		elif (ev.scancode == 87) :
			doSkill(1)
		elif (ev.scancode == 69) :
			doSkill(2)
	if (ev.type==InputEvent.MOUSE_BUTTON):
		print(ev.button_index)
		if (ev.is_pressed() && ev.button_index == 2):
			rightMouseIsPressed = 1
			player.get_child(0).moveTo(ev.pos - get_viewport().get_rect().size/2 + player.get_pos())
			lastMovePos = ev.pos - get_viewport().get_rect().size/2 + player.get_child(2).get_camera_screen_center()
			indicatorRadious = 30.0
			if (not didMove) :
				player.baCoolDown[1] -= player.baCoolDown[0]*0.4
				didMove = 1
		else:
			rightMouseIsPressed = 0
		if (ev.is_pressed() && ev.button_index == 1):
			var projectile = getBullet()
			print(projectile)
			if (projectile != "noBullet") :
				var bulletScene = load(projectile)
				var bullet = bulletScene.instance()
				add_child(bullet)
				bullet.setPosition(player.get_pos(), ev.pos - get_viewport().get_rect().size/2)
	if (ev.type==InputEvent.MOUSE_MOTION and rightMouseIsPressed == 1): 
		player.get_child(0).moveTo(ev.pos - get_viewport().get_rect().size/2 + player.get_pos())
		lastMovePos = ev.pos - get_viewport().get_rect().size/2 + player.get_child(2).get_camera_screen_center()
		indicatorRadious = 30.0

func isInRange (playerPos, planetPos):
	if ((planetPos - playerPos).length() < 600):
		return 1
	return 0

func initSkill ():
	for skill in skills :
		skill.append(player.skillPath[skills.find(skill)])

func doSkill (i):
	if (player.skillCoolDown[i][0] + player.skillCoolDown[i][1] < OS.get_ticks_msec()/1000.0) :
		var skPath = player.skillPath[i]
		var skillScene = load(skPath)
		var skill = skillScene.instance()
		add_child(skill)
		skill.setup(i)

func setBullet (i, bltPath):
	for skill in skills :
		skill[0] = 0
	skills[i][0] = 1
	skills[i][1] = bltPath
	player.skillCharges[i] = -1



func getBullet () :
	for skill in skills :
		if (skill[0] == 1): 
			if ((player.skillCharges[skills.find(skill)] > 0 or player.skillCharges[skills.find(skill)] == -1) and player.skillCoolDown[skills.find(skill)][0] + player.skillCoolDown[skills.find(skill)][1] < OS.get_ticks_msec()/1000.0) :
				player.skillCoolDown[skills.find(skill)][1] = OS.get_ticks_msec()/1000.0
				return skill[1]
			else :
				player.skillCharges[skills.find(skill)] = 0
	
	if (player.baCoolDown[0] + player.baCoolDown[1] < OS.get_ticks_msec()/1000.0) :
		player.baCoolDown[1] = OS.get_ticks_msec()/1000.0
		didMove = 0
		return player.basicAttack
	else :
		return "noBullet"

func putToSleep (sce, value) :
	sce.set_process (!value)
	for chi in  sce.get_children () :
		putToSleep (chi, value)

func _ready():
	checkPlanets()
	pass
