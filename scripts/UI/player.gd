
extends KinematicBody2D

var movem
var rotationVector = Vector2(0,0)
var camera
var camera3d
var bar

var skillPath = [0, 0, 0, 0]
var skillCoolDown = [[0.0, -0.0, 0], [0.0, -0.0, 0], [0.0, -0.0, 0], [0.0, -0.0, 0]]
var skillPre = [null, null, null, null]
var ownedSkills = [[], [], [], []]

var baseLvXp = 150
var xpScale = 1.2
var level = 0

var hud

var STDSPEED = 100

var experience = 0

func _init():
	set_process(true)
	camera = get_node("Camera2D")

func _ready():
	movem = self.get_child(0)
	var barScene = load("res://scenes/UI/HealthBar.scn")
	bar = barScene.instance()
	bar.initBar(500.0)
	movem.setSpeed(400)
	add_child(bar)

func Rotate (pos):
	self.get_child(1).set_rot(atan2(pos.x, pos.y)+PI)
	rotationVector = pos

func GetSkills ():
	pass

func getLevel (curExp):
	var newLevel = 0
	var xpLeft = curExp
	while (xpLeft >= baseLvXp*pow(xpScale,newLevel)) :
		xpLeft -= baseLvXp*pow(xpScale,newLevel)
		newLevel += 1
	experience = curExp
	return newLevel

func initLevel ():
	level = getLevel(experience)
	bar.maxHp = 500.0 + level*50.0
	bar.setArmor(0 + level*5.0)
	bar.setShield(0 + level*5.0)
	bar.setAp(0.0 + level*5.0)
	bar.setAd(0.0 + level*5.0)
	bar.setSpeed(STDSPEED + level*5.0)
	bar.luck = 0.0
	bar.vampirism = 0.0

func getXP (XPadd):
	var newLevel = getLevel(experience+XPadd)
	if (newLevel != level):
		level = newLevel
		bar.takeNerf(level*5.0, 1, 0)
		bar.takeNerf(level*5.0, 2, 0)
		bar.takeNerf(level*5.0, 3, 0)
		bar.takeNerf(level*5.0, 4, 0)
		bar.takeNerf(level*5.0, 0, 0)
		
		level = newLevel
		bar.maxHp = 500.0 + level*50.0
		bar.takeBuff(level*5.0, 1, 0)
		bar.takeBuff(level*5.0, 2, 0)
		bar.takeBuff(level*5.0, 3, 0)
		bar.takeBuff(level*5.0, 4, 0)
		bar.takeBuff(level*5.0, 0, 0)

func initSkill ():
	for skill in get_parent().skills :
		var newSkillPre = skillPre[get_parent().skills.find(skill)]
		if (newSkillPre != null and weakref(newSkillPre).get_ref()) :
			skillPre[get_parent().skills.find(skill)].queue_free()
		skillPre[get_parent().skills.find(skill)] = load(skillPath[get_parent().skills.find(skill)]).instance()
		get_parent().add_child(skillPre[get_parent().skills.find(skill)])
		skillPre[get_parent().skills.find(skill)].preSetup(get_parent().skills.find(skill))
	movem.setSpeed(bar.speed)

func recieveItem (item, index):
	ownedSkills[index].append(item)

func save():
	var savedict = {
		tag = "player",
		filename = get_filename(),
		xp = experience,
		skill0 = skillPath[0],
		skill1 = skillPath[1],
		skill2 = skillPath[2],
		skill3 = skillPath[3]
	}
	print (ownedSkills.size())
	for skillSet in ownedSkills :
		for skill in skillSet :
			savedict["os" + str(ownedSkills.find(skillSet)) + "_" + str(ownedSkills[ownedSkills.find(skillSet)].find(skill))] = skill
	
	return savedict

func loadG(line):
	ownedSkills = [[], [], [], []]
	experience = line["xp"]
	skillPath[0] = line["skill0"]
	skillPath[1] = line["skill1"]
	skillPath[2] = line["skill2"]
	skillPath[3] = line["skill3"]
	for item in line :
		if (item[0] == "o") :
			ownedSkills[int(item[2])].append(line[item])
	bar.removeItemFX()
	initLevel()
	initSkill()
	var hudScene = load("res://scenes/UI/Hud.xscn")
	if (hud != null and weakref(hud).get_ref()) :
		hud.queue_free()
	hud = hudScene.instance()
	add_child(hud)
	hud.initHud(skillPre)

func _process(delta):
	pass