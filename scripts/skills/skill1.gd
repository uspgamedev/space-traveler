
extends Node2D

var charges = 1
var finished = 0
var index

var didHitLast = 0
var didUseSkill = 0

func _init():
	pass

func _ready():
	pass

func preSetup (i) :
	index = i
	get_parent().player.skillCoolDown[i][2] = 1
	get_parent().player.skillCoolDown[i][1] = - 2.0
	get_parent().player.skillCoolDown[i][0] = 2.0
	get_parent().skills[i].append(self.get_path())
	get_parent().player.bar.takeBuff(40, 4, -(index+1))
	get_parent().player.bar.vampirism += 0.15
	get_parent().player.bar.luck += 30
	get_parent().player.bar.takeBuff(20, 1, -(index+1))
	get_parent().player.bar.takeBuff(20, 2, -(index+1))

func setup (i, caster) :
	set_process(true)
	self.get_child(0).queue_free()
	index = i
	get_parent().player.skillCoolDown[index][2] = 0
	index = i
	get_parent().setBullet(i, "res://scenes/bullets/BulletSk1.xscn")
	finished = 1
	return 1

func _process(delta):
	if (finished == 1):
		self.queue_free()
