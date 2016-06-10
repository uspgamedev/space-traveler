
extends Node2D

var index
var charges = 1
var initTime = 0.0
var endTime = 2.0
var oldAS = 0.0
var oldArmor = 0.0
var oldSpeed = 0.0

func _init():
	pass

func _ready():
	pass

func preSetup (i) :
	index = i
	get_parent().player.skillCoolDown[i][2] = 1
	get_parent().player.skillCoolDown[i][1] = - 5.0
	get_parent().player.skillCoolDown[i][0] = 5.0
	get_parent().player.bar.AD += 50
	get_parent().player.bar.armor += 30
	get_parent().player.bar.armor += 30
	self.queue_free()

func setup (i):
	set_fixed_process(true)
	index = i
	get_parent().player.skillCoolDown[index][2] = 0
	initTime = OS.get_ticks_msec()/1000.0
	endTime += initTime
	oldAS = get_parent().player.skillCoolDown[0][0]
	oldArmor = get_parent().player.bar.armor
	oldSpeed = get_parent().player.movem.speed
	get_parent().player.skillCoolDown[0][0] *= 0.1
	get_parent().player.bar.armor += 50
	get_parent().player.bar.barrier += 100 + 0.3*(get_parent().player.bar.maxHp - get_parent().player.bar.curHp)
	get_parent().player.bar.curHp += 0.3*(get_parent().player.bar.maxHp - get_parent().player.bar.curHp)
	get_parent().player.movem.speedMulti *= 1.0/3

func _fixed_process(delta):
	if (OS.get_ticks_msec()/1000.0 > endTime):
		get_parent().player.skillCoolDown[0][0] = oldAS
		get_parent().player.bar.armor = oldArmor
		get_parent().player.movem.speedMulti *= 3
		get_parent().player.skillCoolDown[index][2] = 1
		get_parent().player.skillCoolDown[index][1] = OS.get_ticks_msec()/1000.0
		self.queue_free()
	else :
		self.set_pos(get_parent().player.get_pos())
		update()

func _draw():
	draw_circle(Vector2(0, 0), 55.0, Color(255.0/255, 160.0/255, 0.0/255, 0.1))

func setPosition(pos, dir):
	pass