
extends Node2D

var finished = 0
var index
var bullet
var angle = 0
var duration = 1000
var duration2 = 500
var iniTime
var iniTime2
var doDamage = []
var direction

var didUseSkill = 0

func _init():
	pass

func _ready():
	pass

func preSetup (i) :
	index = i
	get_parent().player.skillCoolDown[i][2] = 1
	get_parent().player.skillCoolDown[i][1] = - 4.0
	get_parent().player.skillCoolDown[i][0] = 4.0
	get_parent().skills[i].append(self.get_path())
	get_parent().player.bar.takeBuff(40, 3, -(index+1))
	get_parent().player.bar.vampirism += 0.1
	get_parent().player.bar.takeBuff(30, 1, -(index+1))
	get_parent().player.bar.takeBuff(30, 2, -(index+1))
	get_parent().player.bar.maxHp += 200

func setup (i, caster) :
	set_fixed_process(true)
	self.get_child(0).queue_free()
	index = i
	get_parent().player.skillCoolDown[index][2] = 0
	var bulletScene = load("res://scenes/bullets/BulletSk9_1.xscn")
	iniTime = OS.get_ticks_msec()
	bullet = bulletScene.instance()
	add_child(bullet)
	return 0
	
func damage():
	iniTime2 = OS.get_ticks_msec()
	finished = 1
	
func _draw():
	for i in doDamage:
		if (weakref(i).get_ref()):
			if (finished == 0):
				draw_circle(i.get_pos()+i.get_parent().get_pos()-self.get_pos(), 30.0, Color(0.0/255, 137.0/255, 123.0/255, 0.5))
			if (finished == 1):
				draw_circle(i.get_pos()+i.get_parent().get_pos()-self.get_pos(), 30.0, Color(205/255.0, 220/255.0, 57/255.0, 0.5))

func _fixed_process(delta):
	update()
	self.set_pos(self.get_parent().player.get_pos())
	if (finished == 1):
		if (iniTime2 + duration2 <= OS.get_ticks_msec()):
			finished = 2
	if (finished == 2):
		for i in doDamage:
			if (weakref(i).get_ref()):
				direction = (i.get_pos()+i.get_parent().get_pos()-self.get_pos())
				i.bar.takeDamage(250+(i.bar.maxHp - i.bar.curHp)*(0.20+0.2/100.0*get_parent().player.bar.AP), 2, direction)
		get_parent().player.skillCoolDown[index][2] = 1
		get_parent().player.skillCoolDown[index][1] = OS.get_ticks_msec()/1000.0
		self.queue_free()
