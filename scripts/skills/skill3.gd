
extends Node2D

var index

var endTime = 1.0
var finished = 0
var bonusVamp = 0.5
var bonusArm = 30
var bonusShi = 30

var didUseSkill = 0

func _init():
	pass

func _ready():
	pass

func preSetup (i) :
	index = i
	get_parent().player.skillCoolDown[i][2] = 1
	get_parent().player.skillCoolDown[i][1] = - 3.0
	get_parent().player.skillCoolDown[i][0] = 3.0
	get_parent().skills[i].append(self.get_path())
	get_parent().player.bar.luck += 20
	get_parent().player.bar.takeBuff(30, 0, -(index+1))
	get_parent().player.bar.takeBuff(25, 3, -(index+1))
	get_parent().player.bar.takeBuff(25, 4, -(index+1))
	

func setup (i, caster) :
	print (get_parent().player.bar.vampirism)
	index = i
	endTime = OS.get_ticks_msec()/1000.0 + endTime
	self.get_child(0).queue_free()
	set_process(true)
	get_parent().player.skillCoolDown[i][1] = OS.get_ticks_msec()/1000.0
	get_parent().player.movem.dashTo((get_viewport().get_mouse_pos()-get_viewport().get_rect().size/2).normalized()*12*sqrt(get_parent().player.bar.speed)+get_parent().player.get_pos(), 65*sqrt(get_parent().player.bar.speed))
	get_parent().player.bar.takeBuff(40, 1, 1.5)
	get_parent().player.bar.takeBuff(40, 2, 1.5)
	get_parent().player.bar.takeBuff(1.25, 4.5, 1.5)
	return 0
	self.queue_free()

func _process(delta):
	if (OS.get_ticks_msec()/1000.0 > endTime):
		self.queue_free()
		

func setPosition(pos, dir):
	pass