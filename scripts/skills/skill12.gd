
extends Node2D

var charges = 1
var finished = 0

var index

var didUseSkill = 0
var hitCount = 0

func _init():
	pass

func _ready():
	pass

func preSetup (i) :
	index = i
	get_parent().player.skillCoolDown[i][2] = 1
	get_parent().player.skillCoolDown[i][1] = - 5.0
	get_parent().player.skillCoolDown[i][0] = 5.0
	get_parent().skills[i].append(self.get_path())
	get_parent().player.bar.takeBuff(40, 3, -(index+1))
	get_parent().player.bar.takeBuff(40, 4, -(index+1))
	get_parent().player.bar.takeBuff(50, 0, -(index+1))
	#self.queue_free()

func setup (i, caster) :
	set_process(true)
	self.get_child(0).queue_free()
	index = i
	get_parent().player.skillCoolDown[index][2] = 0
	get_parent().setBullet(i, "res://scenes/bullets/SetupSk12.xscn")
	finished = 1
	return 1

func _process(delta):
	if (finished == 1):
		self.queue_free()

