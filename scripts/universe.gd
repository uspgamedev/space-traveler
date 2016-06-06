
extends Node2D

var frames = 0
var save
var player
var didMove = 0
var rightMouseIsPressed = 0
var indicatorRadious = 30.0
var lastMovePos = Vector2()
var skills = [[0], [0], [0], [0]]
var planets = [["p1", -800, -800, 0], ["p2",1000,1000, 0]]
var projectiles = []

func _init():
	set_process_input(true)
	set_process(true)
	var playerScene = load("res://scenes/Player.scn")
	player = playerScene.instance()
	add_child(player)
	player.add_to_group("Persist", true)
	var saveScene = load("res://scenes/Save.xscn")
	save = saveScene.instance()
	add_child(save)
	var name
	for planet in planets :
		var p
		var planetScene = load("res://scenes/planets/"+planet[0]+".xscn")
		p = planetScene.instance()
		planet.append(p)

func _ready():
	save.load_game()
	initSkill()
	checkPlanets()

func _process(delta):
	if (projectiles.size() == 0) :
		doSkill(0)
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
		save.load_game()
		initSkill()

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
				var planetScene = load("res://scenes/planets/"+planets[i][0]+".xscn")
				planets[i][4] = planetScene.instance()
				planets[i][4].set_pos(Vector2(planets[i][1], planets[i][2]))
				planets[i][4].set_process(true)
				add_child(planets[i][4])
		else :
			if (planets[i][3] == 1) :
				planets[i][3] = 0
				planets[i][4].queue_free()

func _input(ev):
	if (ev.type==InputEvent.KEY):
		if (ev.scancode == 81) :
			doSkill(1)
		elif (ev.scancode == 87) :
			doSkill(2)
		elif (ev.scancode == 69) :
			doSkill(3)
	if (ev.type==InputEvent.MOUSE_BUTTON):
		if (ev.is_pressed() && ev.button_index == 2):
			rightMouseIsPressed = 1
			player.get_child(0).moveTo(ev.pos - get_viewport().get_rect().size/2 + player.get_pos())
			lastMovePos = ev.pos - get_viewport().get_rect().size/2 + player.get_child(2).get_camera_screen_center()
			indicatorRadious = 30.0
			if (not didMove) :
				player.skillCoolDown[0][1] -= player.skillCoolDown[0][0]*0.4
				didMove = 1
		else:
			rightMouseIsPressed = 0
		if (ev.is_pressed() && ev.button_index == 1):
			var projectile = getBullet()
			print(projectile)
			if (projectile != "noBullet") :
				var bulletScene = load(projectile[0])
				var bullet = bulletScene.instance()
				add_child(bullet)
				bullet.shoot(player.get_pos(), ev.pos - get_viewport().get_rect().size/2, projectile[1])
	if (ev.type==InputEvent.MOUSE_MOTION and rightMouseIsPressed == 1): 
		player.get_child(0).moveTo(ev.pos - get_viewport().get_rect().size/2 + player.get_pos())
		lastMovePos = ev.pos - get_viewport().get_rect().size/2 + player.get_child(2).get_camera_screen_center()
		indicatorRadious = 30.0

func initSkill ():
	for skill in skills :
		var skillInst = load(player.skillPath[skills.find(skill)]).instance()
		add_child(skillInst)
		skillInst.preSetup(skills.find(skill))

func doSkill (i):
	if (player.skillCoolDown[i][0] + player.skillCoolDown[i][1] < OS.get_ticks_msec()/1000.0 and player.skillCoolDown[i][2] == 1) :
		if (i == 0) :
			didMove = 0
		var skill = load(player.skillPath[i]).instance()
		add_child(skill)
		skill.setup(i)

func setBullet (i, bltPath):
	var nextBullet = [bltPath, i]
	print("b p = ", projectiles, "nb = ", nextBullet)
	projectiles.append(nextBullet)

func getBullet () :
	print ("c")
	print ("proj s = ",projectiles.size())
	if ((not projectiles.empty()) and player.skillCoolDown[projectiles[projectiles.size()-1][1]][0] + player.skillCoolDown[projectiles[projectiles.size()-1][1]][1] < OS.get_ticks_msec()/1000.0) :
		var nextBullet = projectiles[projectiles.size()-1]
		print("gb.nb = ", nextBullet)
		projectiles.remove(projectiles.size()-1)
		return nextBullet
	return "noBullet"

func putToSleep (sce, value) :
	sce.set_process (!value)
	for chi in  sce.get_children () :
		putToSleep (chi, value)

func killAll (sce) :
	for chi in  sce.get_children () :
		killAll (chi)
	sce.queue_free ()
