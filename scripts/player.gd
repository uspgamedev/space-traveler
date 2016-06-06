
extends KinematicBody2D

var movem
var rotationVector = Vector2(0,0)
var camera
var camera3d
var bar

var skillPath = [0, 0, 0, 0]
var skillCoolDown = [[0.0, -0.0, 0], [0.0, -0.0, 0], [0.0, -0.0, 0], [0.0, -0.0, 0]]

var baseLvXp = 100
var xpScale = 1.2
var level = 0

var experience = 0
var health = 0.0
var armor = 0.0
var shield = 0.0
var AP = 0.0
var AD = 0.0
var speed = 0.0

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
	
	health = 500.0 + level*150.0
	armor = 0 + level*5.0
	shield = 0 + level*5.0
	AP = 0.0 + level*8.0
	AD = 0.0 + level*8.0
	speed = 350.0 + level*5.0
	bar.maxHp = health
	bar.armor = armor
	bar.shield = shield
	movem.setSpeed(speed)

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

func _process(delta):
	pass