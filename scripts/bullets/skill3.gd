
extends Node2D

var index

var endTime = 1.0
var finished = 0
var bonusVamp = 0.5
var bonusArm = 30
var bonusShi = 30

func _init():
	pass

func _ready():
	pass

func preSetup (i) :
	index = i
	get_parent().player.skillCoolDown[i][2] = 1
	get_parent().player.skillCoolDown[i][1] = - 2.5
	get_parent().player.skillCoolDown[i][0] = 2.5
	get_parent().skills[i].append(self.get_path())
	get_parent().player.bar.takeBuff(15, 0, -3)
	get_parent().player.bar.takeBuff(15, 1, -3)
	get_parent().player.bar.takeBuff(15, 2, -3)
	get_parent().player.bar.takeBuff(15, 3, -3)
	get_parent().player.bar.takeBuff(15, 4, -3)
	get_parent().player.bar.AD += 10
	

func setup (i):
	print (get_parent().player.bar.vampirism)
	index = i
	endTime = OS.get_ticks_msec()/1000.0 + endTime
	self.get_child(0).queue_free()
	set_process(true)
	#get_parent().player.skillCoolDown[index][2] = 0
	get_parent().player.skillCoolDown[i][1] = OS.get_ticks_msec()/1000.0
	#get_parent().player.skillCoolDown[index][2] = 1
	get_parent().player.movem.moveTo((get_viewport().get_mouse_pos()-get_viewport().get_rect().size/2).normalized()*20*sqrt(get_parent().player.bar.speed)+get_parent().player.get_pos(), 100*sqrt(get_parent().player.bar.speed))
	get_parent().player.bar.takeBuff(100, 1, 1.5)
	get_parent().player.bar.takeBuff(100, 2, 1.5)
	get_parent().player.bar.takeBuff(1.5, 4.5, 1.5)
	self.queue_free()

func _process(delta):
	if (OS.get_ticks_msec()/1000.0 > endTime):
		self.queue_free()
		

func setPosition(pos, dir):
	pass