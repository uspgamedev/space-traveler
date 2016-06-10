
extends KinematicBody2D

var movem
var rotationVector = Vector2(0,0)
var camera
var camera3d
var bar

var skillPath = [0, 0, 0, 0]
var skillCoolDown = [[0.0, -0.0, 0], [0.0, -0.0, 0], [0.0, -0.0, 0], [0.0, -0.0, 0]]
var skillPre = [null, null, null, null]

var baseLvXp = 100
var xpScale = 1.2
var level = 0

var hud

var experience = 0

func _init():
	set_process(true)
	camera = get_node("Camera2D")

func _ready():
	movem = self.get_child(0)
	var barScene = load("res://scenes/HealthBar.scn")
	bar = barScene.instance()
	bar.initBar(500.0)
	movem.setSpeed(400)
	add_child(bar)

func Rotate (pos):
	self.get_child(1).set_rot(atan2(pos.x, pos.y)+PI)
	rotationVector = pos

func GetSkills ():
	pass

func getLevel ():
	var xpLeft = experience
	level = 0
	while (xpLeft >= baseLvXp*pow(xpScale,level)) :
		xpLeft -= baseLvXp*pow(xpScale,level)
		level += 1
	print ("level = ", level)
	
	bar.maxHp = 500.0 + level*80.0
	bar.armor = 0 + level*4.0
	bar.shield = 0 + level*4.0
	bar.AP = 0.0 + level*7.0
	bar.AD = 0.0 + level*7.0
	bar.speed = 350.0 + level*4.0
	movem.setSpeed(bar.speed)

func initSkill ():
	for skill in get_parent().skills :
		var newSkillPre = skillPre[get_parent().skills.find(skill)]
		if (newSkillPre != null and weakref(newSkillPre).get_ref()) :
			skillPre[get_parent().skills.find(skill)].queue_free()
		skillPre[get_parent().skills.find(skill)] = load(skillPath[get_parent().skills.find(skill)]).instance()
		get_parent().add_child(skillPre[get_parent().skills.find(skill)])
		skillPre[get_parent().skills.find(skill)].preSetup(get_parent().skills.find(skill))
	movem.setSpeed(bar.speed)

func save():
	var savedict = {
		tag = "player",
		filename = get_filename(),
		xp = experience,
		skill0 = skillPath[0],
		skill1 = skillPath[1],
		skill2 = skillPath[2],
		skill3 = skillPath[3],
	}
	return savedict

func loadG(line):
	experience = line["xp"]
	skillPath[0] = line["skill0"]
	skillPath[1] = line["skill1"]
	skillPath[2] = line["skill2"]
	skillPath[3] = line["skill3"]
	getLevel()
	bar.curHp = bar.maxHp
	initSkill()
	var hudScene = load("res://scenes/Hud.xscn")
	hud = hudScene.instance()
	add_child(hud)
	hud.initHud(skillPre)

func _process(delta):
	pass