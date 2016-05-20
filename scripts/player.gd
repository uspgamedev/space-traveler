
extends KinematicBody2D

var movem
var rotationVector = Vector2(0,0)
var camera
var camera3d
var bar
var skillPath = [0, 0, 0, 0]#["res://scenes/bullets/BasicAttack1.xscn", "res://scenes/bullets/Skill5.xscn", "res://scenes/bullets/Skill3.xscn", "res://scenes/bullets/Skill2.xscn"]
var skillCharges = [0, 0, 0, 0]
var skillCoolDown = [[0.7, -0.7], [3.5, -3.5], [1.5, -1.5], [5.0, -5.0]]


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

func save():
	var savedict = {
		tag = "player",
		filename = get_filename(),
		skill0 = skillPath[0],
		skill1 = skillPath[1],
		skill2 = skillPath[2],
		skill3 = skillPath[3],
	}
	return savedict

func loadG(line):
	skillPath[0] = line["skill0"]
	skillPath[1] = line["skill1"]
	skillPath[2] = line["skill2"]
	skillPath[3] = line["skill3"]

func _process(delta):
	pass